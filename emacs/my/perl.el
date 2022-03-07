(defalias 'perl-mode 'cperl-mode)

(use-package reply :defer t
  :quelpa (reply :fetcher github :repo "syohex/emacs-reply")

  :config
  (defun reply-other-window ()
    "Run reply on other window"
    (interactive)
    (switch-to-buffer-other-window
     (get-buffer-create "*reply*"))
    (run-reply "reply"))

  (define-key cperl-mode-map (kbd "C-c C-r") 'reply-send-region)
  (define-key cperl-mode-map (kbd "C-c C-z") 'reply-other-window))
