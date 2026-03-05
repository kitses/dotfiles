;;; -*- lexical-binding: t; -*-

(use-package meow
  :ensure t
  :config

  ;; stop space from acting as tab in search prompts
  (define-key minibuffer-local-completion-map (kbd "SPC") 'self-insert-command)
  (define-key minibuffer-local-must-match-map (kbd "SPC") 'self-insert-command)

  ;; use consult for xref
  (setq xref-show-definitions-function #'consult-xref
        xref-show-xrefs-function #'consult-xref)

  ;;; custom funcs to emulate helix
  (defun grawlix/insert-line-start ()
    "Insert at the first non-whitespace character of the line."
    (interactive)
    (back-to-indentation)
    (meow-insert))

  (defun grawlix/insert-line-end ()
    "Insert at the end of the line."
    (interactive)
    (end-of-line)
    (meow-insert))

  (defun grawlix/select-line ()
    "Select the current line, including the newline character."
    (interactive)
    (if (use-region-p)
	(forward-line 1)
      (meow-line 1)
      (unless (eobp)
	(forward-char 1))))

  (defun grawlix/replace-char (char)
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

  (defun grawlix/find-prev ()
    "Find previous character."
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'meow-find)))

  (defun grawlix/till-prev ()
    "Find till previous character."
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'meow-till)))

  (defun grawlix/search-prev ()
    "Select previous search match."
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'meow-search)))

  (defun grawlix/paste-before ()
    "Paste before selection."
    (interactive)
    (when (use-region-p)
      (goto-char (region-beginning)))
    (meow-yank))

  (defun grawlix/copy-keep ()
    "Copy selection without canceling it."
    (interactive)
    (when (use-region-p)
      (let ((deactivate-mark nil))
	(kill-ring-save (region-beginning) (region-end)))))

  (defun grawlix/collapse-selection ()
    "Collapse selection onto a single cursor."
    (interactive)
    (meow-cancel-selection))

  (defun grawlix/scroll-half-page-down ()
    "Scroll down by half a page."
    (interactive)
    (setq-local scroll-preserve-screen-position t)
    (scroll-up-command (/ (window-body-height) 2)))

  (defun grawlix/scroll-half-page-up ()
    "Scroll up by half a page."
    (interactive)
    (setq-local scroll-preserve-screen-position t)
    (scroll-down-command (/ (window-body-height) 2)))

  (defun grawlix/delete-selection ()
    "Delete the current selection."
    (interactive)
    (if (use-region-p)
	(delete-region (region-beginning) (region-end))
      (unless (eobp)
	(delete-char 1))))

  (defun grawlix/pipe-selection (cmd)
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
  (define-prefix-command 'grawlix/goto-map)
  (define-key grawlix/goto-map (kbd "g") 'beginning-of-buffer)
  (define-key grawlix/goto-map (kbd "e") 'end-of-buffer)
  (define-key grawlix/goto-map (kbd "h") 'beginning-of-line)
  (define-key grawlix/goto-map (kbd "l") 'end-of-line)
  (define-key grawlix/goto-map (kbd "s") 'back-to-indentation)
  (define-key grawlix/goto-map (kbd "d") 'xref-find-definitions)
  (define-key grawlix/goto-map (kbd "r") 'xref-find-references)
  (define-key grawlix/goto-map (kbd "y") 'xref-find-definitions-other-window)
  (define-key grawlix/goto-map (kbd "a") 'project-find-file)
  (define-key grawlix/goto-map (kbd "t") 'move-to-window-line-top-bottom)
  (define-key grawlix/goto-map (kbd "b") (lambda () (interactive) (move-to-window-line-top-bottom -1)))
  (define-key grawlix/goto-map (kbd "c") (lambda () (interactive) (move-to-window-line-top-bottom 0)))

  (define-prefix-command 'grawlix/match-map)
  (define-key grawlix/match-map (kbd "m") 'meow-block)
  (define-key grawlix/match-map (kbd "i") 'meow-inner-of-thing)
  (define-key grawlix/match-map (kbd "a") 'meow-bounds-of-thing)
  (define-key grawlix/match-map (kbd "s") 'meow-bounds-of-thing)

  (define-prefix-command 'grawlix/window-map)
  (define-key grawlix/window-map (kbd "w") 'other-window)
  (define-key grawlix/window-map (kbd "v") 'split-window-right)
  (define-key grawlix/window-map (kbd "s") 'split-window-below)
  (define-key grawlix/window-map (kbd "h") 'windmove-left)
  (define-key grawlix/window-map (kbd "j") 'windmove-down)
  (define-key grawlix/window-map (kbd "k") 'windmove-up)
  (define-key grawlix/window-map (kbd "l") 'windmove-right)
  (define-key grawlix/window-map (kbd "q") 'delete-window)
  (define-key grawlix/window-map (kbd "o") 'delete-other-windows)
  (define-key grawlix/window-map (kbd "H") 'windmove-swap-states-left)
  (define-key grawlix/window-map (kbd "J") 'windmove-swap-states-down)
  (define-key grawlix/window-map (kbd "K") 'windmove-swap-states-up)
  (define-key grawlix/window-map (kbd "L") 'windmove-swap-states-right)

  (define-prefix-command 'grawlix/view-map)
  (define-key grawlix/view-map (kbd "z") 'recenter-top-bottom)
  (define-key grawlix/view-map (kbd "c") 'recenter-top-bottom)
  (define-key grawlix/view-map (kbd "t") (lambda () (interactive) (recenter 0)))
  (define-key grawlix/view-map (kbd "b") (lambda () (interactive) (recenter -1)))
  (define-key grawlix/view-map (kbd "m") 'recenter-top-bottom)
  (define-key grawlix/view-map (kbd "j") 'scroll-up-line)
  (define-key grawlix/view-map (kbd "k") 'scroll-down-line)

  (define-prefix-command 'grawlix/unimpaired-next-map)
  (define-key grawlix/unimpaired-next-map (kbd "d") 'flymake-goto-next-error)
  (define-key grawlix/unimpaired-next-map (kbd "p") 'forward-paragraph)
  (define-key grawlix/unimpaired-next-map (kbd "SPC") (lambda () (interactive) (save-excursion (end-of-line) (newline))))

  (define-prefix-command 'grawlix/unimpaired-prev-map)
  (define-key grawlix/unimpaired-prev-map (kbd "d") 'flymake-goto-prev-error)
  (define-key grawlix/unimpaired-prev-map (kbd "p") 'backward-paragraph)
  (define-key grawlix/unimpaired-prev-map (kbd "SPC") (lambda () (interactive) (save-excursion (beginning-of-line) (newline) (forward-line -1))))

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
     '("b" . consult-buffer)
     '("k" . display-local-help)
     '("a" . eglot-code-actions)
     '("r" . eglot-rename)
     '("d" . consult-flymake)
     '("y" . kill-ring-save)
     '("M-w" . kill-ring-save)
     '("p" . yank)
     '("/" . consult-ripgrep)
     '("?" . execute-extended-command)
     '("w" . grawlix/window-map)
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
     '("T" . grawlix/till-prev)
     '("F" . grawlix/find-prev)

     ;; line selection overrides
     '("x" . grawlix/select-line)
     '("X" . consult-goto-line)
     '("%" . mark-whole-buffer)

     ;; scrolling / jumping
     '("C-d" . grawlix/scroll-half-page-down)
     '("C-u" . grawlix/scroll-half-page-up)
     '("C-o" . xref-go-back)
     '("TAB" . xref-go-forward)

     ;; insertion and changes
     '("r" . grawlix/replace-char)
     '("R" . meow-replace)
     '("~" . upcase-region)
     '("`" . downcase-region)
     '("i" . meow-insert)
     '("a" . meow-append)
     '("I" . grawlix/insert-line-start)
     '("A" . grawlix/insert-line-end)
     '("o" . meow-open-below)
     '("O" . meow-open-above)
     '("u" . meow-undo)
     '("U" . undo-redo)
     '("y" . grawlix/copy-keep)
     '("p" . meow-yank)
     '("P" . grawlix/paste-before)
     '("d" . grawlix/delete-selection)
     '("c" . meow-change)
     '(">" . indent-rigidly-right-to-tab-stop)
     '("<" . indent-rigidly-left-to-tab-stop)
     '("=" . indent-region)
     '("|" . grawlix/pipe-selection)
     '("C-c" . comment-line)

     ;; selection manipulation
     '("s" . meow-visit)
     '("S" . meow-search)
     '(";" . grawlix/collapse-selection)
     '("M-;" . meow-reverse)
     '("J" . delete-indentation)
     '("&" . align-regexp)

     ;; search
     '("/" . meow-visit)
     '("?" . isearch-backward-regexp)
     '("n" . meow-search)
     '("N" . grawlix/search-prev)

     ;; general overrides
     '("v" . set-mark-command)
     '(":" . execute-extended-command)
     '("<escape>" . meow-cancel-selection)

     ;; delegating to prefix keymaps
     '("g" . grawlix/goto-map)
     '("m" . grawlix/match-map)
     '("z" . grawlix/view-map)
     '("C-w" . grawlix/window-map)
     '("]" . grawlix/unimpaired-next-map)
     '("[" . grawlix/unimpaired-prev-map)))

  (meow-setup)
  (meow-global-mode 1))

(use-package consult
  :ensure t
  :after meow)
