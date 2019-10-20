;; how emacs saves it's backups
;;https://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
(setq 
  ; save all filse matching "." (all) to backups directory
  backup-directory-alist `(("." . "~/.emacs.d/backups"))
  backup-by-copying-when-linked t
  delete-old-versions t
  kept-new-versions 2
  kept-old-versions 0
  version-control t
  vc-make-backup-files t)
