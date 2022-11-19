;; 20210328 - split args.
;; NB. original fuzzy args uses perl to keep shell quoted words
;; this one just removes (),| and splits on spaces
(defun my/comint-list-all-args ()
  "dumb word split on history. all arguments, each as an element in a list"
  (mapcan #'(lambda (s)
	      (cdr (split-string (replace-regexp-in-string
				  "[)(|,]" " "
				  (substring-no-properties s)))))
	  (ring-elements comint-input-ring)))

(defun my/comint-args ()
  "insert from list of previous arguments in comint-input-ring"
  (interactive)
  (helm :sources (helm-build-sync-source "comint args"
                   :candidates (my/comint-list-all-args)
                   :fuzzy-match t
		 :action #'insert)
      :buffer "*helm comint args*"))

;; Key bindings
; also see helm.el for C-l history and prompt jump
; replaces binding for backward-sentence, see helm.el for other comint settings
(define-key comint-mode-map (kbd "C-c M-a") 'my/comint-args)
; ^find^replace[space] replaces -- tab does this already?
; (define-key shell-mode-map (kbd "SPC") 'comint-magic-space)

;; colorize- 20210331 - was working! not sure how/why
;   maybe part of native gtk port or emacs 28?
;   TERM=xterm ls # shows colors ... sometimes??
; later attempts to get back the color:
; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
; (add-to-list 'comint-output-filter-functions 'ansi-color-process-output)
; (set-face-attribute 'comint-highlight-prompt nil :inherit nil)
; (use-package ansi-color   :config  (ansi-color-for-comint-mode-on))
; 20210401 - reboot and works with color?! using doom-solarazied-dark theme
; this file wasn't sourced before hand.
; still need export TERM=eterm-color for ls colors

; get tab complete on some functions. TODO: add fish
(use-package bash-completion :ensure t
  :config
  (bash-completion-setup))

(use-package shx :ensure t
  :init
  (setq
   ;; resync the shell's default-directory with Emacs on "z" commands:
   shx-directory-tracker-regexp "^z "
   ;; vastly improve display performance by breaking up long output lines
   shx-max-output 1024
   ;; prevent input longer than macOS's typeahead buffer from going through
   shx-max-input 1024
   ;; prefer inlined images and plots to have a height of 250 pixels
   shx-img-height 250
   ;; don't show any incidental hint messages about how to use shx
   ;; shx-show-hints nil
   ;; flash previous comint prompt when using C-c C-p
   shx-flash-prompt-time .5
   ;; use `#' to prefix shx commands instead of the default `:'
   shx-leader "#")
  :config
(shx-global-mode 1))


;; sly custom prompt
;; https://github.com/joaotavora/sly/issues/360
; (cl-defun ambrevar/sly-new-prompt (_package
;                                 package-nickname
;                                 error-level
;                                 entry-idx
;                                 _condition)
;   (concat
;    "("
;    (propertize (abbreviate-file-name default-directory) 'font-lock-face 'diff-added)
;    ")\n"
;    (propertize "<" 'font-lock-face 'sly-mrepl-prompt-face)
;    (propertize (number-to-string entry-idx) 'font-lock-face 'sly-mode-line)
;    (propertize ":" 'font-lock-face 'sly-mrepl-prompt-face)
;    (propertize package-nickname 'font-lock-face 'sly-mode-line)
;    (when (cl-plusp error-level)
;      (concat (sly-make-action-button
;               (format "[%d]" error-level)
;               #'sly-db-pop-to-debugger-maybe)
;              " "))
;    (propertize "> " 'font-lock-face 'sly-mrepl-prompt-face)))
