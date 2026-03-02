(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(centaur-tabs company doom-themes magit markdown-mode
		  multiple-cursors nyan-mode rust-mode
		  timu-caribbean-theme typst-ts-mode
		  visual-fill-column vterm)))

;;; appearance
(add-to-list 'default-frame-alist '(font . "Input Mono-8"))
(load-theme 'doom-laserwave t)

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
(setq centaur-tabs-set-bar 'over)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

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

;;; meow
(load "~/.emacs.d/meow.el")

;;; packages
(centaur-tabs-mode)
(global-company-mode)
(nyan-mode)

(require 'eglot)
(add-hook 'rust-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)

;;; other hooks
(add-hook 'markdown-mode-hook
          (lambda ()
            (setq-local visual-fill-column-width 90)
            (setq-local display-line-numbers-width-start t)
            (visual-line-mode 1)
            (visual-fill-column-mode 1)))

(custom-set-faces)
