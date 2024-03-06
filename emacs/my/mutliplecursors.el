;; C-n / C-p : create (wrap around)
;; M-n / M-p : cycle (no wrap)
;; To skip creating a cursor forward use C-t or grn and backward grp.
;; g r
;;     h - here
;;     q - quit
;;     u - remove last
;; C-n next match, C-t discard
(use-package evil-mc :ensure t :defer t
  :config
  (setq mc/always-run-for-all t)
  (global-evil-mc-mode 1))

;; taken from 
;; https://iqss.github.io/IQSS.emacs/init.html
;; tips and tricks from github: https://github.com/magnars/multiple-cursors.el
;; C-v , M-v: scroll center on each cursor
;; C-' un/hide all lines without a cursor
(use-package multiple-cursors :ensure t
  :init
  (defhydra multiple-cursors-hydra (:hint nil)
    "
   ^Up^            ^Down^        ^Other^
----------------------------------------------
[_p_]   Next    [_n_]   Next    [_l_] Edit lines
[_P_]   Skip    [_N_]   Skip    [_a_] Mark all
[_M-p_] Unmark  [_M-n_] Unmark  [_r_] Mark by regexp
^ ^             ^ ^             [_q_] Quit
"
    ("l" mc/edit-lines :exit t)
    ("a" mc/mark-all-like-this :exit t)
    ("n" mc/mark-next-like-this)
    ("N" mc/skip-to-next-like-this)
    ("M-n" mc/unmark-next-like-this)
    ("p" mc/mark-previous-like-this)
    ("P" mc/skip-to-previous-like-this)
    ("M-p" mc/unmark-previous-like-this)
    ("r" mc/mark-all-in-region-regexp :exit t)
    ("q" nil))

    (global-set-key (kbd "C-c m") #'multiple-cursors-hydra/body))
