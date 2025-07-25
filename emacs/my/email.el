(setq  send-mail-function 'sendmail-send-it)
(defun no-auto-fill () (auto-fill-mode -1))

;; org-mime and org-msg have overlapping functionality?
;; 20220502 - prefer org-msg (?why? -- spent more time with it first)
;; (use-package org-mime :ensure t
;;   :config
;;   (setq org-mime-export-options '(:with-latex dvipng
;;                                               :section-numbers nil
;;                                               :with-author nil
;;                                               :with-toc nil))
;;   ;; if all emails are intended to be htmlized
;;   ;; (add-hook 'message-send-hook 'org-mime-confirm-when-no-multipart)
;;   (add-hook 'message-mode-hook
;;             (lambda () (local-set-key (kbd "C-c M-o") 'org-mime-htmlize)))
;;   (add-hook 'org-mode-hook
;;             (lambda () (local-set-key (kbd "C-c M-o") 'org-mime-org-buffer-htmlize))))

;; META: if we want to refactor this to use let/variables for actual email and sendmail
;; how could we use structural editing to do it quickly
(defun my/quick-email ()
  (interactive)
  ;; change from is address is not set
  (save-excursion (beginning-of-buffer)
                  (if (re-search-forward "^From:.*tickle-me" nil t)
                      (replace-match "From: will.foran+from.emacs@gmail.com"))
                  (if (re-search-forward "^From:.*foranw@u.*" nil t)
                      (replace-match "From: will.foran+from.emacs@gmail.com"))
                  (if (re-search-forward "^From:.*mail-host-address-is-not-set" nil t)
                      (replace-match "From: will.foran+from.emacs@gmail.com")))
  ;; start a the To: line
  (beginning-of-buffer)
  (if (re-search-forward "^To:" nil t)
      (goto-char (match-end 0)))
  (evil-insert-state)
  ;; all using msmtprc. but might need to pipe to 'ssh homeserver sendmail'
  ;; (ie. where gmail is blocked)

  (setq-local
   ;; mail-user-agent 'message-user-agent ;; intstead of e.g. mu4e
   message-send-mail-function 'message-send-mail-with-sendmail ;; really want below?
   user-mail-address "willforan@gmail.com"
   send-mail-function 'sendmail-send-it
   sendmail-program (if (string= (system-name) "reese") "~/bin/s2sendmail" "sendmail")))

;; empty for some reason w/text-mode in message-mode dont even complete
 (require 'yasnippet)
 (yas-define-snippets
  'message-mode
  (list (list "em" (shell-command-to-string "pass contacts/em|tr -d '\n'"))
        (list "yearof" (shell-command-to-string "pass contacts/oldbeech|tr -d '\n'"))))



;; https://jao.io/blog/2021-08-19-notmuch-threads-folding-in-emacs.html
;; use outline mode for thread folding
;; invisible "> " prefix on message lines that are the first in a thread (notmuch handily marks them with :first in the message metadata passed to notmuch-tree-insert-msg).
;; tell outline mode to use a regular expression that recognises the marker above:
(defun jao-notmuch-tree--msg-prefix (msg)
  (insert (propertize (if (plist-get msg :first) "> " "  ") 'display "")))
(defun jao-notmuch-tree--mode-setup ()
  (setq-local outline-regexp "^> \\|^En")
  (outline-minor-mode t))


;; toggle a tag by keybinding
;; modfied from hints on https://notmuchmail.org/emacstips
(defun notmuch-toggle-tag (tag tag-func)
  "toggle tag for message. tag-func like #'notmuch-show-tag"
  (let ((add-or-rm (if (member tag (notmuch-show-get-tags))
                       "-" "+")))
      (funcall tag-func (list (concat add-or-rm tag)))))
(defun notmuch-keybind-tag-everywhere (key tag)
    (define-key notmuch-show-mode-map key   `(lambda () (interactive) (notmuch-toggle-tag ,tag #'notmuch-show-tag)))
    (define-key notmuch-tree-mode-map key   `(lambda () (interactive) (notmuch-toggle-tag ,tag #'notmuch-tree-tag) (notmuch-tree-next-message)))
    (define-key notmuch-search-mode-map key `(lambda () (interactive) (notmuch-toggle-tag ,tag #'notmuch-search-tag))))

(setq my-notmuch-inbox-search "(date:1w.. -tag:delete) OR tag:todo")
(defun my-notmuch-tree ()
  (interactive)
  (progn (notmuch-search my-notmuch-inbox-search)
         (notmuch-tree-from-search-current-query)))

;; 20220328 - sendmail w/ notmuch (work email)
;; https://notmuchmail.org/pipermail/notmuch/2019/028633.html
(defun my/work-mail-setup ()
  (interactive)
  (setq-local sendmail-program (if (string= (system-name) "reese")
                                   "/usr/sbin/sendmail"
                                 "~/bin/sendmail-remote")
              user-mail-address "foranw@upmc.edu"
              mail-specify-envelope-from t
              message-sendmail-envelope-from 'header
              mail-envelope-from 'header
              send-mail-function 'message-send-mail-with-sendmail)
  (no-auto-fill)
  (flyspell-mode-on))

;; 20211110 - work uses notmuch on remote computer. personal uses mu
(defun my/notmuch ()
  (interactive)
  (setq user-mail-address "foranw@upmc.edu" user-full-name  "Will Foran")
  (org-msg-mode-notmuch)
  (notmuch-tree "date:1week.. -tag:delete"))

(use-package notmuch :ensure t
  :custom
  ;; 20220107 - redefine jumps on 'j'
  (notmuch-saved-searches '((:name "week" :query "(date:1w.. -tag:delete) OR tag:todo" :key "w")
                (:name "unread" :query "tag:inbox AND tag:unread AND -tag:delete" :key "u")))
  :config
  ;; use remote server's database. todo: not if (system-name) is work?
  (setq notmuch-command (if (not (string= (substring (system-name) 0 5) "reese")) (expand-file-name "~/bin/notmuch-remote") "notmuch"))

  ;; 20220328 - sendmail using remote if needed
  (add-hook 'notmuch-message-mode-hook 'my/work-mail-setup)

  ;; 20220808 - x and a actions
  (setq notmuch-archive-tags '("-inbox" "-new"))

  ;; 20211202 use jao's outline mode trick
  (advice-add 'notmuch-tree-insert-msg :before #'jao-notmuch-tree--msg-prefix)
  (add-hook 'notmuch-tree-mode-hook #'jao-notmuch-tree--mode-setup)
  (define-key notmuch-tree-mode-map (kbd "TAB") #'outline-cycle)
  (define-key notmuch-tree-mode-map (kbd "M-TAB") #'outline-cycle-buffer)

  ;; quick tags defined for show, tree, and search modes
  (notmuch-keybind-tag-everywhere "d"  "delete")
  (notmuch-keybind-tag-everywhere "T"  "todo"))

(use-package org-download :ensure t)    ; 20220501 - org-download-paste for clipboard images
(use-package org-msg :ensure t
  :config
  ;; (setq mail-user-agent 'message-user-agent) ; default
  ;; (setq mail-user-agent 'notmuch-user-agent) ; doesn't work. sends =-=-= blank message
  ;; (setq mail-user-agent 'mu4e-user-agent) ; 20220501
  ;; ; (org-msg-mode-notmuch) adds advice to notmuch-mua-{reply,mail}
  ;; ; notmuch-mua-reply called by try reply, defined by macro for 'r'
  ;; (setq-local org-msg-enforce-css "~/Downloads/org-msg.css")
  (setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t")
  (setq org-msg-convert-citation t)

  ;; 20250725: keep in org mode for plaintext version
  ;; this makes duplicate text entriesj
  (add-to-list 'org-msg-alternative-exporters
             '(text "text/plain" . identity))
  )

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
 :load-path "/usr/share/emacs/site-lisp/"
 :config
 (setq mu4e-compose-reply-to-address "will.foran@gmail.com"
       user-mail-address "will.foran@gmail.com"
       user-full-name  "Will Foran"
       mail-user-agent 'mu4e-user-agent
       ;; 20230226 - from mu manual: Type: text/plain; format=flowed
       mu4e-compose-format-flowed t)

 ;; 20230226 -- annotated by not added.
 ;; inline email not displaying in outlook? change the replay format
 ;; (setq  message-citation-line-format "On %Y-%m-%d at %R %Z, %f wrote...")

 ;; 20230225 from 'man mbsync'
 ;; When using the more efficient default UID mapping scheme, it is important that the MUA renames files when
 ;; moving them between Maildir folders.  Mutt always does that, while mu4e needs to be configured to do it:
 (setq mu4e-change-filenames-when-moving t)

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
 (add-hook 'mu4e-compose-mode-hook #'no-auto-fill))

;; mu4e org links functions.
;; TODO: evil leader keys should probably go somewhere else (20220502)
;;       likewise for get-mail-command
(use-package "org-mu4e" :load-path "/usr/share/emacs/site-lisp/mu4e"
  :config
  (evil-leader/set-key "M" #'mu4e)
  (evil-leader/set-key "M-M" #'notmuch)
  :custom
  (mu4e-get-mail-command "ssh s2 mbsync -a"))
(use-package "mu4e-conversation" :ensure t)

(defun my/html-email-org-msg ()
  "Switch compose to org-msg (outlook like styling)."
  (interactive)
  ;; (setq mail-user-agent 'notmuch-user-agent) ; mu4e-user-agent

  ;; 20241010 sent but unsent buffers stays. maybe because of error:
  ;; primitive-undo: Unrecognized entry in undo list undo-tree-canary
  ;; (setq undo-tree-enable-undo-in-region nil) ; doesn't help

  ;; 20250312 - weird undo behavior when generating email preview
  ;; disabling this in case that's it
  (setq-local evil-undo-system 'undo-redo)

  (org-msg-edit-mode)
  ;; 20250302: set email style (box for code and results)
  ;; (setq org-msg-enforce-css "/home/foranw/Downloads/org-msg.css")
  (save-excursion
    (beginning-of-buffer)
    (search-forward "--text follows this line--")
    (end-of-line)
    (insert "\n")
    (insert (org-msg-header 'new '(text html)))
    (search-backward "reply-to:")
    ;; 20250725: replace (kill-whole-linwce) with non-kill ring version
    (delete-region (line-beginning-position) (line-end-position))
    ;; 20250302: org-babel settings for email
    (search-backward "OPTIONS")
    (end-of-line)
    (insert "\n#+PROPERTY: header-args :exports both :eval no-export")
    ;; load above settings and org-msg-options inserted by org-msg-header
    (org-ctrl-c-ctrl-c)
    ;; must set sendmail after C-c C-c
    (goto-char 0)
    (when (looking-at "^From:.*upmc.edu")
      (my/work-mail-setup)
      (message "switched to work sendmail"))))

(defun my/mail-org-header ()
  "Send a mail to emily from an org header.
Pipeline is intented to be firefox-> org-protocol-> capture -> email."
  (interactive)
  (let* ((this-head (org-get-heading))
         (content (progn  (org-mark-subtree) (buffer-substring (point) (mark))))
         ;; remove head - canpt use (length this-head) b/c var num of '*' have been stripped
         (content  (substring content (+ 1 (string-match "\n" content))))
         ;; remove date
         (content (replace-regexp-in-string "^\s*[[0-9-]\+ [MTWFS][a-z][a-z]\]\s*" "" content)))
    (compose-mail "emily.mente@gmail.com" this-head)
    (insert content)))

(defun my/simple-mail ()
    (interactive)
    ;; likley mu4e-user-agent
    (setq mail-user-agent 'message-user-agent))


;; 20241211
;; (use-package himalaya :ensure t)
