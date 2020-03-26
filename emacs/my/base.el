;; base emacs config. assume my.el already laoded
(setq inhibit-startup-screen t)
;; no display, toolbar already off (dne)
(when (display-graphic-p) (tool-bar-mode 0))
(menu-bar-mode 0)
(setq inhibit-startup-screen t)

;; shift-insert like terminal: x11 primary clipboard
(global-set-key (kbd "S-<Insert>") 'my/get-primary)
;; selection to xclipboard (20191202)
(setq x-select-enable-primary t)

;; store recent files
(recentf-mode 1)

;; Termux has hunspell
(when (equal nil (executable-find "ispell"))
  (setq ispell-program-name (executable-find "hunspell")))

;; disable message for every word. improve pefromance? 20191227 
;; https://www.emacswiki.org/emacs/FlySpell
(setq flyspell-issue-message-flag nil)
; (setq flyspell-auto-correct-binding (kbd "<S-f12>")))

; (global-linum-mode 1)

; 20191116 - mode line at top instead of bottom
;(setq-default header-line-format mode-line-format)

;; write over highlighted selection (20171107)
(delete-selection-mode 1)

;; dont ask about symlinks in vcs
(setq vc-follow-symlinks nil)

;; title has filename in it
(setq-default frame-title-format '("%f [emacs %m]"))
(setq-default icon-title-format frame-title-format)

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

;; dont do the crazy comment indent (20200224)
(electric-indent-mode 0)

;; use python3 in python-mode 20200225
(setq python-shell-interpreter "python3")

;; org babel -- see org.el (?)
;(org-babel-do-load-languages
; 'org-babel-load-languages
; '((python . t)
;   (R . t)
;   (shell .t)))
