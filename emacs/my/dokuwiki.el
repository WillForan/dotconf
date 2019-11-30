; 20180629 -- enable wiki editing 
; https://github.com/accidentalrebel/emacs-dokuwiki ? not in melpa
(use-package dokuwiki
  :config
   (setq dokuwiki-xml-rpc-url "http://arnold.wpic.upmc.edu/dokuwiki/lib/exe/xmlrpc.php")
   (setq dokuwiki-login-user-name "will")
  :bind
   ("C-c w" . dokuwiki-list-pages)
)
