(package-initialize)

;; gui settings
;(menu-bar-mode -1)
(tool-bar-mode -1)
(linum-mode 1)

; repos
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(use-package evil-leader :ensure t
  :init (global-evil-leader-mode)
  :config (evil-leader/set-leader "<SPC>"))

(require 'evil)        ;vim
(require 'company)     ;autocomplete
                       ;theme
;(require 'moe-theme)
;(moe-dark)
(load-theme 'monokai t)
;(load-theme 'tango-dark)
;(load-theme 'leuven)

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'evil-mode)
; 20180622 ciw, *, etc match all non_space-sep words
(with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol))


; faster than scp
(setq tramp-default-method "ssh")
(require 'tramp)

; 20181103 -- frames-only-mode (from work)
; 20191012 - set helm-split-window-default-side to same (in helm)
(use-package frames-only-mode :ensure t
  :config
  (setq frames-only-mode-reopen-frames-from-hidden-x11-virtual-desktops t)   ; does this work?
)


; 20180623 - http://emacsredux.com/
;(setq tab-always-indent ‘complete)

; 20180623 - local packages
(use-package zim-wiki-mode
  :load-path "~/src/emacs-lib/zimwiki-mode"
  :defer t
  :bind ("C-c C-n" . zim-wiki-goto-now)
  :init
    ;(setq zim-root "~/notes/WorkWiki")
    ;(setq zw-journal-datestr "Calendar/%Y/Week_%02U.txt")
    (setq zim-wiki-root "~/notes/PersonalWiki")
    (setq zim-wiki-journal-datestr "Calendar/%Y/%02m.txt")
    (evil-leader/set-key-for-mode 'zim-wiki-mode "z" 'zim-wiki-hydra/body)
)

; 20191012 - send to tmux
; https://github.com/benwbooth/screensend.el
(use-package screensend
  :load-path "~/src/emacs-lib/screensend.el"
  :bind ("C-c C-s" . tmux-send)
)



; 20180623
; helm replace emacs default command, buffer, and file menu 
; swap tab and c-z
(use-package helm
  :config
  (setq helm-split-window-default-side 'same)
  (bind-keys ("M-x" . helm-M-x)
             ;("M-y" . helm-show-kill-ring)
             ("C-x C-f" . helm-find-files)
             ("C-x b" . helm-mini))
  (bind-keys :map helm-map
             ("TAB" . helm-execute-persistent-action)
             ("C-z" . helm-select-action)
	     ))

;; 20180920 - ipython
(setq
 python-shell-interpreter "jupyter"
 python-shell-interpreter-args "console --simple-prompt"
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" "ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "7356632cebc6a11a87bc5fcffaa49bae528026a78637acd03cae57c091afd9b9" "7666b079fc1493b74c1f0c5e6857f3cf0389696f2d9b8791c892c696ab4a9b64" "a866134130e4393c0cad0b4f1a5b0dd580584d9cf921617eee3fd54b6f09ac37" "2a1b4531f353ec68f2afd51b396375ac2547c078d035f51242ba907ad8ca19da" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "baec3b9226614da30a3e5135592a65910527df93a257bba423c542695281bc55" "7e4fe193db857147d1c6839998d9fc08bc58ba52121b9732c248d44471dd3438" "21fb497b14820147b2b214e640b3c5ee19fcadc15bc288e3c16c9c9575d95d66" "b5ecb5523d1a1e119dfed036e7921b4ba00ef95ac408b51d0cd1ca74870aeb14" "5f27195e3f4b85ac50c1e2fac080f0dd6535440891c54fcfa62cdcefedf56b1b" default)))
 '(frames-only-mode t)
 '(helm-mode t)
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100))))
 '(ibuffer-saved-filter-groups nil)
 '(ibuffer-saved-filters
   (quote
    (("text document"
      (and
       (derived-mode . text-mode)
       (not
	(starred-name))))
     ("TeX"
      (or
       (derived-mode . tex-mode)
       (mode . latex-mode)
       (mode . context-mode)
       (mode . ams-tex-mode)
       (mode . bibtex-mode)))
     ("web"
      (or
       (derived-mode . sgml-mode)
       (derived-mode . css-mode)
       (mode . javascript-mode)
       (mode . js2-mode)
       (mode . scss-mode)
       (derived-mode . haml-mode)
       (mode . sass-mode)))
     ("gnus"
      (or
       (mode . message-mode)
       (mode . mail-mode)
       (mode . gnus-group-mode)
       (mode . gnus-summary-mode)
       (mode . gnus-article-mode))))))
 '(inhibit-startup-screen t)
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   (quote
    (alect-themes gruber-darker-theme outline-magic package-lint package-lint-flymake evil-surround evil-leader pretty-hydra hydra link-hint frames-only-mode cider ace-jump-mode zotxt ibuffer-vc htmlize outorg markdown-mode+ helm-navi spacemacs-theme eziam-theme eink-theme doom-themes outshine navi-mode helm-projectile projectile org-bullets moe-theme use-package elpy rainbow-delimiters rainbow-mode helm-ag flycheck dokuwiki-mode deft neotree magit helm-company evil-snipe company monokai-theme ess evil ##)))
 '(pos-tip-background-color "#FFFACE")
 '(pos-tip-foreground-color "#272822")
 '(send-mail-function (quote sendmail-send-it))
 '(weechat-color-list
   (quote
    (unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
