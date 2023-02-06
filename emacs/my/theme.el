;; light 
;(use-package  parchment-theme :ensure t :config (load-theme 'parchment t))

;; dark
(use-package helm-themes :ensure t)
(use-package moe-theme :after helm-themes
  :defer f
  :ensure t
  :init
  (require 'helm-themes)
  (helm-themes--load-theme "moe-dark"))

;; (use-package graphite-theme :quelpa
;;   (graphite-theme :fetcher github :repo "codemicmaves/graphite-theme"))

;; 20220809 using base16-eva
;;base16-eva, base16-gruvbox-dark-hard, base16-drakula
;; (use-package base16-theme :ensure t :config (load-theme 'base16-eva t))
;; (use-package  monokai-theme :ensure t :config (load-theme 'monokai t))
;; doom themes  do not increase text size for org mode but are otherwise a nice collection
;;   esp. doom-monokai-classic, doom-drakula

;; also see C-h v custom-enabled-themes
(defun my/theme-random () (interactive)
       (let ((rand-theme (symbol-name (seq-random-elt (custom-available-themes)))))
         (message (concat "random theme: " rand-theme))
         (helm-themes--load-theme rand-theme)))
