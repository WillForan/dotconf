;; 20171229 -- switch window, keybindings and home row key selection
(use-package switch-window :ensure t :defer t
  :config
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l" ";" "w" "e" "i" "o"))
  :bind
  (("C-x o" . switch-window)
   ;; base.el has windmove-default-keybindings. these windmove binds for org mode
   ("C-x <up>" . windmove-up)
   ("C-x <down>" . windmove-down)
   ("C-x 1" . switch-window-then-maximize)
   ("C-x 2" . switch-window-then-split-below)
   ("C-x 3" . switch-window-then-split-right)
   ("C-x 0" . switch-window-then-delete)))
