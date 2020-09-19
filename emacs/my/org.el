(use-package org :defer t
  :config
  (use-package ob-ipython :ensure t)
  (use-package ob-async :ensure t) ; use :async in src_block header
  (use-package org-bullets
    :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  ; don't ask about evaluting code: 2017-06-26
  (setq org-confirm-babel-evaluate nil)
  ; loaded languages
  (use-package jupyter :ensure t
   :config (setenv "EDITOR" "emacsclient")
    ;; shell:
    ;;   i jupyter perl-cpanplus-dist-arch perl-moose
    ;;   cpanp install Devel::IPerl
   ) 
  (setq org-babel-python-command "python3")
  (org-babel-do-load-languages 'org-babel-load-languages
      '(
	(R . t)      ; rm ob-R.elc if "Invalid function: org-babel-header-args-safe-fn"
	(python . t)
	;(ipython . t) ; (wrong-type-argument stringp sh)
	(octave . t)
	(perl . t)
	(ruby . t)
	(sql . t)
	(sqlite . t)
	(shell . t) ; req newer org mode
	(J . t)
        (jupyter . t)
	;(sh . t) ; old - removed from org mode
	;(bash . t) ; doesn't exist
        ))

  ;; must be afer org load-language -- function doesn't exist?
  ;(org-babel-jupyter-override-src-block "python")
  ;(org-babel-jupyter-override-src-block "perl")
  ;(org-babel-jupyter-override-src-block "julia")
  ;; revert with (org-babel-jupyter-restore-src-block "...")
  

  ;; keep ids ordered for better version control of minor changes
  ;; 20200609 - https://www.reddit.com/r/orgmode/comments/aagmfh/export_to_html_with_useful_nonrandom_ids_and
  (defun org-export-deterministic-reference (references)
   	(let ((new 0))
   	     (while (rassq new references) (setq new (+ new 1))) 
   	     new))
  (advice-add #'org-export-new-reference :override #'org-export-deterministic-reference)
)
