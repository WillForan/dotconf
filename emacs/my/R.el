(use-package ess :defer t :ensure t
  :config
  ;; dont block when running R
  (setq ess-eval-visibly 'nowait)
  (which-function-mode 1)
  ;; with apl mode: setxkbmap -layout us,apl -variant ,dyalog -option grp:switch
  ;; right alt+x is ⊃  ;  r alt + ] is →

  (define-key ess-mode-map (kbd "→") " -> ")
  (define-key ess-mode-map (kbd "⊃") " %>% ")
  (define-key inferior-ess-mode-map (kbd "⊃") "%>%")
  ;; and make it look like what we pushed for maximum confusion
  (add-hook 'ess-mode-hook
	    (lambda ()
	      (setf prettify-symbols-alist
		    (cl-list*
		     '("%>%" . ?⊃)
		     ;; '("->"  . ?→) ; already set
		     ;; '("<-"  . ?←)
		     prettify-symbols-alist)))))
