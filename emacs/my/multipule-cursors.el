(use-package evil-multiedit :ensure t)
(use-package multiple-cursors :ensure t
  :init
  ;; avoid "non-prefix key <menu>"
  (global-unset-key (kbd "<menu>"))
  ;; (define-key map (kbd "C-v") nil) 
  :config

   ;; https://github.com/bling/dotemacs/blob/3f54d68b112150a3b58557231ab6bbf7fd48a5e6/config/init-misc.el#L10
  (setq mc/unsupported-minor-modes
        '(company-mode auto-complete-mode flyspell-mode jedi-mode))
  (after 'evil
    (add-hook 'multiple-cursors-mode-enabled-hook 'evil-emacs-state)
    (add-hook 'multiple-cursors-mode-disabled-hook 'evil-normal-state))
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

