;; 20200922
;; M-i in isearch forwards to swoop
;; helm-multi-swoop-projectile cf. projetile-ag
(use-package helm-swoop :ensure t :defer t
 :config
  (global-set-key (kbd "M-i") 'helm-swoop)
  (global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
  (global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
  (global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all))
