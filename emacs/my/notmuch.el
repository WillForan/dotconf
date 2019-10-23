; 20181025 -- emacs sendmail
(setq user-mail-address "willforan+upmc@gmail.com")
(setq user-full-name "Will Foran")

; 20180625 - kill notmuch and emacsclient as opened by wf-utils/mail/redirmail.bash
(defun notmuch-quit-frame ()
 (interactive)
 (notmuch-bury-or-kill-this-buffer)
 (delete-frame))
(use-package notmuch
  :init
   (add-hook 'notmuch-show (lambda () (local-set-key (kbd "C-M-q") #'notmuch-quit-frame)))
  :config
   (setq notmuch-search-oldest-first nil         ; new first
      message-sendmail-envelope-from 'header  ; reply with address email was sent to
      mail-specify-envelope-from 'header      ; "
      mail-envelope-from 'header              ; "
      notmuch-multipart/alternative-discouraged '("text/plain" "text/html") ; prefer html over text, and other stuff over that
   ))
