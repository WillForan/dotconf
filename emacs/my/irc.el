(use-package erc-image
  :ensure t
  :after erc
  :config
  (setq erc-image-inline-rescale 300)
  (add-to-list 'erc-modules 'image)
  (add-to-list 'erc-modules 'spelling)
  (add-to-list 'erc-modules 'bufbar)
  (add-to-list 'erc-modules 'nicks)
  )
(setq erc-hide-list '("MODE")) ; hide bitlbee/msteams spamming 'localhost changed mode'

;; (circe "irc.xn--4-cmb.com"
;;          :use-tls t
;;          :port 6697
;;          :nick "w"
;;          :user "w@e-x260/bit"
;;          :pass (car (process-lines "pass" "soju")))

(defun irc-soju (nick server)
  "Connect to local soju to remote SERVER using NICK.
Hardcode bouncer username."
  (let ((soju-pass (car (process-lines "pass" "soju")))
        (host (car (process-lines "hostname")))
        ;; (server (if server (concat "/" server) "")) ; does empty '/' connect to soju? TODO: test
        )
    (erc-tls :server "irc.xn--4-cmb.com"
             :id (concat nick "@" server)
             :port 6697 :nick nick
             :user (concat "w@e-" host "/" server)
             :password soju-pass)))

;;  #oldcomputerchallenge channel at irc://libera.chat
;; [[gnus:comp.infosystems.gopher#slrn107uq6q.m5r.anthk@openbsd.home][Email from Anthk NM: Re: Old Computer Challenge]]
(irc-soju "wwfn" "irc.libera.chat")
(irc-soju "work" "bit")
;; (irc-soju "w" "") ; soju itself

;; (erc-status-sidebar-open)
;; (erc-nickbar-enable)


;;; irc.el ends here
