;; local journaling wiki
(defun my/wiki-goto-now ()
   "now page for locally set notebook"
   (interactive)
   (zim-wiki-goto-now (expand-file-name zim-wiki-my-root)))
(defun my/work-wiki ()
  "switch to work wiki settings"
  (interactive)
  (setq zim-wiki-my-root "~/notes/WorkWiki")
  (setq zim-wiki-journal-datestr "Calendar/%G/Week_%02V.txt")
  (my/wiki-goto-now))

(defun my/home-wiki ()
  "switch to work wiki settings"
  (interactive)
  (setq zim-wiki-my-root "~/notes/PersonalWiki")
  (setq zim-wiki-journal-datestr "Calendar/%Y/%02m.txt")
  (my/wiki-goto-now)
  ;; 20200605
  (if (= (buffer-size) 0) (zim-wiki-insert-header)))


(defun my/zim-day-header ()
  "insert header for today. kuldge: should be done by template"
  (interactive)
  (let ((header-level "===")
	(date (format-time-string "%A %B %02d")))
   (insert (string-join (list header-level date header-level) " "))))



; 20200625 - broke?!
;(use-package outline-mode :ensure t)

(use-package outline-magic :ensure t
  :after outline-mode
  :config
    (define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle))

(use-package zim-wiki-mode
  ;; ; :load-path "~/src/utils/zim-wiki-mode"
  ;; 20191019 - use quelpa
  :bind
  ("C-c z" . my/wiki-goto-now) 		;; same as hydra command. but when not in zim, go there
  ;; :after outline-magic
  :init
    (add-hook 'zim-wiki-mode-hook #'flyspell-mode)
    (add-hook 'zim-wiki-mode-hook #'(lambda () (git-gutter-mode 0)))
    (add-hook 'zim-wiki-mode-hook #'auto-save-visited-mode)
  :config
    ;(key-chord-define evil-insert-state-map  "zz" 'zim-wiki-hydra/body))
    (evil-leader/set-key-for-mode 'zim-wiki-mode "z" 'zim-wiki-hydra/body)
    ;(my/home-wiki)
)
