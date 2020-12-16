;; variables for note taking
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

;; 2018-09-28: zotero integration with orgmode; 20201118 - unused?
;  (use-package zotxt :ensure t) ; M-x org-zotxt-mode
(use-package reftex :defer t :custom (reftex-default-bibliography '(my/zotbib)))
(use-package org-ref :ensure t :defer t
 :custom
  (org-ref-default-bibliography my/zotbib)
  ;; thought this would help open snapshot html pages. it doesn't
  (org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex)
  ;; stick with helm for now
  ;(org-ref-completion-library 'org-ref-ivy-cite)
)

(use-package org-noter :ensure t :defer t 
    :config
    (setq org-noter-auto-save-last-location t)
    ;(setq org-noter-notes-search-path '("~/notes/org-files/lit/"))
    (setq org-noter-notes-search-path (list my/litdir)))

(use-package org-noter-pdftools :ensure t :defer t)

(use-package pdf-tools :ensure t :defer t
  :pin manual ;; need to redo pdf-tools-install compile after upgrade
  :config
    (pdf-tools-install)
    (setq pdf-annot-activate-created-annotates t) )

;; after text is selected
;;  C-c C-c => annotate
;;  C-c C-a h => highlight
;;  C-c C-a t => text
;;  C-c C-a D => delete


;; read epub
(use-package nov :ensure t :defer t 
  :init 
    (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  :config
    (setq nov-text-width 80)
)

;; RSVP reading a la spritz
(defun my/no-cursor  () "hide text cursor" (lambda () (internal-show-cursor nil nil)))
(defun my/yes-cursor () "show text cursor" (lambda () (internal-show-cursor nil t)))
(use-package spray :ensure t :defer t
 :config
  (advice-add 'spray-mode :after 'my/no-cursor)
  (advice-add 'spray-quit :after 'my/yes-cursor)
 :bind (:map spray-mode-map ("C-c c" . my/toggle-cursor))
)

;; 20201110 - like neuron but for org mode
(use-package org-roam
      :ensure t
      :config
	(require 'org-roam-protocol) 
	(add-hook 'org-roam-mode-hook 'flyspell-mode)
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-completion-system 'helm)
      (org-roam-directory my/notesdir)
      (org-roam-completion-everywhere t) ; previously org-roam-company
      (org-roam-capture-immediate-template
          '("d" "default" plain #'org-roam-capture--get-point "%?"
	    :file-name "${slug}-%<%Y%m%d%H%M%S>"
	    :head "#+title: ${title}\n#+created: %T\n"
	    :unnarrowed t))
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n t" . org-roam-tag-add)
               ("C-c n d" . org-roam-db-build-cache)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate)))

              (("C-c n j" . org-journal-new-entry))
              (("C-c n r" . orb-insert))
              (("C-c n R" . helm-bibtex)))

(use-package deft :ensure t
  :after org-roam
  :bind
  ("C-c n d" . deft)
  :custom
  (evil-set-initial-state 'deft-mode 'emacs)
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory my/notesdir))

(use-package org-journal :ensure t
 :custom
 (org-journal-file-type 'weekly)
 (org-journal-dir my/jrnldir)
 (add-to-list 'org-agenda-files (expand-file-name org-journal-dir))
 (org-journal-file-format "%G-%W.org")
)
;; 20201114S 
;; https://github.com/tmalsburg/helm-bibtex
(use-package helm-bibtex :ensure t
  :custom
  (bibtex-completion-bibliography my/zotbib)
  (bibtex-completion-pdf-field "file")
  (bibtex-completion-notes-path my/litdir)
  ;; from https://www.ianjones.us/org-roam-bibtex
  (bibtex-completion-notes-template-multiple-files (concat
    "#+TITLE: ${title}\n"
    "#+ROAM_KEY: cite:${=key=}\n"
    "* TODO Notes\n"
    ":PROPERTIES:\n"
    ":Custom_ID: ${=key=}\n"
    ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
    ":AUTHOR: ${author-abbrev}\n"
    ":JOURNAL: ${journaltitle}\n"
    ":DATE: ${date}\n"
    ":YEAR: ${year}\n"
    ":DOI: ${doi}\n"
    ":URL: ${url}\n"
    ":END:\n\n"
  ))
  ;; https://emacs.stackexchange.com/questions/57558/helm-bibtex-and-zotero-with-better-bibtex-cannot-find-pdf
  ; (setq org-ref-get-pdf-filename-function '#org-ref-get-pdf-filename-helm-bibtex)
)

(use-package org-roam-bibtex :ensure t :defer t
 :after org-roam
 :hook (org-roam-mode . org-roam-bibtex-mode)
 :custom
 (orb-insert-frontend 'helm-bibtex)
 :config
  (setq orb-preformat-keywords
   '("=key=" "title" "url" "file" "author-or-editor" "keywords"))
  (setq orb-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           ""
	   :unnarrowed t
           :file-name "lit/${=key=}"
           :head
"#+TITLE: ${=key=}: ${title}
#+ROAM_KEY: ${ref}
* ${title}
  :PROPERTIES:\n  :Custom_ID: ${=key=}
  :URL: ${url}\n  :AUTHOR: ${author-or-editor}
  :NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")
  :NOTER_PAGE: \n  :END:\n\n"))))

;;(setq org-protocol-default-template-key nil)

; 20201122 start adding def :drill: with show1cloze
;  still want to select tags and refine more
;  see my/drill
(defun my/drill-roam-cmd (drill-cmd)
  "run DRILL-CMD on recusive list of org roam files.
  recursive search in my/notesdir: all .org that dont start with a dot"
  (let
    ((org-drill-scope
      (directory-files-recursively my/notesdir "^[^.].*.org$")))
    (funcall drill-cmd)))
(defun my/drill-roam ()
   "use all org-roam files in drill.
   recursive search in my/notesdir: all .org that dont start with a dot"
   (interactive)
   (my/drill-roam-cmd #'org-drill)) ;(if (equal current-prefix-arg nil) '#org-drill '#org-drill-again))
   ;(my/drill-roam-cmd (if (current-prefix-arg) '#org-drill '#org-drill-again)))

(use-package org-drill :ensure t
  :config (setq org-drill-scope 'directory))

(use-package synosaurus :ensure t
  :bind
  ("C-c C-s r" . synosaurus-choose-and-replace)
  :config
  (setq 
   synosaurus-choose-method 'ido
   synosaurus-backend 'synosaurus-backend-wordnet
))
