;; -*- lexical-binding: t; -*-
;;; Commentary:
;; setup elfeed using url stored in password store
;; After setup, use
;;   elfeed-protocol-fever-reinit
;;   elfeed-log-show
;;; Code:
(defun elfeed-proto-from-url (url)
  "Create elfeed protocol parameter list from a URL like fever+https://user:pass@domain."
  (when (string-match "https?://\\([^:]+\\):\\([^@]+\\)@\\(.*\\)" url)
    (let ((user (match-string 1 url))
          (password (match-string 2 url))
          (domain (match-string 3 url)))
      `(list ("fever+https://foranw@www.xn--4-cmb.com/miniflux/fever/"
	     :useor ,user
	     :api-url ,(concat "https://" domain)
	     :password ,password)))))

(use-package elfeed :defer t :ensure t)
(use-package elfeed-protocol :defer t :ensure t
  :config
  (require 'cl) 			; incf
  (setq minifluxfever (replace-regexp-in-string "\n" "" (shell-command-to-string "pass local/miniflux-fever_url")))
  ;; (setq elfeed-protocol-feeds (list  (list (concat "fever+" minifluxfever))))
  ;; (setq elfeed-protocol-feeds nil) ; 20260608 1.0.0 update. this variable shouldn't be used
  ;; (setq elfeed-feeds '(("fever+https://foranw@www.xn--4-cmb.com/miniflux/fever/"
  ;;       			 :user "fxxxxx"
  ;;       			 :api-url "https://www.yyyyyy/miniflux/fever/"
  ;;       			 :password "xxxxxxxxxxx")))
  (setq elfeed-feeds (elfeed-proto-from-url minifluxfever))
  (setq elfeed-protocol-enabled-protocols '(fever))
  (elfeed-protocol-enable))

;;; rss.el ends here
