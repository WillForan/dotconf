;; secondary slection without moving point (20210418)
;; alt + scroll up  : paste
;; alt +        down: move  (cut+paste)

;; releated: for drag and drop text:
;;   (setq mouse-drag-and-drop-region t)

(defun my/secondary-paste (click)
  "paste secondary selection at current cursor, ignore click
make copying require one lass \"careful click\". see 
http://www.cs.man.ac.uk/~lindsec/secondary-selection.html

alt+left click/drag/double/tripple, alt+wheel up to paste"
  (interactive "e")
  (insert (gui-get-selection 'SECONDARY)))

(defun my/secondary-move (&rest _)
  "move secondary selection to current cursor position. ignores click position"
  (interactive)
  (let* ((beg (overlay-start mouse-secondary-overlay))
	 (end (overlay-end mouse-secondary-overlay))
	 (text (delete-and-extract-region beg end)))
    (delete-overlay mouse-secondary-overlay)
    (insert text)))
;;  up to copy, down to cut
(global-set-key (kbd "M-<mouse-4>") 'my/secondary-paste)
; cant see when 'move' would be useful (yet)
(global-set-key (kbd "M-<mouse-5>") 'my/secondary-move)



;; set secondary using just mouse (with extra buttons)
;; also see acme editor and wand.el
(defun my/secondary-search (&rest _)
  "search whats on the secondary clipboard
kludge: if minibuffer is active assume ivy and go to the next line
force always wrap"
  (interactive)
  (if (active-minibuffer-window)
      (let ((ivy-wrap t)) (ivy-next-line))
    (swiper (gui-get-selection 'SECONDARY))))

;; use mouse 8 (bottom extra button) for select and search 
;; alt+left click to remove secondary selection
(global-set-key (kbd "<drag-mouse-8>") 'mouse-drag-secondary)
(global-set-key (kbd "<double-mouse-8>") 'my/secondary-search)
;; todo mouse-8 if active minibuffer accepts search. otherwise like alt+left mouse
;; (global-set-key (kbd "<mouse-8>") nil)
;; (global-set-key (kbd "<mouse-down-8>") nil)
