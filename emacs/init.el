;; custom settings saved elsewhere today
(setq custom-file "~/.emacs.d/custom.el") 
;; personal functions
(load "~/.emacs.d/my/my.el")
(my/loadinit) ;; load most files in my/*el -- hardcoded selection

;(if (string-equal (system-name) "reese") (progn ))
