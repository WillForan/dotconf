;; 2018-09-28: zotero integration with orgmode
(use-package zotxt :ensure t) ; M-x org-zotxt-mode
(use-package helm-bibtex :ensure t)
(use-package reftex
  :config
    (setq reftex-default-bibliography '("~/biblio/main.bib")))
(use-package org-ref :ensure t
  :config
   (setq helm-bibtex-bibliography '("~/biblio/main.bib")))
;; bibtext/org-ref
(setq bibtex-completion-library-path '("~/src/papers/"))
