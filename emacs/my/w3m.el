;; from https://tech.toryanderson.com/2021/06/09/how-to-get-readable-mode-in-emacs-w3m/
(defun tsa/readability (url)
  "Get the Readable.JS version of URL"
  (interactive "P")
  (message "readabilizing...")
  (erase-buffer)
  ;; 20230212 - switch from readability to reader-bin from https://github.com/mrusme/reader
  (insert (shell-command-to-string (concat "curl -s " url " | reader " url))))

(defun tsa/w3m-toggle-readability (&arg)
  "Toggle readibility and reload the current page"
  (interactive "P")
  (w3m-toggle-filtering nil)
  (w3m-reload-this-page)
  (w3m-toggle-filtering nil))

;; 20211003 http://blog.binchen.org/posts/toggle-http-proxy-in-emacs-w3m.html
(defun w3m-toggle-env-http-proxy ()
  "set/unset the environment variable http_proxy which w3m uses"
  (interactive)
  (let ((proxy "http://192.168.1.130:8118"))
    (if (string= (getenv "http_proxy") proxy)
        ;; clear the proxy
        (progn
          (setenv "http_proxy" "")
          (message "env http_proxy is empty now"))
      ;; set the proxy
      (setenv "http_proxy" proxy)
      (message "env http_proxy is %s now" proxy))))


(use-package w3m
  :custom
  (w3m-search-default-engine "google")
  (w3m-quick-start nil)
  (w3m-display-mode 'plain)
  (w3m-use-title-buffer-name t)
  (w3m-confirm-leaving-secure-page nil)
  :hook (w3m-mode . (lambda() (display-line-numbers-mode -1)))

  :config
  ;; 20210218 - dont need numbers in links w/emacs, but enabled for cli
  ;; 20210930 - dont nconc -- adds too many times
  (setq w3m-command-arguments '("-o" "display_link_number=0"))
  (add-to-list 'w3m-search-engine-alist '("m" "https://search.marginalia.nu/search?query=%s" utf-8))

  ;; kind of like having a space as the leader key
  ;; used on phone. modifier keys are more of a pain
  ;; and leaving home row on small keybaord is hard
  (require 'key-chord)
  ;; toggles, one diriection: #'evil-exit-emacs-state
  (key-chord-define w3m-mode-map "jk" #'evil-emacs-state)
  (key-chord-define w3m-mode-map " x" #'counsel-M-x)
  (key-chord-define w3m-mode-map " b" #'ivy-switch-buffer)
  (key-chord-define w3m-mode-map " l" #'ace-link-w3m)
  (key-chord-define w3m-mode-map " o" "\C-xo")
  (key-chord-define w3m-mode-map " c" "\C-c")

  ;; (add-to-list 'w3m-filter-configuration '(t "Make page readable" ".*" tsa/readability))


 :bind
   (:map w3m-mode-map
	 ("R" . tsa/w3m-toggle-readability)
	 ("M-o" . ace-link-w3m)
	 ;; L masks w3m-lnum-mode. but like ace hints better (chars instead of nums)
	 ("L" . link-hint-open-link)
	 ("/" . swiper)
	 ("<mouse-8>" . w3m-view-previous-page)
	 ("<mouse-9>" . w3m-view-next-page)))
