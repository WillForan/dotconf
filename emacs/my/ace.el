; ----- ace-jump-mode (201721229) -----
; use C-c SPC, or just space in evil mode
(use-package ace-jump-mode :ensure t
 :config
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
  ; defined in evil-mode setup to SPC a; 20191124
)
