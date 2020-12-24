(use-package yasnippet :ensure t :defer f
  :after company-mode
  :config
   ; 20180626 -- no indents on yas templates
   (setq yas/indent-line nil)

   (yas-reload-all)
   (add-hook 'prog-mode-hook #'yas-minor-mode)

   ; 20200907 - add yas to copmany backands
   (append company-backends' (:with company-yasnippet))
)
