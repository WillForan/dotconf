;; modal editor
(use-package evil :ensure t
  :init
  :config
    (evil-mode 1)
    ;; evil addons
    (use-package evil-escape :ensure t
      :config
	(setq-default evil-escape-key-sequence "jj")
	;; jj kills visual mode :( maybe switch to jk
	(setq-default evil-escape-delay 0.2)
	(evil-escape-mode 1))
    (use-package evil-leader :ensure t
      :config
       (global-evil-leader-mode)
       (evil-leader/set-leader "<SPC>")))
