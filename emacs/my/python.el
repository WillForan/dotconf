(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")

(defun my/pysetup ()
  "Flycheck setup w/keybindings."
  (interactive)
  (progn
    (flycheck-mode)
    (define-key python-mode-map "\M-n" 'flycheck-next-error)
    (define-key python-mode-map "\M-p" 'flycheck-previous-error)))

;; prefer flycheck over older flymake
;; flycheck does useful things with py out of the box
(add-hook 'python-mode-hook #'my/pysetup)

;; might want set a different path to python.
;; in .dir-locals.el
;; ((python-mode . ((python-pytest-executable . "pipenv run python -m pytest"))))
(use-package python-pytest
  :ensure t
  :bind
  ("C-c t" . python-pytest-file-dwim)
  ("C-c T" . python-pytest-dispatch))

;; end
