(use-package posframe :ensure t
  :config
  (use-package which-key :ensure t :config (which-key-mode))
  (use-package which-key-posframe :ensure t :config (which-key-posframe-mode))
  (use-package helm-posframe :ensure t :config (helm-posframe-enable))
  (use-package company-posframe :ensure t :config (company-posframe-mode 1))
 )
