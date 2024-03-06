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


;; 20230506 perl navigator. also see PLS
(defvar perl-navigator-path (expand-file-name "~/src/utils/PerlNavigator"))
(when (file-exists-p perl-navigator-path)
  (setq-default eglot-workspace-configuration
                '((:perlnavigator . (:perlPath
                                     "/usr/bin/perl"
                                     :enableWarnings t))))

  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 `((cperl-mode perl-mode) . (perl-navigator-path, "--stdio"))))

  (global-company-mode)

  (add-hook 'cperl-mode-hook 'eglot-ensure)
  (add-hook 'perl-mode-hook 'eglot-ensure))
