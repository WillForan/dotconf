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
