;; 100MB to garbage collect less (faster startup)
;; default is             800000
(setq gc-cons-threshold 100000000)

;; custom settings saved elsewhere today
(setq custom-file "~/.emacs.d/custom.el") 

;; reading/testing files from /mnt/t11 or /mnt/storage on remote nfs host is slowww
;; remote file will be kept without testing if they still exists
;; https://stackoverflow.com/questions/2068697/emacs-is-slow-opening-recent-files
(setq recentf-keep '(file-remote-p file-readable-p))

;; tiling windows manager handles window/"frame" size
;; 20221026 from https://tony-zorman.com/posts/2022-10-22-emacs-potpourri.html
(setq frame-inhibit-implied-resize t)

;; personal functions
(load "~/.emacs.d/my/my.el")
; 20230629 - fast startup. my/loadinit manually
;(my/loadinit) ;; load most files in my/*el -- hardcoded selection


;(if (string-equal (system-name) "reese") (progn ))
(put 'erase-buffer 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)
;(put 'scroll-left 'disabled nil)

;; 20211024 never insert tabs
(setq-default indent-tabs-mode nil)

;; 20220412 handle large files
;; https://stackoverflow.com/questions/18316665/how-to-improve-emacs-performance-when-view-large-file
;; 
;; https://www.emacswiki.org/emacs/SoLong
;; (so-long-mode 1)
;; 20220618 - add modes that make long lines slow to render!
;; https://writequit.org/eos/eos-core.html#h:d610191c-44ba-40b4-9d07-9e26d1c50395
(when (require 'so-long nil :noerror)
  ;; so-long-threshold default is 250
  (add-to-list 'so-long-minor-modes 'rainbow-delimiters-mode)
  (add-to-list 'so-long-minor-modes 'paren-face-mode)
  (add-to-list 'so-long-minor-modes 'electric-indent-mode)
  (add-to-list 'so-long-minor-modes 'electric-pair-mode)
  (add-to-list 'so-long-minor-modes 'electric-layout-mode)
  (add-to-list 'so-long-minor-modes 'idle-highlight-mode)
  (add-to-list 'so-long-minor-modes 'show-paren-mode)
  (add-to-list 'so-long-minor-modes 'git-gutter-mode)
  (so-long-enable))

