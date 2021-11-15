;; 20211110 - prefer email.el
;; using aspiring to notmuch-remote for work and mu for personal 

;; ;; gnus gmail settings in ~/.gnus see passwd/mail/
;; (use-package bbdb :ensure t
;; ;;   :config
;; ;;     ;; https://emacs.stackexchange.com/questions/164/automatically-add-recipients-mail-address-to-the-bbdb-database
;; ;;     (bbdb-initialize 'gnus 'message)
;; ;;     (bbdb-mua-auto-update-init 'message) ;; use 'gnus for incoming messages too
;; ;;     (setq bbdb-mua-auto-update-p 'query)
;; ;;     (use-package helm-bbdb :ensure t)
;; ;; )
;; 
;; ;; defualt ‘%U%R%z%I%(%[%4L: %-23,23f%]%) %s\n’.  
;; (setq gnus-summary-line-format "%o%I%R%z%(%4L: %-23,23f%) %s\n")
;; 
;; 
;; (defun my/mail ()
;; ;;   "sort gnus mail in reverse date "
;; ;;   (interactive)
;; ;;   (gnus-group-read-group 20 nil "[Gmail]/Important") 
;; ;;   (gnus-summary-sort-by-most-recent-date)
;; ;; )
