;; modal editor
(use-package evil :ensure t
  :init
  :config
    (evil-mode 1)
    ;; _ is part of a word
    ;; https://emacs.stackexchange.com/questions/9583/how-to-treat-underscore-as-part-of-the-word
    (setq-default evil-symbol-word-search t) 

    ;; default to emacs for these
    (dolist (mode (list
		  'help-mode 'elfeed-search-mode 'elfeed-show-mode
		  'Magit-mode
		  'notmuch-hello-mode 'notmuch-tree-mode))
       (evil-set-initial-state mode 'emacs))
    ;; evil addons
    (use-package evil-escape :ensure t
      :config
	(setq-default evil-escape-key-sequence "kj")
	;; kj kills visual mode :( maybe switch to jk
	(setq-default evil-escape-delay 0.2)
	(evil-escape-mode 1))
    ;; surround word commands- 20180629 - ysiw' -> surround word with quotes
    ;; use S in visual mode
    (use-package evil-surround :ensure t
      :config
      (global-evil-surround-mode 1))
    ;; load evil leader
    (use-package evil-leader :ensure t
      :config
       (global-evil-leader-mode)
       (evil-leader/set-leader "<SPC>"))

    ;; leader keybindings -- consider hydra instead?
    (evil-leader/set-key "a" 'ace-jump-char-mode)
    (evil-leader/set-key "s" 'projectile-ag)
    (evil-leader/set-key "p" 'helm-projectile)
    ; f defined in folding.el

    (evil-leader/set-key "i" 'imenu)
    (evil-leader/set-key "g" 'magit-status)
    (evil-leader/set-key "w" 'save-buffer)
    (evil-leader/set-key "x" 'helm-M-x)
    (evil-leader/set-key "0" 'switch-window-then-delete)

    (evil-leader/set-key "h" 'backward-sexp)
    (evil-leader/set-key "j" 'down-list)
    (evil-leader/set-key "k" 'up-list)
    (evil-leader/set-key "l" 'forward-sexp)
    (evil-leader/set-key ";" 'eval-region))
