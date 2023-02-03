;;; frame-settings --- Title and font
;;; Commentary:
;; should be sourced on any new frame with 'after-make-frame-functions hook
;; see my.el:#'my/frame-settings
;; 20210331 - extracted from my/base.el (run by my/loadinit)
;;; Code:

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
;; (set-frame-font "DejaVu Sans Mono-14" nil t)
                                        ; 20180810; 20191116 fix
;; 20220911:  Roboto Mono won in https://www.codingfont.com/; also Azeret, B612, Cousine
;;            notably not Fira Code, Hack, Source Code Pro, or Iosevka
;;            also look at Input (yuk), Sudo, ttf-monoid
;; (set-frame-font "JetBrains Mono-12") ; taller lines,shorter chars than Fantasque/Berkeley
;; (set-frame-font "Berkeley Mono Trial-12") ; Not free. missing 7S. like JetBrains. shorter lines
;; (set-frame-font "Fantasque Sans Mono-14") ; narrow and short; like Berkeley but heavier; compact lines
;; (set-frame-font "Code New Roman-14") ; a little more blocky than fantasque but similiar
;; (set-frame-font "M+ 1M-14") ; taller heavier but same width as fantasque
;; (set-frame-font "Iosevka-14")           ; longer
;; (set-frame-font "Consolas Ligaturized-14")  ; sarif font. meh
;; (set-frame-font "Source Code Pro-14")   ; wider than iosevka
;; (set-frame-font "Hack-14")              ; wider, heavier. slightly lighter than dejavu
;; (set-frame-font "DejaVu Sans Mono-14")  ; heavier
;; (set-frame-font "Fantasque Sans Mono-14")  ; 
;; (set-frame-font "Roboto Mono-14")       ; longer than dejavu
;; (set-frame-font "Cousine-14")           ; shorter but like DejaVu, closest to monoid
;; (set-frame-font "Flexi IBM VGA False-12") ; shorter stretched
;; (set-frame-font "Monoid-12")            ; lightest - similiar to cousine
;; (set-frame-font "Sudo-17")              ; like iosevka but shorter; small -- need highr pt
;; (set-frame-font "Input Mono-12")        ; large and blocky (most different) good at lower pt
;; (set-frame-font "Liberation Mono-12")   ; shorter than Input Mono, narrower
;; (set-frame-font "Fira Code-12")         ; like input. less blocky/heavy than input, otherwise same
;; (set-frame-font "Azeret Mono-12")       ; shorter than Input, less blocky. Too thin on low contract (comments)
;; (set-frame-font "B612 Mono-12")         ; blocky. hard to see () []; {} are distinct though
;; (set-frame-font "Verily Serif Mono-14") ; sarif font. meh
;; (set-frame-font "SF Mono-12")           ; stiffer than berkeley, same shape
;; (set-frame-font "Spleen")               ; dense, pixely


;; 20230130: appreachating Input, Flexi (IBM VGA), and Libreation Mono 
;; 20230130: set random font. see describe-char (C-u C-x =)
;; also see 'helm-select-xfont' on C-x c F
(defvar my/font-face-list 
  (list
   "JetBrains Mono-12" "Fantasque Sans Mono-14" "Code New Roman-14" "M+ 1M-14"
   "Iosevka-14" "Consolas Ligaturized-14" "Source Code Pro-14" "Hack-14" "DejaVu Sans Mono-14"
   "Fantasque Sans Mono-14" "Roboto Mono-14" "Cousine-14" "Flexi IBM VGA False-12"
   "Monoid-12" "Sudo-17" "Input Mono-12" "Liberation Mono-12" "Fira Code-12" "Azeret Mono-12"
   "B612 Mono-12" "Verily Serif Mono-14" "DejaVu Sans Mono-14"
   "SF Mono-12" "Berkeley Mono Variable-12" "Spleen")
  "List of possible font faces.")
(defun my/font-random () (interactive)
       (let ((rand-font (seq-random-elt my/font-face-list)))
         (message (concat "random font:" rand-font))
         (set-frame-font rand-font)))

(my/font-random)
