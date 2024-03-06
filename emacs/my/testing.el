;; Quick run current test
;; https://github.com/meain/dotfiles/blob/78ce688f2835f0527576ec20a9cb61c44225c267/emacs/.config/emacs/init.el#L1526-L1554
(use-package emacs
  :after compile
  :commands (meain/test-runner meain/test-runner-full)
  :config
  (defun meain/test-runner-full ()
    "Run the full test suite using toffee."
    (interactive)
    (compile (shell-command-to-string (format "toffee --full '%s'"
                                              (buffer-file-name)))))
  (defun meain/test-runner (&optional full-file)
    "Run the nearest test using toffee.  Pass `FULL-FILE' to run all test in file."
    (interactive "P")
    (message "%s"
             (if full-file
                 (format "toffee '%s'" (buffer-file-name))
               (format "toffee '%s' '%s'" (buffer-file-name) (line-number-at-pos))))
    (compile (shell-command-to-string (if full-file
                                          (format "toffee '%s'" (buffer-file-name))
                                        (format "toffee '%s' '%s'"
                                                (buffer-file-name) (line-number-at-pos))))))
  :init
  (evil-leader/set-key "d" 'meain/test-runner)
  (evil-leader/set-key "D" 'meain/test-runner-full))
