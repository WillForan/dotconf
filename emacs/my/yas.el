(use-package yasnippet :ensure t :defer f
  :after company-mode
  :config
   ; 20180626 -- no indents on yas templates
   (setq yas/indent-line nil)

   (yas-global-mode) ; 20210209 - want 'today' to expand everywhere it can
   (yas-reload-all)
   (add-hook 'prog-mode-hook #'yas-minor-mode)

   ; 20200907 - add yas to copmany backands
   (append company-backends' (:with company-yasnippet))

   ;; 20220307 - quick bash bits
   ;; shebang in own file ~/.emacs.d/snippets/sh-mode
   (yas-define-snippets 'sh-mode '(
     ("iff" "[ -$1 ] && $0" "quick conditional")
     ("regex" "[[ \"$1\" =~ $2 ]] || continue\n$3 = \${BASH_REMATCH[0]}" "regex")
     ("orr" "[ -$1 ] || $0" "not thing")))

)
