(defun my/comint-all-args ()
  "dumb word split on history. all arguments, each as an element in a list"
  (mapcan #'(lambda (s)
	      (cdr (split-string (substring-no-properties s))))
	  (ring-elements comint-input-ring)))

(defun my/comint-args ()
  "insert from list of previous arguments in comint-input-ring"
  (interactive)
  (helm :sources (helm-build-sync-source "comint args"
                   :candidates (my/comint-all-args)
                   :fuzzy-match t
		 :action #'insert)
      :buffer "*helm comint args*"))

(use-package bash-completion :ensure t
  :config
  (bash-completion-setup))
