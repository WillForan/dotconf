; 20180629 -- enable wiki editing 
; https://github.com/accidentalrebel/emacs-dokuwiki ? not in melpa
(use-package dokuwiki
  :config
   ;; (setq dokuwiki-xml-rpc-url "http://arnold.wpic.upmc.edu/dokuwiki/lib/exe/xmlrpc.php")
   (setq dokuwiki-login-user-name "will")
  :bind
   ("C-c w" . dokuwiki-list-pages)
   ("C-c s" . dokuwiki-save-page)
   ("C-c l" . dokuwiki-insert-link)     ; def. at bottom
)

(defun my/dokuwiki-launch (url user &optional no-launch)
  "Login to dokuwiki using URL and USER.  Open a page.  Set NO_LAUNCH for no page jump"
  (require 'dokuwiki)

  ;; (require 'epa)
  ;; (setenv "GPG_AGENT_INFO" nil)
  ;; (setq epg-gpg-program "gpg2")
  ;; edit ~/.authinfo

  (setq dokuwiki-xml-rpc-url (concat url "/lib/exe/xmlrpc.php")
        dokuwiki-login-user-name user)
  (dokuwiki-login)
  (unless no-launch
    (dokuwiki-list-pages)
    (dokuwiki-mode)))

(defun moonhog ()
  "Open moonhog wiki."
  (interactive)
  (my/dokuwiki-launch "https://www.swrd.trade/wiki" "will"))
(defun my/wpicprog ()
  "Open wpic programmers wiki."
  (interactive)
  (my/dokuwiki-launch "https://www.neuro-programmers.pitt.edu/wiki" "will"))
(defun my/lncd ()
  "Open lncd wiki."
  (interactive)
  (my/dokuwiki-launch "https://www.lncd.pitt.edu/wiki" "will"))

(defvar dokuwiki-cached-page-list nil
  "List of all pages cached for quick linking and listing.")

(defun dokuwiki-pages-list-get ( &optional refresh)
  "GES-LIST-GET: Get list of page; if cache is unset or REFRESH, fetch."
  (when (or (not dokuwiki-cached-page-list) refresh)
      (if (not dokuwiki--has-successfully-logged-in)
        (user-error "Login first before listing the pages")
        (let ((page-detail-list (xml-rpc-method-call dokuwiki-xml-rpc-url 'wiki.getAllPages))
              (page-list ()))
          (dolist (page-detail page-detail-list)
            (push (cdr (assoc "id" page-detail)) page-list))
          (setq dokuwiki-cached-page-list page-list))))
      dokuwiki-cached-page-list)

(defun dokuwiki-insert-link ()
  "Show a selectable list containing pages from the current wiki."
  (interactive)
  (if-let (page (completing-read "Select a page to open: " (dokuwiki-pages-list-get)))
      (insert (concat "[[:" page "]] "))))
