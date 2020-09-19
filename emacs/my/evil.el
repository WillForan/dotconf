;; modal editor
(defun my/eval-region-and-kbquit ()
  "eval selection and clear selection"
  (interactive)
  (if (region-active-p)
      (eval-region (region-beginning) (region-end))
      ;; this doesn't work ... yet
      (progn (evil-visual-line) (my/eval-region-and-kbquit)))
  (keyboard-quit))

(use-package evil :ensure t
  :init
  :config
    (evil-mode 1)
    ;; _ is part of a word
    ;; https://emacs.stackexchange.com/questions/9583/how-to-treat-underscore-as-part-of-the-word
    (setq-default evil-symbol-word-search t) 
    ;; search history (up/down) -- 20200404
    (evil-select-search-module 'evil-search-module 'evil-search)

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
    (evil-leader/set-key "a" #'avy-goto-char-in-line)
    (evil-leader/set-key "l" #'avy-goto-line)
    (evil-leader/set-key "s" #'projectile-ag)
    (evil-leader/set-key "p" #'helm-projectile)
    (evil-leader/set-key "G" #'helm-projectile-find-file-in-known-projects)
    (evil-leader/set-key "n" #'neotree-find)

    ;; f defined in folding.el
    ;; z for zim set in zim-wiki.el
    ;;  (evil-leader/set-key-for-mode 'zim-wiki-mode "z" 'zim-wiki-hydra/body)

    (evil-leader/set-key "g" #'magit-status)
    (evil-leader/set-key "w" #'save-buffer)
    (evil-leader/set-key "0" #'switch-window-then-delete)
    (evil-leader/set-key "1" #'switch-window-then-maximize)

    (evil-leader/set-key "<SPC>" #'helm-M-x)

    ;; what lines have we visited
    (evil-leader/set-key "m" #'helm-mark-ring)

    (evil-leader/set-key ";" #'my/eval-region-and-kbquit)
    (evil-leader/set-key "o" #'org-open-at-point)
    (evil-leader/set-key "f" #'company-files)

    ;; testing -- not sure about these (sexp movements)
    (evil-leader/set-key "b" #'switch-to-buffer)
    (evil-leader/set-key "i" #'imenu)
    (evil-leader/set-key "h" #'backward-sexp)
    (evil-leader/set-key "j" #'down-list)
    (evil-leader/set-key "k" #'up-list)
    (evil-leader/set-key "l" #'forward-sexp))

;; 20200607 - add jj for evil escape
(use-package key-chord :ensure t
  :after evil
  :config
  (key-chord-mode 1)
  (key-chord-define evil-insert-state-map  "jj" 'evil-normal-state)
  (key-chord-define evil-insert-state-map  "zz" 'zim-wiki-hydra/body))
