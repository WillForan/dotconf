(use-package gptel :ensure t
  :vc ( :url "https://github.com/karthink/gptel"
        :rev :newest)
  :config
  (gptel-make-gh-copilot "Copilot")
  (setq ;; gptel-model 'claude-3.7-sonnet
      gptel-backend (gptel-make-gh-copilot "Copilot")))

(use-package gptel-agent
  :vc ( :url "https://github.com/karthink/gptel-agent"
        :rev :newest)
  :config (gptel-agent-update))
;; (use-package aider :ensure t)

;; 20260115, run copilot-install-server
(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest
            :branch "main"))
