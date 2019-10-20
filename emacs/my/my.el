(defun my/use (pkg)
  "load symbol `PKG' use-package config from emacs.d/my directory"
  (load (concat "~/.emacs.d/my/" (symbol-name pkg) ".el")))

(defun my/get-primary ()
  "paste x11 primary"
  (interactive)
  (insert (gui-get-primary-selection)))
