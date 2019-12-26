;; local journaling wiki
(defun my/work-wiki ()
  "switch to work wiki settings"
  (interactive)
  (setq zim-wiki-root "~/notes/WorkWiki")
  (setq zim-wiki-journal-datestr "Calendar/%Y/Week_%02V.txt"))

(defun my/home-wiki ()
  "switch to work wiki settings"
  (interactive)
  (setq zim-wiki-root "~/notes/PersonalWiki")
  (setq zim-wiki-journal-datestr "Calendar/%Y/%02m.txt"))

(defun my/zim-day-header ()
  "insert header for today. kuldge: should be done by template"
  (interactive)
  (let ((header-level "===")
	(date (format-time-string "%A %B %02d")))
   (insert (string-join (list header-level date header-level) " "))))


(use-package zim-wiki-mode :defer t
  ; :load-path "~/src/utils/zim-wiki-mode" ;; 20191019 - use quelpa
  :bind ("C-c C-n" . zim-wiki-goto-now)
  :init
    (add-hook 'zim-wiki-mode-hook #'flyspell-mode)
    (add-hook 'zim-wiki-mode-hook #'(lambda () (git-gutter-mode 0)))
  :config
    (evil-leader/set-key-for-mode 'zim-wiki-mode "z" 'zim-wiki-hydra/body)
    (my/home-wiki))
