;; how emacs saves it's backups
;;https://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
;;https://emacs.stackexchange.com/questions/17210/how-to-place-all-auto-save-files-in-a-directory
(setq 
  ;; blah~ backup files:
  ;;   save all files matching "." (all) to backups directory
  backup-directory-alist `(("." . "~/.emacs.d/backups"))
  backup-by-copying-when-linked t
  delete-old-versions t
  kept-new-versions 2
  kept-old-versions 0
  version-control t
  vc-make-backup-files t
  ;; autosave #blah# files
  auto-save-file-name-transforms `((".*" "~/.emacs.d/saves/" t)))

