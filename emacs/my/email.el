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
              mail-specify-envelope-from t
              message-sendmail-envelope-from 'header
              mail-envelope-from 'header
              send-mail-function 'message-send-mail-with-sendmail)
  (no-auto-fill)
  (flyspell-mode-on))

;; 20211110 - work uses notmuch on remote computer. personal uses mu
(defun my/notmuch ()
  (interactive)
  (notmuch-tree "date:1week.. -tag:delete"))

(use-package "notmuch" :ensure t
  :custom
  ;; 20220107 - redefine jumps on 'j'
  (notmuch-saved-searches '((:name "week" :query "(date:1w.. -tag:delete) OR tag:todo" :key "w")
                (:name "unread" :query "tag:inbox AND tag:unread AND -tag:delete" :key "u")))
  :config
  ;; use remote server's database. todo: not if (system-name) is work?
  (setq notmuch-command (expand-file-name "~/bin/notmuch-remote"))

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

