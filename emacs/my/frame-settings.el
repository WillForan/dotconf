;; should be sourced on any new frame with 'after-make-frame-functions hook
;; see my.el:#'my/frame-settings
;; 20210331 - extracted from my/base.el (run by my/loadinit)

;; no display, toolbar already off (dne)
(when (display-graphic-p) (tool-bar-mode 0))
(menu-bar-mode 0)

;; 20210209 lucid scroll bars are ugly but very functional
;(toggle-scroll-bar 0) 
; 20210209 just disable on minibuffer
(set-window-scroll-bars (minibuffer-window) nil nil)


;; title has filename in it
(setq-default frame-title-format '("%f [emacs %m]"))
(setq-default icon-title-format frame-title-format)

;; Font
;(set-default-font "Source Code Pro 14") ;; 20191022
;; https://superuser.com/questions/721634/different-font-size-when-running-emacs-and-emacsclient
; (setq default-frame-alist '((font . "Iosevka-16"))) ; 20171229/ alist update 20181016 (for emacsclient)
(set-frame-font "DejaVu Sans Mono-14" nil t); 20180810; 20191116 fix
