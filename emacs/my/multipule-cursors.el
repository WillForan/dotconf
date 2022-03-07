(use-package multiple-cursors :ensure t
  :config
  (global-unset-key (kbd "<menu>"))
  :bind
  ("<menu> l" . mc/mark-next-lines)
  ("<menu> L" . mc/mark-prev-lines)
  ("<menu> n" . mc/mark-next-like-this)
  ("<menu> p" . mc/mark-prev-like-this)
  ("<menu> w" . mc/mark-next-like-this-word)
  ("<menu> W" . mc/mark-prev-like-this-word)
  ("<menu> s" . mc/mark-prev-like-this-symbol)
  ("<menu> S" . mc/mark-prev-like-this-symbol))



;; 20210403 - C-7 is default binding for multi cursors at search
;; C-x r y to paste (rectangel paste)
(use-package swiper-mc :ensure t :after (swiper multiple-cursors) 
  :config
  (add-to-list 'mc/cmds-to-run-once #'swiper-mc))

(use-package evil-mc :ensure t :after (evil multiple-cursors) 
   
  :config
 (advice-add 'helm-swoop--edit :after #'evil-mc-mode)
 (advice-add 'helm-ag--edit :after #'evil-mc-mode))
