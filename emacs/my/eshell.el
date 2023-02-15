; https://github.com/condy0919/emacs-newbie/blob/master/introduction-to-builtin-modes.md

(use-package esh-mode :ensure nil
  :bind (:map eshell-mode-map
         ;("C-d" . eshell-delchar-or-maybe-eof)
         ("M-." . eshell-yank-last-arg))
  :config
  (defun eshell-yank-last-arg ()
    "Insert the last arg of the previous command."
    (interactive)
    (insert "$_")
    (pcomplete-expand)))


;; 20230211 eshell/z -> just z in eshell
(defun fasd-shell-dir ()
  "Capture output of fasd as list of directories."
  ;; (require 'dash)  (-filter #'file-directory-p
  (delete "" (split-string (shell-command-to-string "fasd -dl") "\n")))

(defun eshell/z (&optional regexp)
  "Navigate to a previously visited directory in eshell via `consult-dir'.
With REGEXP, go to first match.
From https://karthinks.com/software/jumping-directories-in-eshell/, extended with fasd."
  (let ((eshell-dirs (delete-dups
                      (mapcar 'abbreviate-file-name
                              (append (ring-elements eshell-last-dir-ring) (fasd-shell-dir))))))
    (cond
     ((and (not regexp) (featurep 'consult-dir))
      (let* ((consult-dir--source-eshell `(:name "Eshell"
                                                 :narrow ?e
                                                 :category file
                                                 :face consult-file
                                                 :items ,eshell-dirs))
             (consult-dir-sources (cons consult-dir--source-eshell
                                        consult-dir-sources)))
        (eshell/cd (substring-no-properties
                    (consult-dir--pick "Switch directory: ")))))
     (t (eshell/cd (if regexp (eshell-find-previous-directory regexp)
                     (completing-read "cd: " eshell-dirs)))))))
