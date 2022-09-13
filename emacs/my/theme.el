;; light 
;(use-package  parchment-theme :ensure t :config (load-theme 'parchment t))

;; dark
(use-package helm-themes :ensure t)
(use-package graphite-theme :quelpa
  (graphite-theme :fetcher github :repo "codemicmaves/graphite-theme"))
(use-package moe-theme :after helm-themes
  :defer f
  :ensure t
  :init
  (require 'helm-themes)
  (helm-themes--load-theme "moe-dark"))

;; 20220809 using base16-eva

;; (use-package moe-theme :ensure t :config (load-theme 'moe-dark t))
; (use-package  monokai-theme :ensure t :config (load-theme 'monokai t))
; also see 
; doom-monokai-classic, doom-drakula, 
; but doom themes do not increase text size for org mode
