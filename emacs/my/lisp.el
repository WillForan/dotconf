
(use-package sly :ensure t
  :config
  (rainbow-delimiters-mode 1)
  (setq inferior-lisp-program "/usr/bin/sbcl")
  ;; org mode defaults to slime, change that
  ;; TODO: does that work if org isn't already sorced?
  (setq org-babel-lisp-eval-fn #'sly-eval)
  (setq sly-enable-evaluate-in-emacs t)
  ;; handled by lispy
  ;;(define-key sly-mrepl-mode-map (kbd "C-'") #'lispy-parens)
  :custom
  (lispy-use-sly t)
  (lisp-mode-hook '(sly-editing-mode ) "REPL instead of slime"))

;; sly addons
(use-package sly-quicklisp :ensure t :after sly)
(use-package sly-asdf :ensure t :after sly)
(use-package sly-macrostep :ensure t :after sly)

;(use-package smartparens :ensure t
;  :config
;  (require 'smartparens-config)
;  (add-hook 'lisp-mode-hook #'smartparens-mode))
(use-package lispy :ensure t
  :config
  (add-hook 'lisp-mode-hook #'lispy-mode)
  (add-hook 'elisp-mode-hook #'lispy-mode)
  :custom
  (lispy-no-space t) ; ':' -> ' :' is disruptive!
  :bind
					; ctrl bound to capslock this is both pinkys at the same time
  ("C-'" . lispy-parens))

;; 20210502
;; https://wikemacs.org/wiki/Lisp_editing
(use-package evil-cleverparens :ensure t
 :config
 (add-hook 'lisp-mode-hook #'evil-cleverparens-mode)
 (add-hook 'elisp-mode-hook #'evil-cleverparens-mode))
