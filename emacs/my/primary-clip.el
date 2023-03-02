(defun my/get-primary ()
  "Paste x11 primary using expected keys."
  (interactive)
  (insert (gui-get-primary-selection)))

;; shift-insert like terminal: x11 primary clipboard
;; 20191116 - use [()] syntax
(global-set-key [(shift insert)] 'my/get-primary)
;; 20230221 - 'pastry' spoken to numen
(global-set-key [XF86Paste] 'my/get-primary)

;;; primary-clip.el ends here
