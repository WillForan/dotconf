;; 20210917 - clojure lint 
(use-package flycheck-clj-kondo :ensure t)
;; use it in clojure (and lispy mode)
(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook (lambda () (lispy-mode 1)))
  (require 'flycheck-clj-kondo))
