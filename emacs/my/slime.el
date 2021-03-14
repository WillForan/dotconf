;c.f. lisp.el -- for sly
(use-package slime :ensure t
  :config
 (setq inferior-lisp-program "/usr/bin/sbcl")
 (slime-setup '(slime-fancy slime-quicklisp slime-asdf))
)
