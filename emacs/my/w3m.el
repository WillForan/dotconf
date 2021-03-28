(use-package w3m
  :config
    (setq w3m-confirm-leaving-secure-page nil)
    ; 20210218 - doesn't work. toggle in config
    (setq w3m-command-arguments
           (nconc w3m-command-arguments
                  '("-o" "display_link_number=0")))
 :bind
   (:map w3m-mode-map
	 (("<mouse-8>" . w3m-view-previous-page))
	 (("<mouse-9>" . w3m-view-next-page))))
