;; local journaling wiki
(defun my/wiki-goto-now ()
  "now page for locally set notebook"
  (interactive)
  (require 'zim-wiki-mode)
  (zim-wiki-goto-now (expand-file-name zim-wiki-my-root))
  ;; 20200605 - in my/home-wiki
  ;; 20220402 - moved here (wiki-goto-wiki)
  (if (= (buffer-size) 0) (zim-wiki-insert-header)))
(defun my/work-wiki ()
  "switch to work wiki settings"
  (interactive)
  (setq zim-wiki-my-root "~/notes/WorkWiki")
  (setq zim-wiki-journal-datestr "Calendar/%G/Week_%02V.txt")
  (my/wiki-goto-now))

(defun my/home-wiki ()
  "switch to work wiki settings"
  (interactive)
  (setq zim-wiki-my-root "~/notes/PersonalWiki")
  (setq zim-wiki-journal-datestr "Calendar/%Y/%02m.txt")
  (my/wiki-goto-now))


(defun my/zim-day-header ()
  "insert header for today. kuldge: should be done by template"
  (interactive)
  (let ((header-level "===")
	(date (format-time-string "%A %B %02d")))
   (insert (string-join (list header-level date header-level) " "))))

(defun my/zim-ws-plum ()
  "find and run lines like ws::term:rhea:/Volumes/Hera/Projects/7TBrainMech/scripts/mri/MRSI_roi"
  (interactive)
       (save-excursion (beginning-of-buffer) (search-forward-regexp "^ws::") (beginning-of-line) (kill-new (buffer-substring-no-properties (point) (progn (end-of-line) (point)))) (call-process-shell-command "plum &")))


; 20200625 - broke?!
;(use-package outline-mode :ensure t)

(use-package outline-magic :ensure t
  :after outline-mode
  :config
    (define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle))

(use-package dokuwiki-mode
  :quelpa ((dokuwiki-mode :fetcher github :repo "WillForan/emacs-dokuwiki-mode") :upgrade nil)
  :ensure t
  :config
   (require 'outline-magic)
   (flyspell-mode 1))

(use-package zim-wiki-mode  :defer f
  :load-path "~/src/utils/zim-wiki-mode" ;; 20191019 - use quelpa, reversted 2021102x
  :bind
  ("C-c z" . my/wiki-goto-now) 		;; same as hydra command. but when not in zim, go there
  ("C-c n w" . my/work-wiki)
  (:map zim-wiki-mode-map
          ("M-p" . #'outline-previous-visible-heading)
          ("M-n". #'outline-next-visible-heading)
          ("M-S-<return>" . #'org-insert-item))
  ;; c-c c-n used for org-roam/journal too. so dont overwrite by defult
  ; :bind ("C-c C-n" . my/wiki-goto-now)
  ;; maybe useful to have
  ; :after outline-magic
  :init
    (add-hook 'zim-wiki-mode-hook #'flyspell-mode)
    (add-hook 'zim-wiki-mode-hook #'(lambda () (git-gutter-mode 0)))
    (add-hook 'zim-wiki-mode-hook #'auto-save-visited-mode)
  :config
    ;(key-chord-define evil-insert-state-map  "zz" 'zim-wiki-hydra/body))
    (evil-leader/set-key-for-mode 'zim-wiki-mode "z" 'zim-wiki-hydra/body)
    ;(my/home-wiki)


    ;; (local-set-key (kbd "M-RET") #'dokuwiki-insert-next-header)
    ;; (local-set-key (kbd "<backtab>") #'outline-cycle)
    ;; (local-set-key (kbd "M-<iso-lefttab>") #'(lambda () (interactive) (outline-cycle '(4))))
    )


(defun ws-notebook ()
  "Run ws:: lines in zim wiki text file and jump to dedictated i3 workspace.
For running a single ws:: line, see `my/zim-ws-plum'."
  (interactive)
  ;; forks do not run in (start-process) or (async-shell-command)
  ;; shell-command waits for forked children to end too
  (call-process "/home/foranw/src/utils/wf-utils/i3/zim-i3-go.bash"
                nil 0 nil           ; no output, no wait, no redisplay
                ""                  ; gen workspace name from filename
                (buffer-file-name)))
