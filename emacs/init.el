;; custom settings saved elsewhere today
(setq custom-file "~/.emacs.d/custom.el") 
;; personal functions
(load "~/.emacs.d/my/my.el")
(my/loadinit) ;; load most files in my/*el -- hardcoded selection
(add-hook 'after-make-frame-functions #'my/frame-settings)

;(if (string-equal (system-name) "reese") (progn ))
(put 'erase-buffer 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)
