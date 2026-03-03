(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(centaur-tabs company doom-themes ef-themes emmet-mode magit
		  markdown-mode meow mood-line multiple-cursors
		  nix-ts-mode nyan-mode rust-mode timu-caribbean-theme
		  typst-ts-mode visual-fill-column vterm yaml-mode)))

;;; appearance
(add-to-list 'default-frame-alist '(font . "Input Mono-8"))

(use-package ef-themes
  :ensure t
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  (setq modus-themes-mixed-fonts nil)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-tritanopia-dark))

(when (display-graphic-p)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1))

(column-number-mode)
(setq-default display-line-numbers-width 3)
(setq-default display-line-numbers-grow-only t)

(add-hook 'after-change-major-mode-hook
          (lambda ()
            (when (buffer-file-name)
              (display-line-numbers-mode 1))))

;;; defaults
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq mouse-autoselect-window t)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;; modes
(dolist (mode '(("\\.njk\\'"   . html-mode)
                ("\\.ya?ml\\'" . yaml-ts-mode)
                ("\\.nix\\'"   . nix-ts-mode)))
  (add-to-list 'auto-mode-alist mode))

(dolist (hook '(html-mode-hook css-mode-hook))
  (add-hook hook 'emmet-mode))

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

(global-set-key (kbd "C-x k") #'homicide)
(global-set-key (kbd "C-x K") #'murder)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") (lambda () (interactive) (text-scale-set 0)))

;; eglot
(defun cerberus ()
  (require 'eglot)
  (condition-case _
      (progn
        (eglot--guess-contact)
        (eglot-ensure))
    (error nil)))

;;; meow
(load "~/.emacs.d/grawlix.el")

;;; packages
(add-hook 'emacs-startup-hook
          (lambda ()
            (centaur-tabs-mode)
            (global-company-mode)
            (nyan-mode)))

(add-hook 'prog-mode-hook #'cerberus)

;;; other hooks
(add-hook 'markdown-mode-hook
          (lambda ()
            (setq-local visual-fill-column-width 90)
            (setq-local display-line-numbers-width-start t)
            (visual-line-mode 1)
            (visual-fill-column-mode 1)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
