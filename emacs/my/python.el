(use-package python-black :ensure t
  :demand t
  :after python
  ;; is [tool.black] in pyproject.toml
  :hook (python-mode . python-black-on-save-mode-enable-dwim))

(use-package lsp-ui :ensure t :commands lsp-ui-mode)

;; 20220804
(setq python-shell-interpreter-args "-m asyncio")
(use-package company-lsp :ensure t)
(use-package lsp-pyright :ensure t 
  :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp) (flycheck-mode)))
  :init (when (executable-find "python3")
          (setq lsp-pyright-python-executable-cmd "python3")))


;; 20220804
;; no ipython. pyright instead of lsp-mode directly
;; NB. elpy is no longer maintained 

;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "--simple-prompt -i")
;; (use-package lsp-mode :ensure t
;;   :config
;;     (lsp-register-custom-settings
;;    '(("pyls.plugins.pyls_mypy.enabled" t t)
;;      ("pyls.plugins.pyls_mypy.live_mode" nil t)
;;      ("pyls.plugins.pyls_black.enabled" t t)
;;      ("pyls.plugins.pyls_isort.enabled" t t)
;;      ("pyls.plugins.flake8.enabled" t t)))
;;   :hook
;;   ((python-mode . lsp)
;;    (lsp-mode . lsp-enable-which-key-integration)))
