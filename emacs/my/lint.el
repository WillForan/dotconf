
;; 20220403 - https://emacstil.com/til/2022/03/05/setting-up-vale-prose-linter-on-emacs/
;; 20220811 - enable flycheck for all prog

(use-package flycheck :ensure t
  :init
  (global-flycheck-mode)
  :config
  (flycheck-define-checker vale
                           "A checker for prose"
                           :command ("vale" "--output" "line"
                                     source)
                           :standard-input nil
                           :error-patterns
                           ((error line-start (file-name) ":" line ":" column ":" (id (one-or-more (not (any ":")))) ":" (message) line-end))
                           :modes (markdown-mode org-mode text-mode message-mode mu4e-compose-mode)
                           )
  (add-to-list 'flycheck-checkers 'vale 'append))

(use-package langtool :ensure t
  :init
  (setq langtool-java-classpath "/usr/share/languagetool:/usr/share/java/languagetool/*")
  (setq langtool-language-tool-server-jar "/usr/share/java/languagetool/languagetool-server.jar")
  )
