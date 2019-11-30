;; discoverable/fuzzy search features
(use-package helm :ensure t :defer t
  :bind
    ("M-X" . helm-M-x)
    ("C-x B" . helm-mini) ;; also see helm-buffers-list
    ("C-x F" . helm-find-files)
  :config
    ;; 20181016 - tab instead of C-j: https://github.com/emacs-helm/helm/issues/1630
    ;(define-key helm-find-files-map "\t" 'helm-execute-persistent-action)
)
