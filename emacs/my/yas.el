; 20180626 -- no indents on yas templates
(use-package yasnippet :ensure t :defer t
  :config
   (setq yas/indent-line nil)
   (yas-minor-mode)
   (yas-reload-all)
)
