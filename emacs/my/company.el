;; company - in buffer compltion framework
(use-package company :ensure t :defer t
  :init
   (add-hook 'after-init-hook 'global-company-mode)
)
