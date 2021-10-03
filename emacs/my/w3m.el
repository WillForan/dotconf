(use-package w3m
  :config
    (setq w3m-confirm-leaving-secure-page nil)
    ; 20210218 - doesn't work. toggle in config
    ; 20210930 - dont nconc -- adds too many times
    (setq w3m-command-arguments
          '("-o" "display_link_number=0"))
    (require 'key-chord)
    ;; toggles, one diriection: #'evil-exit-emacs-state
    (key-chord-define w3m-mode-map "jk" #'evil-emacs-state)
    (key-chord-define w3m-mode-map " x" #'counsel-M-x)
    (key-chord-define w3m-mode-map " b" #'ivy-switch-buffer)
    (key-chord-define w3m-mode-map " o" "\C-xo")
    (key-chord-define w3m-mode-map " c" "\C-c")

    ;; (w3m-lnum-mode 1)
    ;; (setq w3m-command-arguments
    ;; 	  (nconc w3m-command-arguments
    ;; 		 '("-o" "display_link_number=0")))
 :bind
   (:map w3m-mode-map
	 ;; L masks w3m-lnum-mode. but like ace hints better (chars instead of nums)
	 (("L" . link-hint-open-link))
	 (("/" . swiper))
	 (("<mouse-8>" . w3m-view-previous-page))
	 (("<mouse-9>" . w3m-view-next-page))))
