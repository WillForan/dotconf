(use-package yasnippet :ensure t :defer f
  :after company-mode
  :config
   ; 20180626 -- no indents on yas templates
   (setq yas/indent-line nil)

   ;; 20210209 - global so 'today' expands everywhere it can
   ;;            alt: (add-hook 'prog-mode-hook #'yas-minor-mode)

   ;; 20220805 - need '1' as only arg
   ;; (yas-global-mode 1)

   ;; 20220818 - magit and repl lost tab with gobal mode. 
   ;;            reload and prog-mode only
   (yas-reload-all)
   (add-hook 'prog-mode-hook #'yas-minor-mode-on)

   ; 20200907 - add yas to copmany backands
   (append company-backends' (:with company-yasnippet))

   ;; 20220307 - quick bash bits
   ;; shebang in own file ~/.emacs.d/snippets/sh-mode
   (yas-define-snippets 'sh-mode '(
     ("iff" "[ -$1 ] && $0" "quick conditional")
     ("regex" "[[ \"$1\" =~ $2 ]] || continue\n$3 = \${BASH_REMATCH[0]}" "regex")
     ("orr" "[ -$1 ] || $0" "not thing")))

)
