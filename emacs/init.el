;; 100MB to garbage collect less (faster startup)
;; default is             800000
(setq gc-cons-threshold 100000000)

;; custom settings saved elsewhere today
(setq custom-file "~/.emacs.d/custom.el") 

;; reading/testing files from /mnt/t11 or /mnt/storage on remote nfs host is slowww
;; remote file will be kept without testing if they still exists
;; https://stackoverflow.com/questions/2068697/emacs-is-slow-opening-recent-files
(setq recentf-keep '(file-remote-p file-readable-p))


;; personal functions
(load "~/.emacs.d/my/my.el")
(add-hook 'after-make-frame-functions #'my/frame-settings)
(my/loadinit) ;; load most files in my/*el -- hardcoded selection


;(if (string-equal (system-name) "reese") (progn ))
(put 'erase-buffer 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)
;(put 'scroll-left 'disabled nil)

;; 20211024 never insert tabs
(setq-default indent-tabs-mode nil)
