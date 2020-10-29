(defun my/use (pkg)
  "load symbol `PKG' use-package config from emacs.d/my directory"
  ;; if interactive: give list basename
  (interactive (list (make-symbol
    (completing-read "Spkg:" (mapcar #'file-name-base (directory-files "~/.emacs.d/my/"))))))
  (load (concat "~/.emacs.d/my/" (symbol-name pkg) ".el")))

;; 20191116 - one frame (x11 window) for each emacs window (pane)
;; https://www.emacswiki.org/emacs/download/oneonone.el

(defun my/edit ()
  "List files for editing local config using projectile"
  (interactive)
  ;(projectile-find-file-in-directory "~/.emacs.d/my/")
  ;(directory-files-recursively "~/.emacs.d/my" "[A-Za-z].*.el")
  (let ((default-directory "~/.emacs.d/my/"))
    (projectile-find-file)
  )
)

(defun my/dokuwiki ()
  "Connects to the dokuwiki."
  (interactive)
  (my/use 'dokuwiki)
  (dokuwiki-login)
  (dokuwiki-list-pages)
  (dokuwiki-mode)
  )

(defun my/clip-fname ()
  "buffer filename to clipboard"
  (interactive)
  (kill-new (buffer-file-name)))

(defun my/loadinit ()
     "load default set of 'layers'"
     (interactive)
     ;; use-package defintions for packages (a la spacemace layers?)
     (mapcar #'my/use
     '(base backup primary-clip
 	package quelpa
 	evil theme rainbow
 	xterm-color
 	git
 	org tramp
 	ace switch-window
 	yas company helm
 	zim-wiki-mode screensend
	helm-swoop
 	R)))
