;; discoverable/fuzzy search features
(use-package helm :ensure t :defer t
  :bind
    ("M-X" . helm-M-x)
    ("C-x B" . helm-mini) ;; also see helm-buffers-list
    ("C-x F" . helm-find-files)
)
