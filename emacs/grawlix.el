(use-package meow
  :ensure t
  :config

  ;;; custom funcs to emulate helix
  (defun helix/insert-line-start ()
    "Insert at the first non-whitespace character of the line."
    (interactive)
    (back-to-indentation)
    (meow-insert))

  (defun helix/insert-line-end ()
    "Insert at the end of the line."
    (interactive)
    (end-of-line)
    (meow-insert))

  (defun helix/replace-char (char)
    "Replace each character in the current selection with CHAR."
    (interactive "cReplace with char: ")
    (let ((beg (if (use-region-p) (region-beginning) (point)))
          (end (if (use-region-p) (region-end) (1+ (point)))))
      (save-excursion
        (goto-char beg)
        (while (< (point) end)
          (if (char-equal (char-after) ?\n)
              (forward-char 1)
            (delete-char 1)
            (insert char))))))

  (defun helix/find-prev ()
    "Find previous character."
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'meow-find)))

  (defun helix/till-prev ()
    "Find till previous character."
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'meow-till)))

  (defun helix/search-prev ()
    "Select previous search match."
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'meow-search)))

  (defun helix/paste-before ()
    "Paste before selection."
    (interactive)
    (when (use-region-p)
      (goto-char (region-beginning)))
    (meow-yank))

  (defun helix/copy-keep ()
    "Copy selection without canceling it."
    (interactive)
    (when (use-region-p)
      (let ((deactivate-mark nil))
	(kill-ring-save (region-beginning) (region-end)))))

  (defun helix/collapse-selection ()
    "Collapse selection onto a single cursor."
    (interactive)
    (meow-cancel-selection))

  (defun helix/scroll-half-page-down ()
    "Scroll down by half a page."
    (interactive)
    (setq-local scroll-preserve-screen-position t)
    (scroll-up-command (/ (window-body-height) 2)))

  (defun helix/scroll-half-page-up ()
    "Scroll up by half a page."
    (interactive)
    (setq-local scroll-preserve-screen-position t)
    (scroll-down-command (/ (window-body-height) 2)))

  (defun helix/delete-selection ()
    "Delete the current selection."
    (interactive)
    (if (use-region-p)
	(let* ((key (kbd "C-w"))
               (map meow-normal-state-keymap)
               (orig (lookup-key map key)))
          (define-key map key nil)
          (unwind-protect
              (call-interactively 'meow-kill)
            (define-key map key orig)))
      (unless (eobp)
	(kill-region (point) (1+ (point))))))

  (defun helix/pipe-selection (cmd)
    "Pipe the current selection through a shell command, replacing it with output."
    (interactive "sShell command on region: ")
    (let ((start (if (use-region-p) (region-beginning) (point)))
          (end (if (use-region-p) (region-end) (line-end-position))))
      (shell-command-on-region start end cmd nil t)
      (when (eq (char-before (region-end)) ?\n)
	(save-excursion
          (goto-char (region-end))
          (delete-char -1)))))

  ;;; minor mode maps
  (define-prefix-command 'helix/goto-map)
  (define-key helix/goto-map (kbd "g") 'beginning-of-buffer)
  (define-key helix/goto-map (kbd "e") 'end-of-buffer)
  (define-key helix/goto-map (kbd "h") 'beginning-of-line)
  (define-key helix/goto-map (kbd "l") 'end-of-line)
  (define-key helix/goto-map (kbd "s") 'back-to-indentation)
  (define-key helix/goto-map (kbd "d") 'xref-find-definitions)
  (define-key helix/goto-map (kbd "r") 'xref-find-references)
  (define-key helix/goto-map (kbd "y") 'xref-find-definitions-other-window)
  (define-key helix/goto-map (kbd "a") 'project-find-file)
  (define-key helix/goto-map (kbd "t") 'move-to-window-line-top-bottom)
  (define-key helix/goto-map (kbd "b") (lambda () (interactive) (move-to-window-line-top-bottom -1)))
  (define-key helix/goto-map (kbd "c") (lambda () (interactive) (move-to-window-line-top-bottom 0)))

  (define-prefix-command 'helix/match-map)
  (define-key helix/match-map (kbd "m") 'meow-block)
  (define-key helix/match-map (kbd "i") 'meow-inner-of-thing)
  (define-key helix/match-map (kbd "a") 'meow-bounds-of-thing)
  (define-key helix/match-map (kbd "s") 'meow-bounds-of-thing)

  (define-prefix-command 'helix/window-map)
  (define-key helix/window-map (kbd "w") 'other-window)
  (define-key helix/window-map (kbd "v") 'split-window-right)
  (define-key helix/window-map (kbd "s") 'split-window-below)
  (define-key helix/window-map (kbd "h") 'windmove-left)
  (define-key helix/window-map (kbd "j") 'windmove-down)
  (define-key helix/window-map (kbd "k") 'windmove-up)
  (define-key helix/window-map (kbd "l") 'windmove-right)
  (define-key helix/window-map (kbd "q") 'delete-window)
  (define-key helix/window-map (kbd "o") 'delete-other-windows)
  (define-key helix/window-map (kbd "H") 'windmove-swap-states-left)
  (define-key helix/window-map (kbd "J") 'windmove-swap-states-down)
  (define-key helix/window-map (kbd "K") 'windmove-swap-states-up)
  (define-key helix/window-map (kbd "L") 'windmove-swap-states-right)

  (define-prefix-command 'helix/view-map)
  (define-key helix/view-map (kbd "z") 'recenter-top-bottom)
  (define-key helix/view-map (kbd "c") 'recenter-top-bottom)
  (define-key helix/view-map (kbd "t") (lambda () (interactive) (recenter 0)))
  (define-key helix/view-map (kbd "b") (lambda () (interactive) (recenter -1)))
  (define-key helix/view-map (kbd "m") 'recenter-top-bottom)
  (define-key helix/view-map (kbd "j") 'scroll-up-line)
  (define-key helix/view-map (kbd "k") 'scroll-down-line)

  (define-prefix-command 'helix/unimpaired-next-map)
  (define-key helix/unimpaired-next-map (kbd "d") 'flymake-goto-next-error)
  (define-key helix/unimpaired-next-map (kbd "p") 'forward-paragraph)
  (define-key helix/unimpaired-next-map (kbd "SPC") (lambda () (interactive) (save-excursion (end-of-line) (newline))))

  (define-prefix-command 'helix/unimpaired-prev-map)
  (define-key helix/unimpaired-prev-map (kbd "d") 'flymake-goto-prev-error)
  (define-key helix/unimpaired-prev-map (kbd "p") 'backward-paragraph)
  (define-key helix/unimpaired-prev-map (kbd "SPC") (lambda () (interactive) (save-excursion (beginning-of-line) (newline) (forward-line -1))))

  ;;; master setup
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)

    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))

    (meow-leader-define-key
     '("f" . project-find-file)
     '("F" . find-file)
     '("b" . switch-to-buffer)
     '("k" . display-local-help)
     '("a" . eglot-code-actions)
     '("r" . eglot-rename)
     '("d" . flymake-show-buffer-diagnostics)
     '("y" . kill-ring-save)
     '("p" . yank)
     '("/" . project-find-regexp)
     '("?" . execute-extended-command)
     '("w" . helix/window-map)
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("u" . meow-universal-argument))

    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)

     ;; movement
     '("h" . meow-left)
     '("j" . meow-next)
     '("k" . meow-prev)
     '("l" . meow-right)
     '("H" . meow-left-expand)
     '("L" . meow-right-expand)
     '("C" . mc/mark-next-like-this)

     ;; word motions
     '("w" . meow-next-word)
     '("b" . meow-back-word)
     '("e" . meow-next-symbol)
     '("W" . meow-mark-word)
     '("B" . meow-back-symbol)
     '("E" . meow-mark-symbol)

     ;; seek character equivalents
     '("t" . meow-till)
     '("f" . meow-find)
     '("T" . helix/till-prev)
     '("F" . helix/find-prev)

     ;; line selection overrides
     '("x" . meow-line)
     '("X" . meow-goto-line)
     '("%" . mark-whole-buffer)

     ;; scrolling / jumping
     '("C-d" . helix/scroll-half-page-down)
     '("C-u" . helix/scroll-half-page-up)
     '("C-o" . xref-go-back)
     '("TAB" . xref-go-forward)

     ;; insertion and changes
     '("r" . helix/replace-char)
     '("R" . meow-replace)
     '("~" . upcase-region)
     '("`" . downcase-region)
     '("i" . meow-insert)
     '("a" . meow-append)
     '("I" . helix/insert-line-start)
     '("A" . helix/insert-line-end)
     '("o" . meow-open-below)
     '("O" . meow-open-above)
     '("u" . meow-undo)
     '("U" . undo-redo)
     '("y" . helix/copy-keep)
     '("p" . meow-yank)
     '("P" . helix/paste-before)
     '("d" . helix/delete-selection)
     '("c" . meow-change)
     '(">" . indent-rigidly-right-to-tab-stop)
     '("<" . indent-rigidly-left-to-tab-stop)
     '("=" . indent-region)
     '("|" . helix/pipe-selection)
     '("C-c" . comment-line)

     ;; selection manipulation
     '("s" . meow-visit)
     '("S" . meow-search)
     '(";" . helix/collapse-selection)
     '("M-;" . meow-reverse)
     '("J" . delete-indentation)
     '("&" . align-regexp)

     ;; search
     '("/" . meow-visit)
     '("?" . isearch-backward-regexp)
     '("n" . meow-search)
     '("N" . helix/search-prev)

     ;; general overrides
     '("v" . set-mark-command)
     '(":" . execute-extended-command)
     '("<escape>" . meow-cancel-selection)

     ;; delegating to prefix keymaps
     '("g" . helix/goto-map)
     '("m" . helix/match-map)
     '("z" . helix/view-map)
     '("C-w" . helix/window-map)
     '("]" . helix/unimpaired-next-map)
     '("[" . helix/unimpaired-prev-map)))

  (meow-setup)
  (meow-global-mode 1))
