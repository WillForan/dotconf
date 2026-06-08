(use-package gptel :ensure t
  :config
  ;; :vc (:url "https://github.com/karthink/gptel" :rev :newest)
  (gptel-make-gh-copilot "Copilot")
  (setq ;; gptel-model 'claude-3.7-sonnet
   gptel-backend (gptel-make-gh-copilot "Copilot")))


(use-package gptel-magit :ensure t :after gptel)

;; 20260605
(use-package gptel-agent
  :vc ( :url "https://github.com/karthink/gptel-agent"
        :rev :newest)
  :config (gptel-agent-update))
