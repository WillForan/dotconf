;; base emacs config. assume my.el already laoded
(setq inhibit-startup-screen t)
(tool-bar-mode 0)
(menu-bar-mode 0)
; (global-linum-mode 1)

; 20191116 - mode line at top instead of bottom
;(setq-default header-line-format mode-line-format)

;; write over highlighted selection (20171107)
(delete-selection-mode 1)

;; dont ask about symlinks in vcs
(setq vc-follow-symlinks nil)

;; title has filename in it
(setq-default frame-title-format '("%f [emacs %m]"))

;; Font
;(set-default-font "Source Code Pro 14") ;; 20191022
;; https://superuser.com/questions/721634/different-font-size-when-running-emacs-and-emacsclient
; (setq default-frame-alist '((font . "Iosevka-16"))) ; 20171229/ alist update 20181016 (for emacsclient)
(set-frame-font "DejaVu Sans Mono-14" nil t); 20180810; 20191116 fix

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

