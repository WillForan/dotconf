(defun my/use (pkg)
  "load symbol `PKG' use-package config from emacs.d/my directory"
  ;; if interactive: give list basename
  (interactive (list (make-symbol
    (completing-read "Spkg:" (mapcar #'file-name-base (directory-files "~/.emacs.d/my/"))))))
  (load (concat "~/.emacs.d/my/" (symbol-name pkg) ".el")))

;; 20191116 - one frame (x11 window) for each emacs window (pane)
;; https://www.emacswiki.org/emacs/download/oneonone.el

(defun my/edit ()
  "List files for editing local config using projectile."
  (interactive)
  ;(projectile-find-file-in-directory "~/.emacs.d/my/")
  ;(directory-files-recursively "~/.emacs.d/my" "[A-Za-z].*.el")
  (require 'projectile)
  (let ((default-directory "~/.emacs.d/my/"))
    (projectile-find-file)
  )
)
(use-package projectile
  :config
  (setq projectile-project-search-path
       '("~/config/"
         ("~/src/" . 1 )
         ;("~/src/utils/" . 1 )
         ("~/src/work/" . 2 )
         ("~/src/play/" . 1)))
; (projectile-discover-projects-in-search-path)
)

(defun my/quit-other ()
  "Quit e.g. help buffer without switching to it.
  with-selected+otherwindow from inspecting M-<next> (scroll-other-window)
  cf. my/other-window-kill"
  (interactive)
  (with-selected-window (other-window-for-scrolling) (quit-window)))

(defun my/quit-help ()
  "Quit all *Help* buffers using dash."
  (apply #'quit-restore-window
   (-filter (lambda (w)
      (-> w (window-buffer) (buffer-name) (equal "*Help*")))
    (window-list))))

(defun my/use-url (url)
  "Download and load URL.  Currently, only load basename from pkgs directory."
  (let ((pkg-dir "~/.emacs.d/pkgs/"))
    ;; TODO: exists or download to pkg-dir
    (load-file (expand-file-name (concat pkg-dir (file-name-base url) ".el")))
    )
  )

(defun my/dokuwiki ()
  "Connects to the lncd dokuwiki."
  (interactive)
  (my/use 'dokuwiki)
  (dokuwiki-login)
  (dokuwiki-list-pages)
  (dokuwiki-mode))

(defun my/dokuwiki-np ()
  "Connects to the neuroprogrammers dokuwiki."
  (interactive)
  (my/use 'dokuwiki)
   (setq dokuwiki-xml-rpc-url
         "http://arnold.wpic.upmc.edu/dokuwiki/lib/exe/xmlrpc.php"
    dokuwiki-login-user-name "will")
  (dokuwiki-login)
  (dokuwiki-list-pages)
  (dokuwiki-mode))

(defun my/clip-fname ()
  "Buffer filename to clipboard."
  (interactive)
  (kill-new (buffer-file-name)))

(defun last-message (&optional num)
  "Look NUM lines back in *Messages* buffer."
  ;;https://unix.stackexchange.com/questions/154098/copy-the-last-emacs-message-into-the-current-buffer#answer-154154
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

(defun my/center-text ()
  "add margins to current window to center at 80 characters"
    (interactive)
    (let* ((win (get-buffer-window))
	  (margin (max 0 (/ (- (window-width win) 80) 2))))
	  (set-window-margins win margin margin)))

(defun my/loadinit ()
     "Load default set of 'layers'."
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
       email
       ;; last -- if not applied we know something went wrong
       frame-settings theme)))

(defun my/note-now (&optional notes)
  "use org journal with org roam settings to start a note
timestamps w/current time (now) in a weekly folder. see my/roam.el
if any NOTES will insert that"
  (interactive)
  (when (not (fboundp 'org-journal-new-entry)) (my/use 'roam))
  (org-journal-new-entry nil)
  (when notes (insert notes)))

(defun my/backspace-key () (interactive) (keyboard-translate ?\C-h ?\C-?))

(defun my/tildeblog ()
  "Quickly open tilde index.html."
  (interactive)
  (find-file "/ssh:tilde:public_html/index.html"))
;; 20231210 - quick blog
(defun my/weblog ()
  "open new wf log org "
  (interactive)
  ;(helm-find-files "~/src/play/WillForan.github.io/reports")
  (let* ((root "~/src/play/WillForan.github.io/reports")
         (titles (directory-files root))
         (pick (ivy-completing-read "title: " titles))
         (fname (expand-file-name pick root)))
    (when pick
      (find-file fname)
      (if (not (file-exists-p pick))
        (insert (concat
                 "#+TITLE: " (file-name-base pick)  "\n"
           "#+DATE: "  (format-time-string "%Y-%m-%d") "\n"
           "#+OPTIONS: _:{} ^:{} toc:nil num:nil\n"
           "#+DRAFT: true"))))))
