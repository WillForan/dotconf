
;; 20220403 - https://emacstil.com/til/2022/03/05/setting-up-vale-prose-linter-on-emacs/
;; 20220811 - enable flycheck for all prog
;; 20220910 - tweak syntax check: add delay
;; 20221210 - (earlier) add flyspell-correct w/ ivy, bind correct-next

(use-package flycheck :ensure t
  :init
  (global-flycheck-mode)
  :config
  (setq
     ;; remove new-line check. it's slow. esp in R/ESS
     ;; profiled with explain-pause-top
     flycheck-check-syntax-automatically '(save idle-change mode-enabled)
     ;; default delay is .5
     flycheck-idle-change-delay 5)

  (flycheck-define-checker vale
    "A checker for prose"
    :command ("vale" "--output" "line"
              source)
    :standard-input nil
    :error-patterns
    ((error line-start (file-name) ":" line ":" column ":" (id (one-or-more (not (any ":")))) ":" (message) line-end))
    :modes (markdown-mode org-mode text-mode message-mode mu4e-compose-mode))
  (add-to-list 'flycheck-checkers 'vale 'append))

(use-package langtool :ensure t
  :init
  (setq langtool-java-classpath "/usr/share/languagetool:/usr/share/java/languagetool/*")
  (setq langtool-language-tool-server-jar "/usr/share/java/languagetool/languagetool-server.jar"))


;; 20221206 - flyspell-forward and ivy menu for words (multiple C-; works)
(use-package flyspell-correct :ensure t
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-wrapper)
              ("C-M-;" . flyspell-correct-next)))

(use-package flyspell-correct-ivy :ensure t :after flyspell-correct)
