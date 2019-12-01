(use-package spray :ensure t)
(use-package nov :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))
