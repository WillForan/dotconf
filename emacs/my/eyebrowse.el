;; 20200513 
;; compare to centaur-switch-groups
;; http://pragmaticemacs.com/emacs/easily-manage-emacs-workspaces-with-eyebrowse/
 (use-package eyebrowse
  :ensure t
  :diminish eyebrowse-mode
  :config 
    ;(define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
    ;(define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
    ;(define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
    ;(define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
    (eyebrowse-mode t)
    (setq eyebrowse-new-workspace t)) 
