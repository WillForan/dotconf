;; base emacs config. assume my.el already laoded
(tool-bar-mode 0)
(menu-bar-mode 0)
(set-default-font "Source Code Pro 14")

;; shift-insert like terminal: x11 primary clipboard
(global-set-key (kbd "S-<Insert>") 'my/get-primary)

; org babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (R . t)
   (shell .t)))


