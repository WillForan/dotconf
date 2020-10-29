(use-package pdf-tools :ensure t :defer t
  :pin manual ;; need to redo pdf-tools-install compile after upgrade
  :config
    (pdf-tools-install)
    (setq pdf-annot-activate-created-annotates t) )

;; after text is selected
;;  C-c C-c => annotate
;;  C-c C-a h => highlight
;;  C-c C-a t => text
;;  C-c C-a D => delete

(use-package org-noter :ensure t :defer t 
    :config
    (setq org-noter-auto-save-last-location t)
    (setq org-noter-notes-search-path '("~/src/notes/org-noter")))

(use-package nov :ensure t :defer t 
  :init 
    (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  :config
    (setq nov-text-width 80)
)

(defun my/no-cursor  () "hide text cursor" (lambda () (internal-show-cursor nil nil)))
(defun my/yes-cursor () "show text cursor" (lambda () (internal-show-cursor nil t)))
(use-package spray :ensure t :defer t
 :config
  (advice-add 'spray-mode :after 'my/no-cursor)
  (advice-add 'spray-quit :after 'my/yes-cursor)
 :bind (:map spray-mode-map ("C-c c" . my/toggle-cursor))
)
