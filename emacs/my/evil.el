;; 20201120 update requires explicit undo model
;; 20211003 get w/use-package
;; 20211024 move to out side of evil use-package
(use-package undo-tree :ensure t
  :config (global-undo-tree-mode 1))

;; modal editor
(defun my/eval-region-and-kbquit ()
  "eval selection and clear selection"
  (interactive)
  (if (region-active-p)
      (eval-region (region-beginning) (region-end))
      ;; this doesn't work ... yet
      (progn (evil-visual-line) (my/eval-region-and-kbquit)))
  (keyboard-quit))

(defun my/evil-exclude-state ()
 "get major mode of current buffer, add to kill ring, jump to this file
  this would be better as a configure variable that can be edited and saved?"
 (interactive)
 (progn
   (kill-new (concat "'" (symbol-name major-mode)))
   (find-file-at-point "~/.emacs.d/my/evil.el") 
   (re-search-forward ";; default to emacs for these\$")))

;; 20201120 update requires explicit undo model
;; 20211003 get w/use-package
;; 20211024 move to out side of evil use-package
(use-package undo-tree :ensure t
  :config (global-undo-tree-mode 1))

(use-package evil :ensure t :after undo-tree
  :init
  :config
    (evil-mode 1)
    ;; _ is part of a word
    ;; https://emacs.stackexchange.com/questions/9583/how-to-treat-underscore-as-part-of-the-word
    (setq-default evil-symbol-word-search t) 
    
    (evil-set-undo-system 'undo-tree)

    ;; 20200404 search history (up/down)
    (evil-select-search-module 'evil-search-module 'evil-search)

    ;; default to emacs for these
    (dolist (mode (list
		  'synosaurus-list-mode 'wordnut-mode
		  'haskell-error-mode
		  'special-mode
		  'spray 'help-mode 'elfeed-search-mode 'elfeed-show-mode
		  'Magit-mode 'magit-mode 
		  'notmuch-hello-mode 'notmuch-tree-mode
		  'sly-popup-buffer-mode 'sly-db-mode 'sly-inspector-mode
                  'deft-mode 'special 'dired-mode))
       (evil-set-initial-state mode 'emacs))
    
    
    ;; does the opposite of J -- merge line up instead of down
    ;; use after e.g. r!xclip -o
    (define-key evil-normal-state-map (kbd "M-j") #'join-line))

;; evil addons
(use-package evil-escape :ensure t
  :config
  (setq-default evil-escape-key-sequence "kj")
  ;; kj kills visual mode :( maybe switch to jk
  (setq-default evil-escape-delay 0.2)
  (evil-escape-mode 1))
;; surround word commands- 20180629 - ysiw' -> surround word with quotes
;; use S in visual mode
(use-package evil-surround :ensure t :after evil
  :config
  (global-evil-surround-mode 1))

;; load evil leader
(use-package evil-leader :ensure t :after evil
  :config
    (evil-leader/set-leader "<SPC>")
    (global-evil-leader-mode)
    ;; leader keybindings -- consider hydra instead?
    (evil-leader/set-key "a" #'avy-goto-char-in-line)
    (evil-leader/set-key "l" #'avy-goto-line)
    (evil-leader/set-key "s" #'projectile-ag)
    (evil-leader/set-key "S" #'w3m-search)
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
    (evil-leader/set-key "q" #'my/other-window-kill)

    (evil-leader/set-key "<SPC>" #'helm-M-x)

    ;; 20200508 - language server. also my/use: lsp
    (evil-leader/set-key "/" #'lsp-command-map)

    ;; what lines have we visited
    (evil-leader/set-key "m" #'helm-mark-ring)

    (evil-leader/set-key ";" #'my/eval-region-and-kbquit)
    (evil-leader/set-key "o" #'org-open-at-point)
    (evil-leader/set-key "f" #'helm-find-files)

    ;; testing -- not sure about these (sexp movements)
    (evil-leader/set-key "b" #'switch-to-buffer)
    (evil-leader/set-key "i" #'imenu)
    (evil-leader/set-key "h" #'backward-sexp)
    (evil-leader/set-key "j" #'down-list)
    (evil-leader/set-key "k" #'up-list)
    (evil-leader/set-key "l" #'forward-sexp)

  )

;; 20200607 - add jj for evil escape
(use-package key-chord :ensure t
  :after evil
  :config
  (key-chord-mode 1)
  (key-chord-define evil-insert-state-map  "jj" 'evil-normal-state)
  ;(key-chord-define evil-insert-state-map  "zz" 'zim-wiki-hydra/body) ;rm 20210328
  )

;; 20201121 
;; crib from http://blog.binchen.org/posts/how-to-use-expand-region-efficiently.html
;; cite:binHowUseExpandregion2013
(use-package expand-region :ensure t :after evil
 :config
  (setq expand-region-contract-fast-key "z")
  (evil-leader/set-key "xx" 'er/expand-region)

  ;; 20210502
  ;; https://wikemacs.org/wiki/Lisp_editing
  ;; https://emacs.stackexchange.com/questions/16614/make-evil-mode-more-lisp-friendly
  (defun evil-visual-char-or-expand-region ()
    (interactive)
    (if (region-active-p)
          (call-interactively 'er/expand-region)
      (evil-visual-char)))
  
  (define-key evil-normal-state-map "v" 'evil-visual-char-or-expand-region)
  (define-key evil-visual-state-map "v" 'evil-visual-char-or-expand-region)
  (define-key evil-visual-state-map [escape] 'evil-visual-char))
