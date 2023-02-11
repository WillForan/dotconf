;; should revist (20210405). there are more uptodate packages?
;; (use-package git-gutter-fringe :ensure t
;;   :config
;;    (global-git-gutter-mode t))
(use-package diff-hl :ensure t
  :config (global-diff-hl-mode))
(use-package magit :ensure t :defer t)
(use-package forge :ensure t :defer t :after magit)

;; 20230207 - picked up conventonal-commit and folowed it to link and timemachine
(use-package git-link :ensure t)
(use-package git-timemachine :ensure t)
(use-package conventional-commit :ensure t
  :quelpa ((conventional-commit :fetcher github :repo "akirak/conventional-commit.el") :upgrade t)
  :config
  (add-hook 'company-backends #'company-capf)
  :hook
  (git-commit-mode . conventional-commit-setup))
