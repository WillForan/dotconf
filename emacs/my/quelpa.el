;; get packages not in MELPA
;; NB. run with :upgrade t or e.g. C-u M-x quelpa screensend RET
(use-package quelpa :ensure t 
  :init
    (setq quelpa-update-melpa-p nil)
  :config
    (quelpa '(screensend :fetcher github :repo "WillForan/screensend.el" :branch "more-tmux"))
    (quelpa '(zim-wiki-mode :fetcher github :repo "WillForan/zim-wiki-mode"))
)
