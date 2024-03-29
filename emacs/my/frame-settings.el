;;; frame-settings --- Title and font
;;; Commentary:
;; should be sourced on any new frame with 'after-make-frame-functions hook
;; see my.el:#'my/frame-settings
;; 20210331 - extracted from my/base.el (run by my/loadinit)
;;; Code:


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
;; (set-frame-font "IBM Plex Mono-12")  ; like JetBrains but with more serif
;; (set-frame-font "Berkeley Mono Variable-12") ; Not free. missing 7S. like JetBrains. shorter lines
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
;; (set-frame-font "SF Mono-12")           ; stiffer than berkeley, same shape; 'i nerd-fonts-sf-mono'
;; (set-frame-font "Spleen")               ; dense, pixely
;; (set-frame-font "IntelOne Mono-12")     ; 20230513 hackernews. angry {}. tall lines


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
   "SF Mono-12" "Berkeley Mono Variable-12" "Spleen") ; "IBM Plex Mono-12"
  "List of possible font faces.")

(defun my/font-random ()
  "Pick a random font."
  (interactive)
       (let ((rand-font (seq-random-elt my/font-face-list)))
         (message (concat "random font:" rand-font))
         (set-frame-font rand-font)))

(defun my/set-font-from-list ()
  "Set font from restricted list.  Also see `helm-select-xfont'."
  (interactive)
       (set-frame-font (completing-read "font" my/font-face-list)))

;; 20230211 -- random font changes crashing emacs? maybe a font doesn't exist?
;; (my/font-random)


(defun my/frame-settings ()
  "Disable toolbar, put buffer and directory in title, set font." 
  ;; No display, toolbar already off (dne). no need for fonts
  (when (display-graphic-p)
    (tool-bar-mode 0)
    ;; font
    (set-face-attribute 'default nil :font "M+ 1M-12")
    (set-frame-font "M+ 1M-12"))
  (menu-bar-mode 0)

  ;; 20210209 lucid scroll bars are ugly but very functional
                                        ;(toggle-scroll-bar 0)
                                        ; 20210209 just disable on minibuffer
  (set-window-scroll-bars (minibuffer-window) nil nil)


  ;; title has filename in it
  ;; and if mode-name/no file name,
  ;; show the buffer name instade with current directory
  (setq-default frame-title-format
                '("%f"
                  (:eval (when (not buffer-file-name) (concat "%b " default-directory)))
                  " [emacs]"))
  (setq-default icon-title-format frame-title-format))

;; run when sourced
(defun my/frame-settings-tohook (f) (my/frame-settings) )
(add-hook 'after-make-frame-functions #'my/frame-settings-tohook)
(my/frame-settings)

(provide 'frame-settings)
;;; frame-settings.el ends here
