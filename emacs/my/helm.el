;; discoverable/fuzzy search features
(use-package helm :ensure t :defer t
  :bind
    ("M-x" . helm-M-x)
    ("C-x b" . helm-mini) ;; also see helm-buffers-list
    ("C-x C-f" . helm-find-files)
    ("M-C-y"   . helm-show-kill-ring) ; default is C-x c M-y
    ;; if helm breaks, we have an escape hatch with chords using shift
    ("M-X" . execute-extended-command)
    ("C-x F" . find-file)
    ("C-x B" . switch-to-buffer)
  :config
    
    ; 20210328 <up> at top goes to last
    ; NB. need to use C-o to go to next source
    (setq helm-move-to-line-cycle-in-source t) 

    ;; 20181016 - tab instead of C-j: https://github.com/emacs-helm/helm/issues/1630
    ;(define-key helm-find-files-map "\t" 'helm-execute-persistent-action)
    ;; 20210330 hit tab again to toggle out of select action

    ; 20210328 - replace default history (comint-dynamic-list-input-ring)
    ; diff between input-ring and prompts is later is less styled and sorted?
    (define-key comint-mode-map (kbd "C-c C-l") 'helm-comint-input-ring)
    (define-key comint-mode-map (kbd "C-c l") 'helm-comint-prompts-all)
)


;; jump to buffer (info and shell)
(use-package helm-selector :ensure t :after 'helm
  :bind
  ("C-h i" . 'helm-selector-info)
  ("s-RET" . 'helm-selector-shell)
  ("s-S-RET" . 'helm-selector-shell-other-window))

(use-package helm-ls-git :ensure t :after 'helm)
