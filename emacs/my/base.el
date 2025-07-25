;;;; base emacs config. assume my.el already loaded

;; path locations
;; ~/notes/org-files tracked in syncthing
(defvar my/zotbib
  '("~/notes/org-files/ZoteroLibrary.bib" "~/notes/org-files/year_of_space_20-21.bib")
  "zotero bibtex output file, set in zotero preferences")
(defvar my/notesdir
  "~/notes/org-files/"
  "where org-roam org files are")
(defvar my/litdir
  (concat my/notesdir "lit/")
  "location of org-noter org files")
(defvar my/jrnldir
  (concat my/notesdir "weekly/")
  "location of journal org files (org-journal)")

;; (setq org-agenda-files nil)
(if (boundp 'org-agenda-files)
    (add-to-list 'org-agenda-files my/notesdir)
    (setq org-agenda-files (list my/notesdir)))

;; shift-insert like terminal: x11 primary clipboard
(global-set-key (kbd "S-<Insert>") 'my/get-primary)
;; selection to xclipboard (20191202)
(setq x-select-enable-primary t)

;; store recent files
(recentf-mode 1)

;; 20230131 - line numer helps distinquish buffers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
(defun my/no-lines () "Disable linen numbers." (display-line-numbers-mode 0))
(dolist (mode '(term-mode-hook
                shell-mode-hook
                w3m-mode-hook
                treemacs-mode-hook
                eshell-mode-hook
                inferior-ess-mode-hook
                inferior-python-mode-hook
                summary-mode-hook
                notmuch-show-mode
                notmuch-seach-mode
                notmuch-tree-mode
                deft-mode
                erc-mode-hook))
  (add-hook mode #'my/no-lines))

;; learning new keyboard. find pairs helpful
;; (electric-pair-mode 0)
;; 20220329 - smartparens has better handing of pair ends
;;   prefix command with 'o' in visual mode to ignore parens "escape hatch"
;;   use eg S( to surround seleciton with parens -- evil-surround
;; with lispy-mode use ] (sp-forward-sexp) to go to end and ]d for beginning
;; https://ebzzry.com/en/emacs-pairs/
;;   also see M-S-up/down
(use-package evil-smartparens :ensure t
  :config
  (smartparens-global-mode 1)
  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)
  :bind
  ("C-M-t" . sp-transpose-sexp)         ; overwrite transpose words
  ("C-{"   . sp-forward-slurp-sexp)
  ("C-}"   . sp-forward-barf-sexp))


;; Termux has hunspell
(when (equal nil (executable-find "ispell"))
  (setq ispell-program-name (executable-find "hunspell")))

;; disable message for every word. improve performance? 20191227
;; https://www.emacswiki.org/emacs/FlySpell
(setq flyspell-issue-message-flag nil)
; (setq flyspell-auto-correct-binding (kbd "<S-f12>")))
; see C-;
(add-hook #'mu4e-compose-mode-hook #'flyspell-mode-on)
(add-hook #'message-mode-hook #'flyspell-mode-on)
(add-hook #'notmuch-message-mode-hook #'flyspell-mode-on)
(add-hook #'markdown-mode-hook #'flyspell-mode-on)
(add-hook #'git-commit-setup-hook #'git-commit-turn-on-flyspell)

; (global-linum-mode 1)

; 20191116 - mode line at top instead of bottom
;(setq-default header-line-format mode-line-format)

;; write over highlighted selection (20171107)
(delete-selection-mode 1)

;; dont ask about symlinks in version control (git)
(setq vc-follow-symlinks nil)



;; persistant history (20171107)
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

;; --- undo/redo window configurations ---
;; C-c {left,right}: undo redo
(winner-mode 1)
;; 20180625 -- S- arrow to move around
(windmove-default-keybindings)

;; dont do the crazy comment indent (20200224)
(electric-indent-mode 0)

(setq inhibit-startup-screen t)

;; use comint file completion to approximate vim's C-x C-f
;; TODO: why does comany-files need a leading path (e.g. ./)
; M-\    gives a minibuffer list 
; M-SPC completes and cycles through
(global-set-key "\M-\\" 'comint-dynamic-complete-filename)
(global-set-key "\M- " 'hippie-expand) ; overwrites 'just-one-space'


; 20210504 - intially for R, but also lisps
; 20220403 - turn off. causes rendering issues in term over ssh?
; (global-prettify-symbols-mode +1)


; 20210330 - greenclip X11 clipboard, maybe should get it's own file?
(use-package cliphist :ensure t
  :bind
  ("C-c p" . cliphist-paste-item)
  :config
  (setq cliphist-linux-clipboard-managers '("greenclip" "clipit" "parcellite")))

;; 20210508 default to turning key helping on
(use-package which-key :ensure t :config (which-key-mode 1))

; 20210331 recompile elc if newer code
(setq load-prefer-newer t) 

;; 20211024 - disable. can be very annoying
;; (use-package auto-compile :ensure t
;;  :config
;;     (auto-compile-on-load-mode)
;;     (auto-compile-on-save-mode))

;(use-package mood-line :ensure t :config (mood-line-mode))
;(use-package smart-mode-line :ensure t :config (sml/setup))

;; 20210428 tramp passwords stored
;; (impl. for ginger where .ssh perms prevent key exchange)
;; https://stackoverflow.com/questions/840279/passwords-in-emacs-tramp-mode-editing
;; wont work for proxyjump (ssh:reese|ssh:ginger:/file): doesn't store ginger
;; defaults to ~/.authinfo (not encrypted)
(use-package password-cache :ensure t
  :config
  (setq password-cache-expiry nil))

;; news usenet
(setq gnus-select-method '(nntp "news.eternal-september.org"))
