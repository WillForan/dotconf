; 20180629 -- enable wiki editing 
; 20230204 -- major upgrade to dokuwiki (local fork) removed a lot of custom code
(use-package dokuwiki
  ;; :quelpa ((dokuwiki :fetcher github :repo "WillForan/emacs-dokuwiki") :upgrade t)
  :load-path "~/src/utils/emacs-dokuwiki"
  :ensure t
  :hook
  ((dokuwiki-open-page .
    (lambda ()
      (dokuwiki-setup)
      (company-mode 1)
      (display-line-numbers-mode -1)
      (flyspell-mode 1)))))

(use-package dokuwiki-mode
  ;; :quelpa ((dokuwiki-mode :fetcher github :repo "WillForan/emacs-dokuwiki-mode") :upgrade t)
  :load-path "~/src/utils/emacs-dokuwiki-mode"
  :ensure t
  :config (require 'outline-magic))


;; (require 'epa)
;; (setenv "GPG_AGENT_INFO" nil)
;; (setq epg-gpg-program "gpg2")
;; edit ~/.authinfo


(defun moonhog ()
  "Open moonhog, the SWRD Trading LLC wiki."
  (interactive)
  (require 'dokuwiki)
  (dokuwiki-launch "https://www.swrd.trade/wiki/lib/exe/xmlrpc.php" "will"))

(defun wpicprog ()
  "Open wpic programmers wiki."
  (interactive)
  (require 'dokuwiki)
  (dokuwiki-launch "https://www.neuro-programmers.pitt.edu/wiki/lib/exe/xmlrpc.php" "will"))
(defun lncd ()
  "Open lncd wiki."
  (interactive)
  (require 'dokuwiki)
  (dokuwiki-launch "http://lncd.pitt.edu/wiki/lib/exe/xmlrpc.php" "will"))


;; 20230906 - editing github markdown as a wiki
(use-package gfm-wiki
  :quelpa ((gfm-wiki :fetcher github :repo "NPACore/gfm-wiki") :upgrade f)
  :bind (:map markdown-mode-map
              ("C-c M-L" . #'gfm-wiki-insert-link)
              ("C-c M-l" . #'gfm-wiki-insert-link-header)
              ("C-c M-i" . #'gfm-wiki-insert-issue)
              ("C-c M-d" . #'gfm-wiki-deft)))
