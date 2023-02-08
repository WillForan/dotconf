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


(defun moonhog ()
  "Open moonhog wiki."
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
