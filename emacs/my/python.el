;; might want set a different path to python.
;; in .dir-locals.el
;; ((python-mode . ((python-pytest-executable . "pipenv run python -m pytest"))))
(use-package python-pytest
  :ensure t
  :bind
  ("C-c t" . python-pytest-file-dwim)
  ("C-c T" . python-pytest-dispatch))

(use-package python-black :ensure t
  :demand t
  :after python
  ;; is [tool.black] in pyproject.toml
  :hook (python-mode . python-black-on-save-mode-enable-dwim))

(use-package lsp-ui :ensure t :commands lsp-ui-mode)

;; 20220804
(setq python-shell-interpreter-args "-m asyncio")
(use-package lsp-pyright :ensure t 
  :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp) (flycheck-mode)))
  :init (when (executable-find "python3")
          (setq lsp-pyright-python-executable-cmd "python3")))


;; 20220805 - no longer in MELPA? latest release was 2019
;; (use-package company-lsp :ensure t :config (push 'company-lsp company-backends))

;; 20220804
;; no ipython. pyright instead of lsp-mode directly
;; NB. elpy is still maintained (as of 20220805 last updated a month ago late jun)
;;     BUT looking for a new maintainer
(defun my/pysetup ()
  "Flycheck setup w/keybindings."
  (interactive)
  (progn
    (flycheck-mode)
    (define-key python-mode-map "\M-n" 'flycheck-next-error)
    (define-key python-mode-map "\M-p" 'flycheck-previous-error)))

;; prefer flycheck over older flymake
;; flycheck does useful things with py out of the box
;; (add-hook 'python-mode-hook #'my/pysetup)
>>>>>>> 3e744efe3e745a5ba7595e6ac1ebf69242522db1

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
