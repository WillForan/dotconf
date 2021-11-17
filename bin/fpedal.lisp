;; what keys to push when pedals are used
;; run: sbcl --load ~/bin/fpedal.lisp --non-interactive --quit
;;      sly-connect localhost 4008 (in-package :fpedal)
; (use-pacakge 'alexandria)
(in-package :cl-user)
(ql:quickload '("cl-interpol" "cmd" "alexandria" "slynk"))
(slynk:create-server :port 4008)
(defpackage fpedal
  (:use :cl :alexandria)
  (:import-from :uiop)
  (:import-from :cmd)
  (:import-from :cl-interpol)
  (:export :watch-pedal))
(in-package :fpedal)

(cl-interpol:enable-interpol-syntax)
(defparameter *action-list* 
  `(
   (#?R"^$" . (
       (:release . key-release)
       (:left    . ,(lambda () (key-down "Control_L")))
       (:center  . ,(lambda () (key-down "Escape" :k "key")))
       (:right   . ,(lambda () (key-down "Alt_L")))))
   (#?R"Firefox Developer Edition" . (
       (:release . ,(lambda () nil))
       (:center  . ,(lambda () (key-down "8" :k "click" ))) ; back history
       (:left    . ,(lambda () (key-down "Page_Up" :k "key" )))
       (:right   . ,(lambda () (key-down "Page_Down" :k "key")))
       ;; (:left    . ,(lambda () (key-down "4" :k "click")))
       ;; (:right   . ,(lambda () (key-down "5" :k "click")))
       ))
   (#?R"emacs" . (
       ;; (:left    . ,(lambda () (key-down "Control_L+s" :k "key")))
       (:left    . ,(lambda () (key-down "Control_L")))
       (:center  . ,(lambda () (key-down "Control_L+g" :k "key")))
       (:right   . ,(lambda () (key-down "Alt_L+x" :k "key")))))))

(defparameter *ev-input* "/dev/input/by-id/usb-VEC_VEC_USB_Footpedal-event-if00")
(defparameter *num-to-pedal*
  (alist-hash-table
   '(("0". :release)
     ("1". :left)
     ("2". :center)
     ("3". :center-left)
     ("4". :right)
     ("6". :center-right))
   :test 'equal))

;; quick concat. should use #?"${var}" or str:join
(defmacro c (&body body) `(concatenate 'string ,@body))
(defun xdo (cmds) (cmd:$cmd #?"xdotool ${cmds}"))
(defun active-win () "focused window's name"
  (cmd:$cmd "xdotool getwindowfocus getwindowname"))
;; (deftype xdokey () '(member "keydown" "key" "text" "keyup"))
(defun key-down (kbd-keys &key (k "keydown"))
  "xdotool wrapper default to keydown K likely key or click"
  (cmd:cmd (c "xdotool " k " " kbd-keys)))
(defun key-release (&rest _) 
  (cmd:cmd "xdotool keyup Control_L keyup Alt_L keyup Hyper_L"))

(defun get-action (winregex pedal)
  "get double nested assoc from global list"
  (cdr (assoc pedal
		    (cdr (assoc winregex
				*action-list*
				:test #'equal))
		    :test #'equal)))

(defun key-cmd (win pedal)
  "find the first window match that also has a pedal"
  (or (loop 
	:with key-func = nil
	:for winregex :in (mapcar #'car *action-list*)
	:do (setf key-func (if (cl-ppcre:all-matches winregex win)
			       (get-action winregex pedal)
			       nil))
	:if key-func do (return key-func))
      (get-action #?R"^$" pedal)))


(defun btnval (line) "extract button push value from string"
 (cl-ppcre:scan-to-strings #?R"(?<=BTN_TOUCH., value )\d$" line))

(defun read-event-line (line) "process lines of evtest"
  (let* ((keynum (btnval line))
	 (pedal (gethash keynum *num-to-pedal*))
	 (win (active-win))
	 (f (key-cmd win pedal)))
    (print pedal)
    (print win)
    (if f (funcall f))))

(defun cmd-stream (cmd) "uiop stream of command"
  (uiop:process-info-output (uiop:launch-program cmd :output :stream)))
(defun watch-pedal ()
  ;; run with file. NB. don't save string. have no way to (close)?
  ;; errors about "descriptor 6" when evtest DNE
  (with-open-stream (s (cmd-stream (c "sudo evtest " *ev-input*)))
    (loop for line = (read-line s) while line do (read-event-line line))))

(defun run-as-thread ()
  "useful for running on repl"
  (defvar *fpedal-thread*)
  (setq *fpedal-thread* (bt:make-thread  #'watch-pedal))
  ;; see (bt:all-threads)
  ;; e.g. (bt:destroy-thread (nth 3 #v5))
)
(watch-pedal)
