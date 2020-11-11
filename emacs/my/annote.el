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

;; 2020110x neuron for zettelkasten. markdown. non standard link syntax
;; "rib" and "shake" to make static http for exploring notes
(defun my/sluggify (title)
 (s-join "-" (split-string (s-downcase title))))
 
(use-package neuron-mode :ensure t :defer t
  :init
    (add-hook 'neuron-mode-hook 'flyspell-mode)
 :config
    (setq neuron-id-format 'my/sluggify)
    (setq neuron-default-zettelkasten-directory "~/notes/zettel/"))

;; 20201110 - like neuron but for org mode
(use-package org-roam
      :ensure t
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/notes/org-files/")
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))
