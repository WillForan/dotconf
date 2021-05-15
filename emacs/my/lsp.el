;; 20200508 - language server protocol 
;; install.packages(“languageserver”)
(use-package lsp-mode :ensure t
  :config
  (setq lsp-diagnostics-modeline-scope :project)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode))

(use-package lsp-treemacs :ensure t)
(use-package lsp-ivy :ensure t)
(use-package lsp-haskell :ensure t 
  :config
  (add-hook 'haskell-mode-hook #'lsp)
  (add-hook 'haskell-literate-mode-hook #'lsp))
