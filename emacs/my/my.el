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

(defun my/quit-other ()
  "quit e.g. help buffer without switching to it.
  with-selected+otherwindow from inspecting M-<next> (scroll-other-window)
  cf. my/other-window-kill"
  (interactive)
  (with-selected-window (other-window-for-scrolling) (quit-window)))

(defun my/quit-help ()
  "quit all *Help* buffers. using dash"
  (apply #'quit-restore-window
   (-filter (lambda (w)
      (-> w (window-buffer) (buffer-name) (equal "*Help*")))
    (window-list))))

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

(defun last-message (&optional num)
  "from https://unix.stackexchange.com/questions/154098/copy-the-last-emacs-message-into-the-current-buffer#answer-154154"
  (or num (setq num 1))
  (save-excursion
    (set-buffer "*Messages*")
    (save-excursion
      (forward-line (- 1 num))
      (backward-char)
      (let ((end (point)))
	(forward-line 0)
	(buffer-substring-no-properties (point) end)))))
(defun my/clip-mesg ()
  "buffer filename to clipboard"
  (interactive)
  (kill-new (last-message)))

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

(defun my/center-text ()
  "add margins to current window to center at 80 characters"
    (interactive)
    (let* ((win (get-buffer-window))
	  (margin (max 0 (/ (- (window-width win) 80) 2))))
	  (set-window-margins win margin margin)))

(defun my/loadinit ()
     "load default set of 'layers'"
     (interactive)
     ;; use-package defintions for packages (a la spacemace layers?)
     (mapcar #'my/use
     '(package
       base backup primary-clip helm
       company yas
       quelpa
       evil rainbow
       xterm-color
       git
       tramp
       ace switch-window
       zim-wiki-mode screensend
       swiper helm-swoop
       python R
       lisp lint ;; these take a long time
       org
       roam annote
       ;; last -- if not applied we know something went wrong
       frame-settings theme
       )))

(defun my/note-now (&optional notes)
  "use org journal with org roam settings to start a note
timestamps w/current time (now) in a weekly folder. see my/roam.el
if any NOTES will insert that"
  (interactive)
  (when (not (fboundp 'org-journal-new-entry)) (my/use 'roam))
  (org-journal-new-entry nil)
  (when notes (insert notes)))

(defun my/backspace-key () (interactive) (keyboard-translate ?\C-h ?\C-?))
