(defun my/use (pkg)
  "load symbol `PKG' use-package config from emacs.d/my directory"
  (load (concat "~/.emacs.d/my/" (symbol-name pkg) ".el")))

;; 20191116 - one frame (x11 window) for each emacs window (pane)
;; https://www.emacswiki.org/emacs/download/oneonone.el


(defun my/edit ()
  "List files for editing local config"
  (interactive)
  ;(projectile-find-file-in-directory "~/.emacs.d/my/")
  ;(directory-files-recursively "~/.emacs.d/my" "[A-Za-z].*.el")
  (let ((default-directory "~/.emacs.d/my/"))
    (projectile-find-file)
  )
)
