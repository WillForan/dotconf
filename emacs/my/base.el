;;;; base emacs config. assume my.el already laoded

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

(setq inhibit-startup-screen t)
;; no display, toolbar already off (dne)
(when (display-graphic-p) (tool-bar-mode 0))
(menu-bar-mode 0)
;; 20210209 lucid scroll bars are ugly but very functional
;(toggle-scroll-bar 0) 
; 20210209 just disable on minibuffer
(set-window-scroll-bars (minibuffer-window) nil nil)

(setq inhibit-startup-screen t)

;; shift-insert like terminal: x11 primary clipboard
(global-set-key (kbd "S-<Insert>") 'my/get-primary)
;; selection to xclipboard (20191202)
(setq x-select-enable-primary t)

;; store recent files
(recentf-mode 1)

;; Termux has hunspell
(when (equal nil (executable-find "ispell"))
  (setq ispell-program-name (executable-find "hunspell")))

;; disable message for every word. improve pefromance? 20191227 
;; https://www.emacswiki.org/emacs/FlySpell
(setq flyspell-issue-message-flag nil)
; (setq flyspell-auto-correct-binding (kbd "<S-f12>")))
; see C-;

; (global-linum-mode 1)

; 20191116 - mode line at top instead of bottom
;(setq-default header-line-format mode-line-format)

;; write over highlighted selection (20171107)
(delete-selection-mode 1)

;; dont ask about symlinks in version control (git)
(setq vc-follow-symlinks nil)

;; title has filename in it
(setq-default frame-title-format '("%f [emacs %m]"))
(setq-default icon-title-format frame-title-format)

;; Font
;(set-default-font "Source Code Pro 14") ;; 20191022
;; https://superuser.com/questions/721634/different-font-size-when-running-emacs-and-emacsclient
; (setq default-frame-alist '((font . "Iosevka-16"))) ; 20171229/ alist update 20181016 (for emacsclient)
(set-frame-font "DejaVu Sans Mono-14" nil t); 20180810; 20191116 fix

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

;; use python3 in python-mode 20200225
(setq python-shell-interpreter "python3")

;; use comint file completion to approximate vim's C-x C-f
;; TODO: why does comany-files need a leading path (e.g. ./)
; M-\    gives a minibuffer list 
; M-SPC completes and cycles through
(global-set-key "\M-\\" 'comint-dynamic-complete-filename)
(global-set-key "\M- " 'hippie-expand) ; overwrites 'just-one-space'

; 20210330 - greenclip X11 clipboard, maybe should get it's own file?
(use-package cliphist :ensure t
  :bind
  ("C-c p" . cliphist-paste-item)
  :config
  (setq cliphist-linux-clipboard-managers '("greenclip" "clipit" "parcellite")))
