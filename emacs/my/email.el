(use-package "mu4e"
 :load-path "/usr/share/emacs/site-lisp/mu4e"
 :config
 (setq mu4e-compose-reply-to-address "will.foran@gmail.com"
       user-mail-address "will.foran@gmail.com"
       user-full-name  "Will Foran"
       mail-user-agent 'mu4e-user-agent)

 ; https://www.djcbsoftware.nl/code/mu/mu4e/Adding-a-new-kind-of-mark.html
 (add-to-list 'mu4e-marks
  '(tag
     :char       "g"
     :prompt     "gtag"
     :ask-target (lambda () (read-string "What tag do you want to add?"))
     :action      (lambda (docid msg target)
		    (mu4e-action-retag-message msg (concat "+" target)))))
 (mu4e~headers-defun-mark-for tag)
 (define-key mu4e-headers-mode-map (kbd "G") 'mu4e-headers-mark-for-tag)
 ; g is default refresh
 ;(define-key mu4e-headers-mode-map (kbd "g") 'mu4e-view-refresh)
)
(use-package "org-mu4e"
 :load-path "/usr/share/emacs/site-lisp/mu4e"
)
(use-package "mu4e-conversation" :ensure t)
