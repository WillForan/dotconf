
(defun my/insert-other-notmuch-id ()
  (interactive)
  (insert (save-window-excursion (other-window 1) (notmuch-show-get-message-id))))
(define-key zim-wiki-mode-map (kbd "C-c M") #'my/insert-other-notmuch-id)

(defun my/wiki-search-mail ()
  (interactive)
  ;; TODO if Calendar:Week_ search date
  (notmuch-search (zim-wiki-path2wiki (buffer-file-name))))
(define-key zim-wiki-mode-map (kbd "C-c +") #'my/wiki-search-mail)

(defun my/notmuch-mode-tag ()
  "Determine tag function to use bad on mode."
  (cl-case major-mode
    ('notmuch-search-mode #'notmuch-search-tag)
    ('notmuch-show-mode #'notmuch-show-tag)
    ('notmuch-tree-mode #'notmuch-tree-tag)))

(defun my/get-wiki-tag ()
  "Completing read of wiki pages using completeion-canidates. Ignore calendar pages."
  (when (not zim-wiki-completion-canidates)
    (message "refreshing zim wiki page cache")
    (zim-wiki-refresh-completions))
  (let (;; (completion-ignore-case t)
        (wiki-pages (seq-filter (lambda(x) (not (string-match-p "^:Calendar:" x)))
                                zim-wiki-completion-canidates)))
    ;; was ido-completing-read. but completion-ignore-case would need to be more global?
    (completing-read "wiki tag:" wiki-pages)))

(defun my/notmuch-wiki-tag ()
  "Prompt for a tag derived from wiki pages and add to mail."
  (interactive)
  (when-let ((mode-fun (my/notmuch-mode-tag))
             (wikitag (my/get-wiki-tag)))
    (funcall mode-fun (list (concat "+" wikitag)))))

(define-key notmuch-search-mode-map (kbd "C-c +") #'my/notmuch-wiki-tag)
(define-key notmuch-tree-mode-map (kbd "C-c +") #'my/notmuch-wiki-tag)
(define-key notmuch-show-mode-map (kbd "C-c +") #'my/notmuch-wiki-tag)


;; TODO: tag extraction probably useful on it's own. can do the ^: filter with elisp
(defun my/notmuch-get-first-wiki-tag (id)
  "Get the first zim wiki tag (':' at start) for an `ID'."
  (let ((jq-cmd "jq -r '.[]|.[]|.[]|try(.tags[])|select(test(\"^:\"))'")
        (nm-cmd (concat notmuch-command " show --format json " id)))
    (car (split-string (shell-command-to-string (concat  nm-cmd " | " jq-cmd)) "\n"))))

(defun my/notmuch-to-wiki ()
  "Go to wiki page of first wiki-like tag in message"
  (interactive)
  (let
      ((wikiroot "/home/foranw/notes/WorkWiki/")
       (wikipath (my/notmuch-get-first-wiki-tag (notmuch-show-get-message-id))))
    (if (not (string= wikipath ""))
        (find-file (zim-wiki-wiki2path (concat "+" wikipath) wikiroot)))))


;;; wiki-mail.el ends here
