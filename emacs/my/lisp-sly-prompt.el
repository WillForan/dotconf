;;; sly prompt customization from ambrevar
;; https://gitlab.com/ambrevar/dotfiles/-/blob/cbe3c2c7cce394119059f1bfa72464d735c90217/.emacs.d/lisp/init-sly.el
(defvar ambrevar/sly-status--last-command-time nil)
(make-variable-buffer-local 'ambrevar/sly-status--last-command-time)
(defun ambrevar/sly-status--record ()
  (setq ambrevar/sly-status--last-command-time (current-time)))

(defun ambrevar/sly-status-formatter (timestamp duration)
  "Return the status display for `ambrevar/sly-status'.
TIMESTAMP is the value returned by `current-time' and DURATION is the floating
time the command took to complete in seconds."
  (format "#[STATUS] End time %s, duration %.3fs\n"
          (format-time-string "%F %T" timestamp)
          duration))

(defcustom ambrevar/sly-status-min-duration 1
  "If a command takes more time than this, display its status with `ambrevar/sly-status'."
  :group 'sly
  :type 'number)

(defun ambrevar/sly-status (&optional formatter min-duration)
  "Termination timestamp and duration of command.
Status is only returned if command duration was longer than
MIN-DURATION \(defaults to `ambrevar/sly-status-min-duration').  FORMATTER
is a function of two arguments, TIMESTAMP and DURATION, that
returns a string."
  (if ambrevar/sly-status--last-command-time
      (let ((duration (time-to-seconds
                       (time-subtract (current-time) ambrevar/sly-status--last-command-time))))
        (setq ambrevar/sly-status--last-command-time nil)
        (if (> duration (or min-duration
                            ambrevar/sly-status-min-duration))
            (funcall (or formatter
                         #'ambrevar/sly-status-formatter)
                     (current-time)
                     duration)
          ""))
    (progn
      (advice-add 'sly-mrepl--send-input-sexp :after #'ambrevar/sly-status--record)
      "")))

(defun ambrevar/sly-prepare-prompt (old-func &rest args) ; TODO: Remove when upstream have merged `sly-mrepl-prompt-formatter'.
  (let ((package (nth 0 args))
        (new-prompt (format "%s%s\n%s"
                            (ambrevar/sly-status)
                            (abbreviate-file-name default-directory)
                            (nth 1 args)))
        (error-level (nth 2 args))
        (condition (nth 3 args)))
    (funcall old-func package new-prompt error-level condition)))

(cl-defun ambrevar/sly-new-prompt (_package
                                package-nickname
                                error-level
                                entry-idx
                                _condition)
  (concat
   (propertize (ambrevar/sly-status) 'font-lock-face 'font-lock-comment-face)
   "("
   (propertize (abbreviate-file-name default-directory) 'font-lock-face 'diff-added)
   ")\n"
   (propertize "<" 'font-lock-face 'sly-mrepl-prompt-face)
   (propertize (number-to-string entry-idx) 'font-lock-face 'sly-mode-line)
   (propertize ":" 'font-lock-face 'sly-mrepl-prompt-face)
   (propertize package-nickname 'font-lock-face 'sly-mode-line)
   (when (cl-plusp error-level)
     (concat (sly-make-action-button
              (format "[%d]" error-level)
              #'sly-db-pop-to-debugger-maybe)
             " "))
   (propertize "> " 'font-lock-face 'sly-mrepl-prompt-face)))
(defun ambrevar/sly-end-of-prompt-p ()
  (and (not (= (point) (point-min)))
       (not (get-text-property (point) 'sly-mrepl--prompt))
       (get-text-property (1- (point)) 'sly-mrepl--prompt)))

(defun ambrevar/sly-prompt-line-p ()
  (or (ambrevar/sly-end-of-prompt-p)
      (save-excursion
        (goto-char (line-beginning-position))
        (ambrevar/sly-end-of-prompt-p))))

(defun ambrevar/sly-mrepl-previous-prompt ()
  "Go to the beginning of the previous REPL prompt."
  (interactive)
  (cl-flet ((go-back ()
                     (goto-char
                      (previous-single-char-property-change
                       (point) 'sly-mrepl--prompt))))
    (if (ambrevar/sly-prompt-line-p)
        (progn
          (unless (ambrevar/sly-end-of-prompt-p)
            (goto-char (line-beginning-position)))
          (go-back)
          (go-back))
      (go-back))
    (unless (ambrevar/sly-prompt-line-p)
      ;; We did not end up on a prompt, means we are above the first prompt.
      ;; Return back.
      (ambrevar/sly-mrepl-next-prompt))))

(with-eval-after-load 'sly-mrepl
  (if (boundp 'sly-mrepl-prompt-formatter)
      (setq sly-mrepl-prompt-formatter
            #'ambrevar/sly-new-prompt)
    (advice-add 'sly-mrepl--insert-prompt :around #'ambrevar/sly-prepare-prompt)))

(defun ambrevar/sly-colorize-buffer (str)  
  "Useful for colorized output like the tests of Prove."
  (ansi-color-apply str))
(add-hook 'sly-mrepl-output-filter-functions 'ambrevar/sly-colorize-buffer)
