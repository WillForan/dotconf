;; base config
(load "~/.emacs.d/my/my.el")
(mapcar #'my/use
	'(base backup
	  package quelpa
	  evil theme
	  helm zim-wiki-mode screensend))
