
;(use-package smartparens :ensure t
;  :config
;  (require 'smartparens-config)
;  (add-hook 'lisp-mode-hook #'smartparens-mode))

(use-package lispy :ensure t
  :hook
   (emacs-lisp-mode . lispy-mode)
   (lisp-mode . lispy-mode)
  :config
  ;; 20210503 - from lispy github for minibuffer on eval-expression
  (defun conditionally-enable-lispy ()
    (when (eq this-command 'eval-expression)
	(lispy-mode 1)))
  (add-hook 'minibuffer-setup-hook 'conditionally-enable-lispy)
  :custom
  (lispy-no-space t) ; ':' -> ' :' is disruptive!
  :bind
  ;; ctrl bound to capslock this is both pinkys at the same time
  ("C-'" . lispy-parens))

;; 20210502
;; https://wikemacs.org/wiki/Lisp_editing
(use-package evil-cleverparens :ensure t
 :config
 (add-hook 'lisp-mode-hook #'evil-cleverparens-mode)
 (add-hook 'clojure-mode-hook #'evil-cleverparens-mode)
 (add-hook 'elisp-mode-hook #'evil-cleverparens-mode))

;;; 20210502 - a bit broken? need rust backend?
;; (use-package parinfer-rust-mode
;;     :hook emacs-lisp-mode
;;     :init
;;     (setq parinfer-rust-auto-download t))

; 20210504 https://emacsredux.com/blog/2014/08/25/a-peek-at-emacs-24-dot-4-prettify-symbols-mode/
; see base.el where prettify symbols is activates
(defconst lisp--prettify-symbols-alist
  '(("lambda"  . ?λ)))

;; sly addons
(use-package sly-quicklisp :ensure t :after sly)
(use-package sly-asdf :ensure t :after sly)
(use-package sly-macrostep :ensure t :after sly)
(use-package sly :ensure t
  :config
  (rainbow-delimiters-mode 1)
  (setq inferior-lisp-program "/usr/bin/sbcl")
  ;; org mode defaults to slime, change that
  ;; TODO: does that work if org isn't already sorced?
  (setq org-babel-lisp-eval-fn #'sly-eval)
  (setq sly-enable-evaluate-in-emacs t)
  ;; handled by lispy
  ;;(define-key sly-mrepl-mode-map (kbd "C-'") #'lispy-parens)
  :custom
  (lispy-use-sly t)
  (lisp-mode-hook '(sly-editing-mode ) "REPL instead of slime"))

;; hydra cheatsheet
;; https://sachachua.com/blog/2021/04/emacs-making-a-hydra-cheatsheet-for-lispy/
(setq my/lispy-bindings-table
      '(("<" "lispy-barf" #1="")
	("A" "lispy-beginning-of-defun" #1#)
	("j" "lispy-down" #1#)
	("Z" "lispy-edebug-stop" #1#)
	("B" "lispy-ediff-regions" #1#)
	("G" "lispy-goto-local" #1#)
	("h" "lispy-left" #1#)
	("N" "lispy-narrow" #1#)
	("y" "lispy-occur" #1#)
	("o" "lispy-other-mode" #1#)
	("J" "lispy-outline-next" #1#)
	("K" "lispy-outline-prev" #1#)
	("P" "lispy-paste" #1#)
	("l" "lispy-right" #1#)
	("I" "lispy-shifttab" #1#)
	(">" "lispy-slurp" #1#)
	("SPC" "lispy-space" #1#)
	("xB" "lispy-store-region-and-buffer" #1#)
	("u" "lispy-undo" #1#)
	("k" "lispy-up" #1#)
	("v" "lispy-view" #1#)
	("V" "lispy-visit" #1#)
	("W" "lispy-widen" #1#)
	("D" "pop-tag-mark" #1#)
	("x" "see" #1#)
	("L" "unbound" #1#)
	("U" "unbound" #1#)
	("X" "unbound" #1#)
	("Y" "unbound" #1#)
	("H" "lispy-ace-symbol-replace" "Edit")
	("c" "lispy-clone" "Edit")
	("C" "lispy-convolute" "Edit")
	("n" "lispy-new-copy" "Edit")
	("O" "lispy-oneline" "Edit")
	("r" "lispy-raise" "Edit")
	("R" "lispy-raise-some" "Edit")
	("\\" "lispy-splice" "Edit")
	("S" "lispy-stringify" "Edit")
	("i" "lispy-tab" "Edit")
	("xj" "lispy-debug-step-in" "Eval")
	("xe" "lispy-edebug" "Eval")
	("xT" "lispy-ert" "Eval")
	("e" "lispy-eval" "Eval")
	("E" "lispy-eval-and-insert" "Eval")
	("xr" "lispy-eval-and-replace" "Eval")
	("p" "lispy-eval-other-window" "Eval")
	("q" "lispy-ace-paren" "Move")
	("z" "lispy-knight" "Move")
	("s" "lispy-move-down" "Move")
	("w" "lispy-move-up" "Move")
	("t" "lispy-teleport" "Move")
	("Q" "lispy-ace-char" "Nav")
	("-" "lispy-ace-subword" "Nav")
	("a" "lispy-ace-symbol" "Nav")
	("b" "lispy-back" "Nav")
	("d" "lispy-different" "Nav")
	("f" "lispy-flow" "Nav")
	("F" "lispy-follow" "Nav")
	("g" "lispy-goto" "Nav")
	("xb" "lispy-bind-variable" "Refactor")
	("xf" "lispy-flatten" "Refactor")
	("xc" "lispy-to-cond" "Refactor")
	("xd" "lispy-to-defun" "Refactor")
	("xi" "lispy-to-ifs" "Refactor")
	("xl" "lispy-to-lambda" "Refactor")
	("xu" "lispy-unbind-variable" "Refactor")
	("M" "lispy-multiline" "Other")
	("xh" "lispy-describe" "Other")
	("m" "lispy-mark-list" "Other")))
 (eval
     (append
      '(defhydra my/lispy-cheat-sheet (:hint nil :foreign-keys run)
	 ("C-c L" nil :exit t))
      (cl-loop for x in my/lispy-bindings-table
	       unless (string= "" (elt x 2))
	       collect
	       (list (car x)
		     (intern (elt x 1))
		     (when (string-match "lispy-\\(?:eval-\\)?\\(.+\\)"
					 (elt x 1))
		       (match-string 1 (elt x 1)))
		     :column
		     (elt x 2)))))
  (with-eval-after-load "lispy"
    (define-key lispy-mode-map (kbd "C-c l") 'my/lispy-cheat-sheet/body))



