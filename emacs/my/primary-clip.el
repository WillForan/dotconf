(defun my/get-primary ()
  "paste x11 primary"
  (interactive)
  (insert (gui-get-primary-selection)))

;; shift-insert like terminal: x11 primary clipboard
;; 20191116 - use [()] syntax
(global-set-key [(shift insert)] 'my/get-primary)
