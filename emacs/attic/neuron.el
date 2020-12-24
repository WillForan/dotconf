
;; 2020110x neuron for zettelkasten. markdown. non standard link syntax
;; "rib" and "shake" to make static http for exploring notes
;; 20201118 - prefer org-roam (?)
(defun my/sluggify (title)
 (s-join "-" (split-string (s-downcase title))))
 
(use-package neuron-mode :ensure t :defer t
  :init
    (add-hook 'neuron-mode-hook 'flyspell-mode)
 :config
    (setq neuron-id-format 'my/sluggify)
    (setq neuron-default-zettelkasten-directory "~/notes/zettel/"))
