;(use-package second-sel :ensure t)

(defun shell-command-on-secondary (&optional command)
 "run shell command on secondary input"
 (interactive)
 (let ((cmd (if (not command) (read-shell-command "cmd: ") command)))
   (apply #'shell-command-on-region (append (cdr (secondary-selection-limits)) (list cmd)))))
;; todo how to replace with output?
;; call-interactively?

(use-package wand
 :ensure t
 :config 

(my/use-url "https://www.emacswiki.org/emacs/download/second-sel.el")
(setq wand:*rules*
      (list (wand:create-rule :match "\\$ "
                              :capture :after
                              :action #'shell-command)
	    (wand:create-rule :match "\\% "
			      :capture :after         	    
			      :action #'shell-command-on-secondary)
            (wand:create-rule :match "https?://"
                              :capture :whole
                              :action #'browse-url-xdg-open)
            (wand:create-rule :match "file:"
                              :capture :after
                              :action #'find-file)
            (wand:create-rule :match "#> "
                              :capture :after
                              :action #'(lambda (string)
                                          (eval (read string)))))))

;; $ ls
;; #> (message "hi ()") 
; 1
; 2
;; % perl -pe 's/^;+//' | sort
