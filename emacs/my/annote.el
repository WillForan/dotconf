;; variables for note taking
;; see base.el for my/zotbib my/notesdir my/litdir my/jrnldir

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

(defun my/noter-dir () "open noter dir. open notes"
       (interactive)
       (progn (dired my/litdir) (dired-hide-details-mode)))

(defun my/journal-cite (citekey)
  "add new link for citkey as journal entry
   depends on org-journal and org-roam-bibtex
useful with betterbibtex as the copy export for zotero ctrl+shift+c
   xclip -o|sed 's/\\cite{\\|\\}$//g'|sed 1q|xargs -I{} echo  emacsclient -n -e '(my/journal-cite \"{}\")'
"
  (call-interactively 'org-journal-new-entry)
  (orb-insert-edit-note citekey))
(defun my/cite-key-from-clip ()
  (replace-regexp-in-string ".*cite{\\|}.*" "" (car kill-ring)))

(defun my/journal-cite-from-clip ()
  (interactive)
  (let* ((clip (car kill-ring))
        (citekey (replace-regexp-in-string ".*cite{\\|}.*" "" clip)))
    (my/journal-cite citekey)))

(defun wf/bibtex-url (key)
  "get url from KEY, extracted from bibtex-completion.el"
  (bibtex-completion-get-value "url" (bibtex-completion-get-entry key)))


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
;; [, ] - jump chapters; l,r back and forward in history
(use-package nov :ensure t :defer t 
  :init 
    (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  :config
    (setq nov-text-width 80))


;; 20201114S 
;; https://github.com/tmalsburg/helm-bibtex
(use-package helm-bibtex :ensure t :defer t
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

;; RSVP reading a la spritz
(defun my/no-cursor  () "hide text cursor" (lambda () (internal-show-cursor nil nil)))
(defun my/yes-cursor () "show text cursor" (lambda () (internal-show-cursor nil t)))
(use-package spray :ensure t :defer t
 :config
  (advice-add 'spray-mode :after 'my/no-cursor)
  (advice-add 'spray-quit :after 'my/yes-cursor)
 :bind (:map spray-mode-map ("C-c c" . my/toggle-cursor))
)

; https://emacs.stackexchange.com/questions/42281/org-mode-is-it-possible-to-display-online-images
(require 'quelpa-use-package)
(use-package org-yt :ensure t :defer t
 :quelpa (org-yt :fetcher github :repo  "TobiasZawada/org-yt")
 :after org
 :config
(defun org-image-link (protocol link _description)
  "Interpret LINK as base64-encoded image data."
  (cl-assert (string-match "\\`img" protocol) nil
             "Expected protocol type starting with img")
  (let ((buf (url-retrieve-synchronously (concat (substring protocol 3) ":" link))))
    (cl-assert buf nil
               "Download of image \"%s\" failed." link)
    (with-current-buffer buf
      (goto-char (point-min))
      (re-search-forward "\r?\n\r?\n")
      (buffer-substring-no-properties (point) (point-max)))))

(org-link-set-parameters
 "imghttp"
 :image-data-fun #'org-image-link)

(org-link-set-parameters
 "imghttps"
 :image-data-fun #'org-image-link)
)


;; calibre
(use-package calibredb :ensure t :defer t
  :init
    (autoload 'calibredb "calibredb")
  :config
    (setq calibredb-root-dir "/mnt/storage/dl/books/calibre/")
    (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
    (setq calibredb-library-alist '((calibredb-root-dir))))

;; 20251123 - colored highlights and bookmarks
;; ' b - bookamrk
;; ' g - access; ' l - back; ' d - delete; ' r - rename
(use-package nov-highlights
  :quelpa (nov-highlights :fetcher github :repo  "emacselements/nov-highlights")
  :init
  (with-eval-after-load 'nov (nov-highlights-global-mode-enable))
  :config
  (setq nov-highlights-bookmarks-storage-directory "~/passwd/nov-bookmarks/")
  (setq nov-highlights-annotation-mode 'org-mode)
  ;; (setq sentence-end "\\([.!?,;:""''][]\"')}]*\\|[:][[:space:]]\\)[[:space:]]*")
  ;; TODO: advise nov-goto-document to save bookmark?
  )
