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
   ;; might be more work than it's worth
   ;; muscle memory is: go to window then kill/split
   ;; using that, this is an extra step
   ("C-x 1" . switch-window-then-maximize)
   ("C-x 2" . switch-window-then-split-below)
   ("C-x 3" . switch-window-then-split-right)
   ("C-x 0" . switch-window-then-delete)))

;; move windows like a tiling window manager
(use-package buffer-move :ensure t :defer t
  :bind (("C-S-h" . #'buf-move-left)
	 ("C-S-j" . #'buf-move-down)
	 ("C-S-k" . #'buf-move-up)
	 ("C-S-l" . #'buf-move-right)))

;; rotate-layout, rotate:main-horizontal, rotate-main-vertial
(use-package rotate :ensure t :defer t)

;; TODO: consider using popwin to remove annoying windows
;; expecially buffer-list (C-x C-b). or maybe just remap that binding
;; https://stackoverflow.com/questions/1212426/how-do-i-close-an-automatically-opened-window-in-emacs
;; https://github.com/emacsorphanage/popwin

;; strokes-mode would maybe be good for windows managment on a touch screen?
