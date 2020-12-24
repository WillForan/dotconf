;; company - in buffer compltion framework
(use-package company :ensure t :defer f
  :bind ("C-<tab>" . company-complete)
  :init
   (add-hook 'after-init-hook 'global-company-mode)
)
