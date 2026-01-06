; 20180629 -- enable wiki editing 
; 20230204 -- major upgrade to dokuwiki (local fork) removed a lot of custom code
(defun my/present-text ()
  "Change window/buffer for presenting agendas.  Use variable width font."
  (interactive)
  (setq-local line-spacing 3)
  (display-line-numbers-mode -1)
  ;; (font-face-attributes "-UKWN-URW Gothic-regular-normal-normal-*-23-*-*-*-*-0-iso10646-1")
  ;; (set-frame-font "-UKWN-URW Gothic-regular-normal-normal-*-23-*-*-*-*-0-iso10646-1")
  ;; (set-face-attribute 'default (selected-frame) :font "URW Gothic" :height 173)
  ;; Following mouse-set-font into mouse.el and searching "Set Buffer Font..."
  (buffer-face-mode-invoke (list :family "Helvetica" :height 120) t nil) ; URW Gothic
  ;; also readable: M+  -M+ 1m-bold-normal-normal-*-25-*-*-*-d-0-iso10646-1

  )

(use-package dokuwiki
  ;; :quelpa ((dokuwiki :fetcher github :repo "WillForan/emacs-dokuwiki") :upgrade t)
  :load-path "~/src/utils/emacs-dokuwiki"
  :ensure t
  :init
  (add-hook 'dokuwiki-page-opened-hook #'my/present-text)
  (add-hook 'dokuwiki-page-opened-hook #'my/no-lines)
  (add-hook 'dokuwiki-page-opened-hook #'flyspell-mode)
  (add-hook 'dokuwiki-page-opened-hook #'company-mode)
            ;; (lambda ()
            ;;   (message "setup")
            ;;   (dokuwiki-setup)
            ;;   (message "company")
            ;;   (company-mode 1)
            ;;   (message "present")
            ;;   (my/present-text)
            ;;   (message "spell")
            ;;   (flyspell-mode 1)
            ;;   ;; (message "dokuwiki")
            ;;   ;; (dokuwiki-mode)
            ;;   )
  )


(use-package dokuwiki-mode
  ;; :quelpa ((dokuwiki-mode :fetcher github :repo "WillForan/emacs-dokuwiki-mode") :upgrade t)
  :load-path "~/src/utils/emacs-dokuwiki-mode"
  :ensure t
  :config (require 'outline-magic))


;; (require 'epa)
;; (setenv "GPG_AGENT_INFO" nil)
;; (setq epg-gpg-program "gpg2")
;; edit ~/.authinfo
;; auth-source-forget-all-cached


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

(defun radwiki ()
  "Open wpic programmers wiki."
  (interactive)
  (require 'dokuwiki)
  (dokuwiki-launch "https://www.rad.pitt.edu/wiki/lib/exe/xmlrpc.php" "foran"))
(defun lncd (&optional start-page)
  "Open lncd wiki."
  (interactive)
  (require 'dokuwiki)
  (dokuwiki-launch "https://lncd.pitt.edu/wiki/lib/exe/xmlrpc.php" "will" start-page))

(defun dw-browse-url (url &optional func)
  "Open FUNC:// URL. default to lncd://"
  (let* ((func (if func func #'lncd))
         (url-prefix (concat (symbol-name func) "://"))
         (url-suffix (string-replace url-prefix "" url)))
    (funcall func url-suffix)))
;; lncd://:tools:switchtask
(defun lncd-browse-url (url &rest _ignore) (dw-browse-url url #'lncd))
(add-to-list 'browse-url-handlers '("\\`lncd://" . lncd-browse-url))

(defun dokuwiki-today-insert ()
  "Insert today yyyy-mm-dd as header."
  (interactive)
  (insert (format-time-string "===== %Y-%m-%d =====")))

(defun mrrcwiki ()
  "Open MRRC wiki."
  (interactive) (require 'dokuwiki) (dokuwiki-launch "https://wiki.mrrc.pitt.edu/lib/exe/xmlrpc.php" "foran"))

; 20250827 - like zim and roam bindings
(global-set-key (kbd "C-c N l") #'lncd)
(global-set-key (kbd "C-c N m") #'mrrcwiki)



;; 20230906 - editing github markdown as a wiki
(use-package gfm-wiki
  :quelpa ((gfm-wiki :fetcher github :repo "NPACore/gfm-wiki") :upgrade f)
  :bind (:map markdown-mode-map
              ("C-c M-L" . #'gfm-wiki-insert-link)
              ("C-c M-l" . #'gfm-wiki-insert-link-header)
              ("C-c M-i" . #'gfm-wiki-insert-issue)
              ("C-c M-d" . #'gfm-wiki-deft)))
