;; should revist (20210405). there are more uptodate packages?
;; (use-package git-gutter-fringe :ensure t
;;   :config
;;    (global-git-gutter-mode t))
(use-package diff-hl :ensure t
  :config (global-diff-hl-mode))
(use-package magit :ensure t :defer t
  :config
  ;; mouse highlight text of menu
  ;; https://github.com/magit/transient/issues/126
  (keymap-set transient-predicate-map
              "<mouse-set-region>"
              #'transient--do-stay)
  )
(use-package forge :ensure t :defer t :after magit)

;; 20230207 - picked up conventonal-commit and folowed it to link and timemachine
(use-package git-link :ensure t)
(use-package git-timemachine :ensure t)

;; 20230211 - startup compains about :quelpa keyword
;; 20260605 - use :vc instead of quelpa;
(use-package conventional-commit :ensure t
  :vc (:url "https://github.com/akirak/conventional-commit.el")
  :config
  (add-hook 'company-backends #'company-capf)
  :hook
  (git-commit-mode . conventional-commit-setup))

;; 20251107 from https://github.com/magit/forge/issues/75
(use-package code-review
  :after forge
  :quelpa ((code-review
            :fetcher github
            :repo "phelrine/code-review"
            :branch "fix/closql-update")))
