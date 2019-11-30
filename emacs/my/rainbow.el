;; rainbow delims
(use-package rainbow-delimiters :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))
