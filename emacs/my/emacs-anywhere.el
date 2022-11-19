
;; c-c c-c (exit and past) or c-c c-k (no paste)
(use-package emacs-everywhere :ensure t
  :init
  (defun emacs-everywhere-pidgin-paste ()
    (let ((app (emacs-everywhere-app-class emacs-everywhere-current-app))))
    (set 'emacs-everywhere-paste-command
         (case
             (string= app "Pidgin") '("xdotool" "key" "--clearmodifiers" "Control+V")
             (string= app "Firefox") '("xdotool" "key" "--clearmodifiers" "Control+v")
             t emacs-everywhere-paste-command)))
  :custom
  (emacs-everywhere--display-server 'x11 "force x11")
  :config
  (add-to-list 'emacs-everywhere-markdown-apps "Pidgin")
  (add-hook 'emacs-everywhere-init-hooks #'emacs-everywhere-pidgin-paste)
  (add-hook 'emacs-everywhere-init-hooks #'flyspell-mode-on)
  ;; 20220314 pandoc check obscuring markdown-mode check?
  (add-hook 'emacs-everywhere-init-hooks #'emacs-everywhere-major-mode-org-or-markdown))



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
