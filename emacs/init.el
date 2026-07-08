;;; -*- lexical-binding: t -*-

(setq custom-file (expand-file-name "config.el" user-emacs-directory))

(setq straight-use-package-by-default t)

;;; built-in settings
(use-package emacs
  :init
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq mouse-autoselect-window t)
  (put 'downcase-region 'disabled nil)
  (put 'upcase-region 'disabled nil)

  ;; shut up
  (setq ring-bell-function 'ignore)
  (let ((busy nil)
	(buffers '(("*Messages*" . " *Messages*")
                   ("*Completions*" . " *Completions*")
                   ("*straight-process*" . " *straight-process*"))))
    (let ((f (lambda ()
               (unless busy
		 (let ((busy t))
                   (dolist (pair buffers)
                     (when-let* ((buf (get-buffer (car pair))))
                       (when-let* ((old (get-buffer (cdr pair))))
			 (kill-buffer old))
                       (with-current-buffer buf
			 (rename-buffer (cdr pair))))))))))
      (add-hook 'buffer-list-update-hook f)
      (add-hook 'after-init-hook f)))

  ;; ispell
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_GB")
  (setq ispell-alternate-dictionary
	(expand-file-name "wordlist" user-emacs-directory))

  ;; appearance
  (add-to-list 'default-frame-alist '(font . "Input Mono-8"))
  (column-number-mode)
  (setq-default display-line-numbers-width 3)
  (setq-default display-line-numbers-grow-only t)
  (setq-default display-line-numbers-type 'relative)
  (add-hook 'after-change-major-mode-hook
            (lambda ()
              (when (buffer-file-name)
                (display-line-numbers-mode 1))))

  ;; binds
  :bind
  (("C-x K" . murder)
   ("C-="   . text-scale-increase)
   ("C--"   . text-scale-decrease)
   ("C-0"   . (lambda () (interactive) (text-scale-set 0)))))

;;; conditioning
(defun murder ()
  "Kill the current buffer immediately with no regard to unsaved changes."
  (interactive)
  (let ((buf (current-buffer)))
    (set-buffer-modified-p nil)
    (kill-buffer buf)))

(global-visual-line-mode 1)
(electric-pair-mode 1)

;;; packages
(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

(use-package vertico
  :hook (after-init . vertico-mode))

(use-package savehist
  :hook (after-init . savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :hook (after-init . marginalia-mode))

(use-package which-key
  :hook (after-init . which-key-mode))

(use-package company
  :hook (emacs-startup . global-company-mode)
  :config
  (dolist (hook '(markdown-mode-hook org-mode-hook))
    (add-hook hook
	      (lambda ()
		(setq-local company-backends
			    '((company-ispell company-dabbrev) company-files))
		(setq-local company-minimum-prefix-length 3)))))

(use-package eglot
  :hook ((prog-mode astro-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '(astro-mode . ("astro-ls" "--stdio"
                               :initializationOptions
                               (:typescript (:tsdk "./node_modules/typescript/lib"))))))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :hook (after-init . evil-mode)
  :custom
  (evil-undo-system 'undo-redo)
  (evil-respect-visual-line-mode t)
  :config
  (define-key evil-normal-state-map (kbd "%") (kbd "ggVG")))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init '(magit dired)))

(use-package multiple-cursors
  :after evil
  :custom
  (mc/always-run-for-all t)
  (mc/always-repeat-command t)
  :config
  (define-key evil-normal-state-map (kbd "M-n") #'mc/mark-next-like-this)
  (define-key evil-visual-state-map (kbd "M-n") #'mc/mark-next-like-this)
  (define-key evil-normal-state-map (kbd "M-p") #'mc/mark-previous-like-this)
  (define-key evil-visual-state-map (kbd "M-p") #'mc/mark-previous-like-this)
  (define-key evil-normal-state-map (kbd "M-A") #'mc/mark-all-like-this)
  (define-key evil-visual-state-map (kbd "M-A") #'mc/mark-all-like-this)
  (define-key evil-normal-state-map (kbd "M-s") #'mc/skip-to-next-like-this)
  (define-key evil-visual-state-map (kbd "M-s") #'mc/skip-to-next-like-this)
  (define-key evil-normal-state-map (kbd "M-u") #'mc/unmark-next-like-this)
  (define-key evil-visual-state-map (kbd "M-u") #'mc/unmark-next-like-this)
  (define-key mc/keymap (kbd "C-c") #'mc/keyboard-quit))

;; non-vital
(use-package ef-themes
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  (("<f5>"   . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  (setq modus-themes-mixed-fonts nil)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-elea-dark))

(use-package nyan-mode
  :hook (emacs-startup . nyan-mode))

(use-package magit
  :defer t
  :config
  (setq transient-default-level 5
	magit-diff-refine-hunk t
	magit-save-repository-buffers nil
	magit-revision-insert-related-refs nil
	magit-git-executable (or (executable-find magit-git-executable) "git"))
  (setq magit-bury-buffer-function
	(lambda (_) (mapc #'kill-buffer (magit-mode-get-buffers)))))

(use-package eat
  :defer t)

(use-package htmlize
  :defer t)

;;; languages
(use-package markdown-mode)

(use-package nix-mode)

(use-package rust-mode)

(use-package typescript-mode)

(use-package emmet-mode
  :hook (html-mode . emmet-mode))

(use-package web-mode)

(define-derived-mode astro-mode web-mode "Astro"
  "Major mode for editing Astro components.")

(add-to-list 'auto-mode-alist '("\\.astro\\'" . astro-mode))

(load custom-file 'noerror)
