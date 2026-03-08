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

  ;; languages
  (dolist (mode '(("\\.njk\\'"   . html-mode)
                  ("\\.ya?ml\\'" . yaml-ts-mode)
                  ("\\.nix\\'"   . nix-ts-mode)))
    (add-to-list 'auto-mode-alist mode))

  (add-hook 'org-mode-hook (lambda ()
			     (setq truncate-lines nil)
			     (setq word-wrap t)))

  :bind
  (("C-x k" . homicide)
   ("C-x K" . murder)
   ("C-+"   . text-scale-increase)
   ("C--"   . text-scale-decrease)
   ("C-0"   . (lambda () (interactive) (text-scale-set 0))))
   ("C-x <right>" . centaur-tabs-forward)
   ("C-x <left>" . centaur-tabs-backward))

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

(use-package emmet-mode
  :ensure t
  :hook ((html-mode css-mode) . emmet-mode))

(use-package company
  :ensure t
  :hook (emacs-startup . global-company-mode))

(use-package eglot
  :hook (prog-mode . cerberus))

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
  (modus-themes-load-theme 'ef-tritanopia-dark))

(use-package centaur-tabs
  :ensure t
  :bind
  :hook (emacs-startup . centaur-tabs-mode))

(use-package nyan-mode
  :ensure t
  :hook (emacs-startup . nyan-mode))

(use-package magit
  :ensure t
  :bind
  (:map magit-mode-map
	("K" . magit-discard)
	("k" . nil)))

;;; languages
(use-package nix-mode
  :ensure t)

(use-package rust-mode
  :ensure t)

(use-package typescript-mode
  :ensure t)

;;; meow
(load (expand-file-name "grawlix.el" user-emacs-directory))
