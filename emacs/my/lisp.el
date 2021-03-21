(use-package sly :ensure t
  :config
 (rainbow-delimiters-mode 1)
 (setq inferior-lisp-program "/usr/bin/sbcl")
 :custom
 ; slime-lisp-mode-hook
  (lisp-mode-hook '(sly-editing-mode ) "REPL instead of slime"))
