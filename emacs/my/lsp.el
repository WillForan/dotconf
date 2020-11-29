;; 20200508 - language server protocol 
;; install.packages(“languageserver”)
(use-package lsp-mode :ensure t
  :config
  (setq lsp-diagnostics-modeline-scope :project)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode))

(use-package lsp-treemacs :ensure t)
