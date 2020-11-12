(use-package navi-mode :ensure t :defer t)
;; also uses outorg (?)
(use-package outshine :ensure t  :defer t
  :init
   (setq  outline-minor-mode-prefix "\M-#")
   (setq outshine-use-speed-commands t)
  :config
   (use-package outorg :ensure t))


;; * Usage
;; ** outshine
;; *** speedbar
;;  See: https://orgmode.org/manual/Speed-Keys.html and outshine-speed-command-help
;;
;;  - must be at 0 line position
;;  - move cursor to headings: n/p, f/u, u/b
;; ** outorg
;;    - must have ~outshine~
;;    - with ~outline-minor-mode~, use ~outorg-edit-as-org~

;; https://github.com/alphapapa/outorg
;; > Outorg’s main command is outorg-edit-as-org (by default, bound to M-# #), to be used in source-code buffers where outline-minor-mode is activated with outshine extensions. The Org-mode edit-buffer popped up by this command is called outorg-edit-buffer and has outorg-edit-minor-mode activated, a minor-mode with only 2 commands:
;; > 
;; >     outorg-copy-edits-and-exit (M-#)
;; >     outorg-save-edits-to-tmp-file (C-x C-s)
;; > 
;; > If you want to insert Org-mode source-code or example blocks in comment-sections, i.e. you don’t want outorg to remove the enclosing blocks, simply outcomment them in the outorg-edit buffer before calling outorg-copy-edits-and-exit.
