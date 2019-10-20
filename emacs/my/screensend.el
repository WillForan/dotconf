;; send lines to repl running in tmux
(use-package screensend :defer t :bind ("C-c s" . tmux-send))
