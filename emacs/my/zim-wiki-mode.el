;; local journaling wiki
(use-package zim-wiki-mode :defer t
  ; :load-path "~/src/utils/zim-wiki-mode" ;; 20191019 - use quelpa
  :bind ("C-c C-n" . zim-wiki-goto-now)
  :init
    (add-hook 'zim-wiki-mode-hook #'flyspell-mode)
  :config
    (setq zim-wiki-root "~/notes/PersonalWiki")
    (setq zim-wiki-journal-datestr "Calendar/%Y/%02m.txt") ; see: C-h f format-time-string
    (evil-leader/set-key-for-mode 'zim-wiki-mode "z" 'zim-wiki-hydra/body)
)
