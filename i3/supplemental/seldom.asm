DEFAULT REL

section .data
    mpd_cmd      db "/usr/bin/mpd", 0
    scribble_cmd db "/usr/bin/mpdscribble", 0
    arg_str      db "--no-daemon", 0

section .bss
    pids resd 2

section .text
    global _start

_start:
    ; construct the sigaction structure for RT signals on the stack
    ; sa_mask (8 bytes), sa_restorer (8 bytes), sa_flags (8 bytes), sa_handler (8 bytes)
    push 0
    lea rax, [rel sig_restorer]
    push rax
    push 0x04000000             ; SA_RESTORER
    lea rax, [rel sig_handler]
    push rax

    mov rsi, rsp                ; rsi = pointer to struct sigaction
    push 13                     ; sys_rt_sigaction
    pop rax
    push 15                     ; SIGTERM
    pop rdi
    xor edx, edx                ; oldact = NULL
    push 8                      ; sigsetsize = 8
    pop r10
    syscall

    ; locate the envp array
    ; we pushed 4 QWORDS (32 bytes) above, so argc is now offset at rsp+32
    mov rcx, [rsp+32]
    ; envp starts after argc (8 bytes) + argv array (argc*8) + NULL terminator (8 bytes)
    ; stack offset = 32 + 8 + 8 = 48
    lea rbx, [rsp+rcx*8+48]

    ; fork and execute mpd
    lea rdi, [rel mpd_cmd]
    call do_fork_exec
    mov [rel pids], eax         ; save pid_mpd

    ; loop through envp looking for "SCROB="
    mov r12, rbx
.env_loop:
    mov rsi, [r12]
    add r12, 8
    test rsi, rsi
    jz .wait_child              ; end of envp (NULL pointer), skip mpdscribble

    ; 6-byte string comparison
    cmp dword [rsi], 0x4f524353 ; "SCRO"
    jne .env_loop
    cmp word [rsi+4], 0x3d42    ; "B="
    jne .env_loop

    ; check that the value is not empty
    cmp byte [rsi+6], 0
    je .env_loop

    ; SCROB= found, fork and execute mpdscribble
    lea rdi, [rel scribble_cmd]
    call do_fork_exec
    mov [rel pids+4], eax       ; save pid_scribble

.wait_child:
    ; block until a child exits
    push 61                     ; sys_wait4
    pop rax
    push -1                     ; wait for any child (-1)
    pop rdi
    xor esi, esi                ; wstatus = NULL
    xor edx, edx                ; options = 0
    xor r10d, r10d              ; rusage = NULL
    syscall
    cmp eax, -4                 ; interrupted by a signal (-EINTR)?
    je .wait_child

sig_handler:
    ; normal/signal exit route
    mov edi, [rel pids]
    call kill_one
    mov edi, [rel pids+4]
    call kill_one

    xor edi, edi                ; exit code 0
    push 60                     ; sys_exit
    pop rax
    syscall

kill_one:
    test edi, edi
    jz .skip
    push 62                     ; sys_kill
    pop rax
    push 15                     ; SIGTERM
    pop rsi
    syscall
.skip:
    ret

do_fork_exec:
    ; accepts: rdi = command string, rbx = environment pointer
    ; returns: eax = PID of the created child
    push 57                     ; sys_fork
    pop rax
    syscall
    test eax, eax
    jnz .parent                 ; safely return to caller if parent (or fork error)

    ; child execution setup (does not affect parent registers or logic)
    push 0                      ; argv[2] = NULL
    lea rax, [rel arg_str]
    push rax                    ; argv[1] = "--no-daemon"
    push rdi                    ; argv[0] = command string

    mov rsi, rsp                ; assign the built array to rsi (argv)
    mov rdx, rbx                ; rdx = original envp from startup

    push 59                     ; sys_execve
    pop rax
    syscall

    push 1                      ; exit with 1 if execve fails
    pop rdi
    push 60                     ; sys_exit
    pop rax
    syscall
.parent:
    ret

sig_restorer:
    ; mandatory kernel trampoline to return from an RT signal
    push 15                     ; sys_rt_sigreturn
    pop rax
    syscall
