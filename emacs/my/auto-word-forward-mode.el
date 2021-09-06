;; set a timer to advance cursor one word and recenter screen 
;; heavily inspired by Ian Kelling's spray-mode.el https://sr.ht/~iank/
;; 20201227WF - init

(defvar awfm-wpm 300)
(defvar awfm--running nil)
(defvar awfm--curbuf nil)

(defun awfm--update ()
   "move cursor one word. recenter screen"
  
  ;; it's really annoying if we switch buffers 
  ;; and start scrolling there (esp. mini buffer)
  (if (not (equal (current-buffer) awfm--curbuf))
      (progn
	(awfm-stop)))

  ;; track before and after move so we don't have to recenter every movement
  (setq p1 (line-beginning-position))
  (forward-word)
  (setq p2 (line-beginning-position))
  (if (> p2 p1) (recenter-top-bottom))

  ;; Stop when there is nothing left to do.
  ;; If not explicit, we'll be surprised when we try to move the
  ;; cursor from the end and it starts moving again
  (if (eobp) (awfm-stop))
)

(defun awfm--make-timer ()
  "make the timer"
  (setq awfm--curbuf (current-buffer))
  (setq awfm--running
	(run-with-timer 0 (/ 60.0 awfm-wpm) #'awfm--update)))

(defun awfm-start ()
  "start moving forward by words"
  (interactive)
  (when (not awfm--running) (awfm--make-timer)))

(defun awfm-stop ()
  "stop the timer. return to normal"
  (interactive)
  (when awfm--running 
    (cancel-timer awfm--running))
  (setq awfm--running nil)
  (message "auto word forward stopped"))

(defun awfm-toggle ()
  "start if stopped or stop if running"
  (interactive)
  (if awfm--running (awfm-stop) (awfm-start)))

(provide 'auto-word-forward)
