;; custom settings saved elsewhere today
(setq custom-file "~/.emacs.d/custom.el") 
;; personal functions
(load "~/.emacs.d/my/my.el")
;; use-package defintions for packages (a la spacemace layers?)
(mapcar #'my/use
   '(base backup
     package quelpa
     evil theme 
     xterm-color
     git
     org tramp
     ace switch-window
     yas company helm
     zim-wiki-mode screensend))

;(if (string-equal (system-name) "reese") (progn ))
