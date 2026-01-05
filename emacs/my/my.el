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

;; 20241222
(defun my/tildeblog ()
  "Use TRAMP to edit tilde blog."
  (interactive)
  (find-file "/ssh:tilde:public_html/index.html"))

(defun my/tildeblog-new ()
  "New entry in tilde blog. Also see `entry' yas snippet."
  (interactive)
  (if-let* ((title (ivy-completing-read "title:" '()))
            (name (replace-regexp-in-string " " "-" title))
            (today (format-time-string "%Y%m%d")))
      (progn (insert "<!-- ----------------- -->\n")
             (insert (format "<hr><a href=#%s name=%s><h2>%s: %s</h2></a>\n<p></p>\n"
                             name name today title))
             (backward-char 6))))


;; 20231210 - quick blog
(defun my/weblog ()
  "Open new wf log org file."
  (interactive)
                                        ;(helm-find-files "~/src/play/WillForan.github.io/reports")
  (let* ((root "~/src/play/WillForan.github.io/reports")
         (titles (directory-files root))
         (pick (ivy-completing-read "title: " titles))
         ;; clean up name: add .org if not already there, repalce spaces
         (pick (replace-regexp-in-string ".org$\\|$" ".org" pick))
         (pick (replace-regexp-in-string " " "-" pick))
         (fname (expand-file-name pick root)))
    (when pick
      (find-file fname)
      (if (not (file-exists-p pick))
          (insert (concat
                   "#+TITLE: " (file-name-base pick)  "\n"
                   "#+DATE: "  (format-time-string "%Y-%m-%d") "\n"
                   "#+OPTIONS: _:{} ^:{} toc:nil num:nil\n"
                   "#+DRAFT: true"))))))

;; 20240715
(defun my/ring-to-buff ()
  "Send last executed command to the other window.
Useufl for interactively building a script"
  (interactive)
  (require 'ring)
  (require 'switch-window)
  (let* ((val (ring-ref comint-input-ring 0))
         (other-buff (save-window-excursion (other-window 1) (current-buffer)))
         (new-pnt (with-current-buffer other-buff
                    (end-of-line)
                    (insert "\n")
                    (insert val)
                    (end-of-line)
                    (point))))
    (set-window-point other-buff (new-pnt))))

(define-key comint-mode-map (kbd "C-c :") #'my/ring-to-buff)
;; (define-key inferior-python-mode-map (kbd "C-c :") 'my/ring-to-buff)

(defun my/recent-uptime-p ()
  "Did we start up in the last 5 minutes?"
  (let ((upthres 300)); seconds
  (> upthres (string-to-number (shell-command-to-string "uptime -r|cut -f2 -d' '"))) ))

(defun my/crc-email ()
  "Build template email to welcom new NPAC members to the CRC.
Uses CRC email as input."
  (interactive)
  (goto-char 0)
  (let ((id (->>
             (save-excursion (search-forward-regexp "Created account.*?id [^ <]*") (match-string 0))
             (s-replace-regexp ".* " "" )
             (substring-no-properties))))
    (search-forward "To:") (kill-line)
    (insert (concat  " " id "@pitt.edu\n"))
    (search-forward "Subject:") (kill-line)
    (insert (concat  " [crc account!] " id "@h2p.crc.pitt.edu"))
    (search-forward "--text follows this line--\n")
    (insert (concat "\nWelcome to the 'npac' CRC group!\nYou'll likely need Global Connect to VPN to the same network as the CRC cluster.\n"
                    "See more on connecting at https://crc.pitt.edu/getting-started/accessing-cluster\n\n"
                    "Afterward, connect like:\n   ssh " id "@h2p.crc.pitt.edu\n"
                    "\nTry some neuroimaging with the module system:\n   module load afni\n   3dinfo -help\n\n"
                    "The semi-automatic VPN connecting script might also be useful:\n"
		    "https://github.com/WillForan/dotconf/blob/master/bin/openconnect-pitt\n\n"
                    ))))

;; 20250504 - load init when emacs is launched after a fresh reboot
(when (my/recent-uptime-p) (my/loadinit))

;; 20250425 - distinquish between buffers
(set-face-attribute 'window-divider nil :foreground "orange")
(window-divider-mode t)
;; 20250304 - auto install/use *-ts-mode
;; pacman -Ss tree-sitter-grammars # group includes tree-sitter-bash
;; 20250316 - when enabled caues
;; redisplay--pre-redisplay-functions: (void-function treesit-parser-changed-ranges)
;; (use-package treesit-auto
;;   :config
;;   (global-treesit-auto-mode))

(use-package howm :defer t :ensure t
  :init
  (setq howm-directory "~/notes/WorkWiki/howm/"))
