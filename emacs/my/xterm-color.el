; 20180808 -- full color support 
; https://github.com/atomontage/xterm-color
(use-package xterm-color
  :config
   ;(setenv "TERM" "xterm-256color")
   (setq comint-output-filter-functions
      (remove 'ansi-color-process-output comint-output-filter-functions))
   (add-hook 'shell-mode-hook
          (lambda () (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))
)
