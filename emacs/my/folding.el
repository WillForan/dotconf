(use-package origami :ensure t
  :config
    ; this should go in evil mode?
    (evil-leader/set-key "f" 'major-mode-hydras/origami/body)
  :mode-hydra
  ("main"
   (("o" origami-open-node)
    ("c" origami-close-node)
    ("n" origami-next-fold)
    ("p" origami-previous-fold)
    ("f" origami-forward-toggle-node)
    ("a" origami-toggle-all-nodes))))
