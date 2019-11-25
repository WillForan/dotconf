;; base emacs config. assume my.el already laoded
(setq inhibit-startup-screen t)
(tool-bar-mode 0)
(menu-bar-mode 0)
; (global-linum-mode 1)


;; shift-insert like terminal: x11 primary clipboard
(global-set-key (kbd "S-<Insert>") 'my/get-primary)
(delete-selection-mode 1) ;; write over highlighted selection (20171107)

;; dont ask about symlinks in vcs
(setq vc-follow-symlinks nil)

;; title has filename in it
(setq-default frame-title-format '("%f [emacs %m]"))

;; Font
;(set-default-font "Source Code Pro 14") ;; 20191022
;; https://superuser.com/questions/721634/different-font-size-when-running-emacs-and-emacsclient
; (setq default-frame-alist '((font . "Iosevka-16"))) ; 20171229/ alist update 20181016 (for emacsclient)
(set-default-font "DejaVu Sans Mono-16"); 20180810 20191027 incl to 16

;; persistant history (20171107)
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

;; --- undo/redo window configurations ---
;; C-c {left,right}: undo redo
(winner-mode 1)
;; 20180625 -- S- arrow to move around
(windmove-default-keybindings)

;; org babel -- see org.el (?)
;(org-babel-do-load-languages
; 'org-babel-load-languages
; '((python . t)
;   (R . t)
;   (shell .t)))

