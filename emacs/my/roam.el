;; see base.el for my/zotbib my/notesdir my/litdir my/jrnldir

;; thesaurus only comes up in prose. most prose is journal/roam related
;; so this goes here
(use-package synosaurus :ensure t
  :bind
  ("C-c d t" . synosaurus-choose-and-replace)
  ("C-c d T" . synosaurus-lookup)
  :config
  (setq 
   synosaurus-choose-method 'ido
   synosaurus-backend 'synosaurus-backend-wordnet))
; maybe try define-word
(use-package wordnut :ensure t
  :bind ("C-c d D" . wordnut-lookup-current-word))
(use-package define-word :ensure t
  :bind ("C-c d d" . define-word-at-point))

(defun my/make-relative-to-buffer (path)
  "PATH relative to the current buffer"
  (if (buffer-file-name)
      (file-relative-name path
			 (file-name-directory (buffer-file-name)))
    path))


(defun my/todays-page ()
  "get the journal file for today"
  (org-journal--get-entry-path (encode-time (decode-time))))

(defun my/goto-today ()
  "open todays journal page"
  (interactive)
  (find-file (my/todays-page)))

(defun my/link-date ()
  "link current in org-agenda date format to org-journal page"
  (interactive)
  (let* (
      (now (decode-time))
      (todays-journal (my/todays-page))
      (desc (org-timestamp-translate (org-timestamp-from-time nil)))
      (linkto (my/make-relative-to-buffer todays-journal))
      (link (org-link-make-string  linkto desc)))
   (insert link)))


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
               ("C-c n d" . my/link-date)
               ("C-c n n" . my/goto-today)
               ("C-c n u" . org-roam-db-build-cache)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate)))
              ;(("C-c n j" . org-journal-new-entry)) ; done in org-journal
              (("C-c n r" . orb-insert))
              (("C-c n R" . helm-bibtex)))

(use-package deft :ensure t
  :bind
  ("C-c n D" . deft)
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
 :bind
 (("C-c n d" . #'my/link-date)
  ("C-c n n" . #'my/goto-today)
  ("C-c n j" . #'org-journal-new-entry)))

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

(use-package org-drill :ensure t
  :config
  (setq org-drill-scope 'directory)
  ; 20210124 - hints in the heading
  (setq org-drill-hide-item-headings-p t))

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
