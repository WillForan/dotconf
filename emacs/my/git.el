;; should revist (20210405). there are more uptodate packages?
;; (use-package git-gutter-fringe :ensure t
;;   :config
;;    (global-git-gutter-mode t))
(use-package diff-hl :ensure t
  :config (global-diff-hl-mode))

(use-package magit :ensure t)
(use-package forge :ensure t :after magit)
