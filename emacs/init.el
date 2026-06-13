;;; -*- lexical-binding: t -*-

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
  (let ((f (lambda ()
	     (dolist (n '(" *Messages*" " *Completions*"))
	       (when-let* ((b (get-buffer (substring n 1))))
		 (when-let* ((old (get-buffer n)))
		   (kill-buffer old))
		 (with-current-buffer b (rename-buffer n)))))))
    (add-hook 'buffer-list-update-hook f)
    (add-hook 'after-init-hook f))

  ;; appearance
  (add-to-list 'default-frame-alist '(font . "Adwaita Mono-9"))
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

;;; packages
(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package savehist
  :hook (after-init . savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package company
  :ensure t
  :hook (emacs-startup . global-company-mode)
  :config
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_GB")
  (setq ispell-alternate-dictionary
	(expand-file-name "wordlist" user-emacs-directory))
  (dolist (hook '(markdown-mode-hook org-mode-hook))
    (add-hook hook
	      (lambda ()
		(setq-local company-backends
			    '((company-ispell company-dabbrev) company-files))
		(setq-local company-minimum-prefix-length 3)))))

(use-package eglot
  :hook (prog-mode . eglot-ensure))

(use-package evil
  :ensure t
  :hook (after-init . evil-mode)
  :custom
  (setq evil-undo-system 'undo-redo))

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
  :ensure t
  :defer t)

(use-package htmlize
  :ensure t
  :defer t)

;;; languages
(use-package markdown-mode
  :ensure t)

(use-package nix-mode
  :ensure t)

(use-package rust-mode
  :ensure t)

(use-package typescript-mode
  :ensure t)

(use-package emmet-mode
  :ensure t
  :hook (html-mode . emmet-mode))

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
