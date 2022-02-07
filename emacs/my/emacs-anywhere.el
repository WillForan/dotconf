
;; c-c c-c (exit and past) or c-c c-k (no paste)
(use-package emacs-everywhere :ensure t
  :init
  (defun emacs-everywhere-pidgin-paste ()
    (when (string= (emacs-everywhere-app-class emacs-everywhere-current-app) "Pidgin")
      (set 'emacs-everywhere-paste-cmd
           '("xdotool" "key" "--clearmodifiers" "Control+V"))))
    
  :config
 (add-hook 'emacs-everywhere-init-hooks 'emacs-everywhere-pidgin-paste))


;; ORIGINAL doesnt work on firefox developer edition (?!)
;;  but the original does have an easier hook
;; install:
;; git clone https://github.com/zachcurry/emacs-anywhere.git ~/.emacs_anywhere
;; bind: ~/.emacs_anywhere/bin/run
;; TODO: configure stumpwm to treat as floating?

;; (defun github-conversation-p (window-title)
;;   (or (string-match-p "Pull Request" window-title)
;;       (string-match-p "Issue" window-title)))

;; (defun popup-handler (app-name window-title x y w h)
;;   (message "emacs-anywhere: app %s title %s" app-name window-title)
;;   (set-frame-position (selected-frame) x (+ y (- h 400)))
;;   ;; dont paste back into term. presumably we could have C-x C-e there
;;   (when (equal app-name "XTerm") (setq ea-paste nil))
;;   (cond
;;     ((github-conversation-p window-title) (gfm-mode))
;;     (t (markdown-mode)) ; default major mode
;;     ))

;; ;; hook 
;; (add-hook 'ea-popup-hook 'popup-handler)
