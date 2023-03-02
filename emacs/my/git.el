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

;; 20230211 - startup compains about :quelpa keyword
;; quelpa loaded in quelpa.el from my.el. should already exist
(require 'quelpa-use-package)
(use-package conventional-commit :ensure t
  :quelpa ((conventional-commit :fetcher github :repo "akirak/conventional-commit.el"))
  :config
  (add-hook 'company-backends #'company-capf)
  :hook
  (git-commit-mode . conventional-commit-setup))
