(use-package gptel :ensure t
  :config
  (gptel-make-gh-copilot "Copilot")
  (setq ;; gptel-model 'claude-3.7-sonnet
      gptel-backend (gptel-make-gh-copilot "Copilot")))
