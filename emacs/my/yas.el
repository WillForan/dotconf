; 20180626 -- no indents on yas templates
(use-package yasnippet :ensure t :defer t
  :config
   (setq yas/indent-line nil)
   (yas-reload-all)
   (yas-minor-mode))
