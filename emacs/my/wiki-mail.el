
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
  (cl-case major-mode
    ('notmuch-search-mode #'notmuch-search-tag)
    ('notmuch-show-mode #'notmuch-show-tag)
    ('notmuch-tree-mode #'notmuch-tree-tag)))

(defun my/notmuch-wiki-tag ()
  (interactive)
  (when-let ((mode-fun (my/notmuch-mode-tag))
             (wikitag (ido-completing-read "wiki tag:" zim-wiki-completion-canidates)))
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
