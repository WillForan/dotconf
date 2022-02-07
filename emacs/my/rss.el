(use-package elfeed :defer t :ensure t)
(use-package elfeed-protocol :defer t :ensure t
  :config
  (setq minifluxfever (replace-regexp-in-string "\n" "" (shell-command-to-string "pass local/miniflux-fever_url")))
  (setq elfeed-feeds (list (concat "fever+" minifluxfever)))
  (elfeed-protocol-enable))
