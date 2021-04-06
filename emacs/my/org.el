;;; https://emacs.stackexchange.com/questions/29304/how-to-show-all-contents-of-current-subtree-and-fold-all-the-other-subtrees
(defun my/org-show-just-me (&rest _)
  "Fold all other trees, then show entire current subtree."
  (interactive)
  (org-overview)
  (org-reveal)
  (org-show-subtree))

(defun my/run-other-window-line () "run lines from other window"
  (interactive)
  (switch-window)
  (beacon-blink)
  (let ((current-line (thing-at-point 'line)))
    (next-line)
    (switch-window)
    (insert (string-trim current-line))
    ;; (comint-send-input) ;; we could send but maybe we want to change something
    ;; or maybe combine mutliple lines
    ))
(defun my/send-other-window-line () "send line from cur to other window"
  (interactive)
  (let ((current-line (thing-at-point 'line)))
    (next-line)
    (switch-window)
    (insert (string-trim current-line))
    (comint-send-input) 
    (switch-window)))

(defun my/org-move-and-show-me ()
  "move forward or backward based on arg"
  (interactive)
  (if current-prefix-arg (org-backward-heading-same-level 1)
    (org-forward-heading-same-level 1))
  (call-interactively (my/org-show-just-me)))

(use-package org :defer t
  :config
  ;;; spelling. finally added 20210209
  (add-hook 'org-mode-hook 'flyspell-mode)
  
  (setq org-use-speed-commands t)
  (add-to-list 'org-speed-commands-user
	 '("m" . my/org-show-just-me))
  (add-to-list 'org-speed-commands-user
	 '("M" . my/org-move-and-show-just-me))


  ; don't ask about evaluting code: 2017-06-26
  (setq org-confirm-babel-evaluate nil)
  ; loaded languages
  (use-package jupyter :ensure t
   :config (setenv "EDITOR" "emacsclient")
    ;; shell:
    ;;   i jupyter perl-cpanplus-dist-arch perl-moose
    ;;   cpanp install Devel::IPerl
   ) 
  (require 'org-tempo) ;; 20201014 removed from default settings. add back
  (setq org-babel-python-command "python3")
  (org-babel-do-load-languages 'org-babel-load-languages
      '(
	(R . t)      ; rm ob-R.elc if "Invalid function: org-babel-header-args-safe-fn"
	(python . t)
	;(ipython . t) ; (wrong-type-argument stringp sh)
	(octave . t)
	(perl . t)
	(ruby . t)
	(sql . t)
	(sqlite . t)
	(shell . t) ; req newer org mode
	(J . t)
        (jupyter . t)
	;(sh . t) ; old - removed from org mode
	;(bash . t) ; doesn't exist
        ))

  ;; must be afer org load-language -- function doesn't exist?
  ;(org-babel-jupyter-override-src-block "python")
  ;(org-babel-jupyter-override-src-block "perl")
  ;(org-babel-jupyter-override-src-block "julia")
  ;; revert with (org-babel-jupyter-restore-src-block "...")
  

  ;; keep ids ordered for better version control of minor changes
  ;; 20200609 - https://www.reddit.com/r/orgmode/comments/aagmfh/export_to_html_with_useful_nonrandom_ids_and
  (defun org-export-deterministic-reference (references)
   	(let ((new 0))
   	     (while (rassq new references) (setq new (+ new 1))) 
   	     new))
  (advice-add #'org-export-new-reference :override #'org-export-deterministic-reference))

(use-package ob-ipython :ensure t :after org)
(use-package ob-async :ensure t :after org) ; use :async in src_block header
(use-package org-bullets :ensure t :after org
  :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


;; 
(defun my/org-header-sizes ()
  "font sizes for org-level/outline"
  (custom-set-faces
   '(org-document-title ((t (:inherit outline-1 :height 2.3))))
   '(org-level-1 ((t (:inherit outline-1 :height 2.0))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.5))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0))))))
