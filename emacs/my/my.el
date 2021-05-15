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

(defun my/use-url (url)
  "Download and load url. right now just loads basename from pkgs directory"
  (let ((pkg-dir "~/.emacs.d/pkgs/"))
    ;; TODO: exists or download to pkg-dir
    (load-file (expand-file-name (concat pkg-dir (file-name-base url) ".el")))
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

(defun my/other-window-kill ()
  "A window just opened w/o focus. buffer name has a *. kill it"
  (interactive)
  (let* ((cur (selected-window))
        (next (next-window))
	(next-buffer (window-buffer (next-window)))
        (next-name (buffer-name next-buffer)))
     (if (string-match-p "*" next-name) 
       (kill-buffer next-buffer))))

(defun my/frame-settings (_)
  "load settings specific to frame display"
  (my/use 'frame-settings))

(defun my/loadinit ()
     "load default set of 'layers'"
     (interactive)
     ;; use-package defintions for packages (a la spacemace layers?)
     (mapcar #'my/use
     '(package
        base backup primary-clip
 	quelpa
 	evil rainbow
 	xterm-color
 	git
 	tramp
 	ace switch-window
 	yas company helm
 	zim-wiki-mode screensend
	swiper helm-swoop
 	R
	lisp
	org
	theme frame-settings)))
