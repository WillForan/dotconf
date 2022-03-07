(defun no-auto-fill () (auto-fill-mode -1))

;; 20211110 - work uses notmuch on remote computer. personal uses mu
(use-package "notmuch" :ensure t
 :config
 (setq notmuch-command (expand-file-name "~/bin/notmuch-remote")))
(use-package org-msg :ensure t
  :config
  ;; (setq mail-user-agent 'message-user-agent) ; default
  ;; (setq mail-user-agent 'notmuch-user-agent) ; doesn't work. sends =-=-= blank message
  ;; ; (org-msg-mode-notmuch) adds advice to notmuch-mua-{reply,mail}
  ;; ; notmuch-mua-reply called by try reply, defined by macro for 'r'
  (setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t")
  (setq org-msg-convert-citation t))

;; 20211026
;; https://emacs.stackexchange.com/questions/52657/attaching-files-in-mu4e-from-the-clipboard
;; original uses default-directory but don't want to pollute home folder (default w/draft buffer)
;; TODO: inspect filetype on clipboard. panic if not image
(defun my/clip-to-PNG ()
  (interactive)
  (let
      ((image-file (concat "/tmp/" (format-time-string "tmp_%Y%m%d_%H%M%S.png"))))
    (shell-command-to-string (concat "xclip -o -selection clipboard -t image/png > " image-file))
    image-file))
(defun my/mu4e-attach-image-from-clipboard ()
  (interactive)
  (let ((image-file (my/clip-to-PNG)) ;; paste clipboard to temp file
    (pos (point-marker)))
    (goto-char (point-max))
    (mail-add-attachment image-file)
    (goto-char pos)))

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

 ;; 20211026 - disable auto-newline at longer lines
 (add-hook 'mu4e-compose-mode-hook #'no-auto-fill)
)
(use-package "org-mu4e"
 :load-path "/usr/share/emacs/site-lisp/mu4e"
)
(use-package "mu4e-conversation" :ensure t)

