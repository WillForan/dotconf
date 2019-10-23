(use-package org :defer t
  :config
  ; don't ask about evaluting code: 2017-06-26
  (setq org-confirm-babel-evaluate nil)
  ; loaded languages
  (use-package ob-ipython :ensure t)
  (use-package ob-async :ensure t) ; use :async in src_block header
  (use-package org-bullets
    :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  (org-babel-do-load-languages 'org-babel-load-languages
      '(
	(R . t)      ; rm ob-R.elc if "Invalid function: org-babel-header-args-safe-fn"
	(python . t)
	(ipython . t)
	(octave . t)
	(perl . t)
	(ruby . t)
	(sql . t)
	(sqlite . t)
	(shell . t) ; req newer org mode
	(J . t)
	;(sh . t) ; old - removed from org mode
	;(bash . t) ; doesn't exist
      )))
