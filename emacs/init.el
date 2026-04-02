;;; -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;; built-in settings
(use-package emacs
  :init
  (setq inhibit-startup-screen t)
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq mouse-autoselect-window t)
  (put 'downcase-region 'disabled nil)
  (put 'upcase-region 'disabled nil)

  ;; appearance
  (add-to-list 'default-frame-alist '(font . "Input Mono-8"))
  (when (display-graphic-p)
    (tool-bar-mode -1)
    (menu-bar-mode -1)
    (scroll-bar-mode -1))
  (column-number-mode)
  (setq-default display-line-numbers-width 3)
  (setq-default display-line-numbers-grow-only t)
  (setq-default display-line-numbers-type 'relative)
  (add-hook 'after-change-major-mode-hook
            (lambda ()
              (when (buffer-file-name)
                (display-line-numbers-mode 1))))

  (setq initial-scratch-message nil
	initial-major-mode 'text-mode)

  ;; binds
  :bind
  (("C-x k" . homicide)
   ("C-x K" . murder)
   ("C-+"   . text-scale-increase)
   ("C--"   . text-scale-decrease)
   ("C-0"   . (lambda () (interactive) (text-scale-set 0)))))

;;; conditioning
(defun homicide ()
  "Kill the current buffer immediately without prompting.
If the buffer visits a file and has unsaved changes, signal an error."
  (interactive)
  (let ((buf (current-buffer)))
    (when (and (buffer-modified-p buf)
               (buffer-file-name buf))
      (user-error "Buffer %s has unsaved changes; tranquility for now" (buffer-name buf)))
    (kill-buffer buf)))

(defun murder ()
  "Kill the current buffer immediately with no regard to unsaved changes."
  (interactive)
  (let ((buf (current-buffer)))
    (set-buffer-modified-p nil)
    (kill-buffer buf)))

;; eglot
(defun cerberus ()
  (require 'eglot)
  (condition-case _
      (progn
        (eglot--guess-contact)
        (eglot-ensure))
    (error nil)))

;;; packages
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package company
  :ensure t
  :hook (emacs-startup . global-company-mode))

(use-package eglot
  :hook (prog-mode . cerberus))

(use-package evil
  :ensure t
  :init
  (evil-mode))

;; non-vital
(use-package ef-themes
  :ensure t
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  (("<f5>"   . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  (setq modus-themes-mixed-fonts nil)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-bio))

(use-package nyan-mode
  :ensure t
  :hook (emacs-startup . nyan-mode))

(use-package magit
  :ensure t
  :config
  (setq transient-default-level 5
	magit-diff-refine-hunk t
	magit-save-repository-buffers nil
	magit-revision-insert-related-refs nil
	magit-git-executable (or (executable-find magit-git-executable) "git"))
  (setq magit-bury-buffer-function
	(lambda (_) (mapc #'kill-buffer (magit-mode-get-buffers)))))

;;; languages
(use-package nix-mode
  :ensure t)

(use-package rust-mode
  :ensure t)

(use-package typescript-mode
  :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
