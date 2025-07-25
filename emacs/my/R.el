(use-package ess :defer t :ensure t
  :config
  ;; dont block when running R
  (setq ess-eval-visibly 'nowait)
  ;; show function name in mode line
  ;; (which-function-mode 1) ;; 20230130 - this is slow!

  ;; prefomrance issues issues
  ;; https://emacs.stackexchange.com/questions/9621/how-to-find-what-causes-ess-to-run-very-slow
  (setq ess-r--no-company-meta t) ; disalble contextual help in minibuffer during autocomplete

  (setq scroll-down-aggressively 1)     ; jump to results instead of hanging out at the prompt like plan9
  (setq comint-scroll-to-bottom-on-input t)
  (setq comint-move-point-for-output 'others)

  ;; with apl mode: setxkbmap -layout us,apl -variant ,dyalog -option grp:switch
  ;; right alt+x is ⊃  ;  r alt + ] is →
  (define-key ess-mode-map (kbd "→") " -> ")
  (define-key ess-mode-map (kbd "⊃") " %>% ")
  (define-key inferior-ess-mode-map (kbd "⊃") "%>%")

  ;; 20250225 - tidyverse colors into comint buffer
  ;; 20250413 - revisited with fboundp guard
  ;; alt, disable in R: options(crayon.enabled = FALSE)
  (when (fboundp 'ansi-color-process-output)
    (add-to-list 'comint-output-filter-functions #'ansi-color-process-output))

  ;; this messes up emacs in temrinal
  ;; and make it look like what we pushed for maximum confusion
  ;; (add-hook 'ess-mode-hook
  ;;           (lambda ()
  ;;             (setf prettify-symbols-alist
  ;;                   (cl-list*
  ;;                    '("%>%" . ?⊃)
  ;;                    ;; '("->"  . ?→) ; already set
  ;;                    ;; '("<-"  . ?←)
  ;;                    prettify-symbols-alist))))
  )

;; 20240105 - M-x styler-buffer
(use-package reformatter
  :config
  (defconst Rscript-command "Rscript")
  (reformatter-define styler
    :program Rscript-command
    :args (list "--vanilla" "-e" "con <- file(\"stdin\")
out <- styler::style_text(readLines(con))
close(con)
out")
    :lighter " styler"))
