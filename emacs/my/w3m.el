(use-package w3m
  :custom
  (w3m-search-default-engine "duckduckgo")
  (w3m-quick-start nil)
  (w3m-display-mode 'plain)
  (w3m-use-title-buffer-name t)
  (w3m-confirm-leaving-secure-page nil)
  ;; 20210218 - dont need numbers in links w/emacs, but enabled for cli
  (w3m-command-arguments
   (nconc w3m-command-arguments
	  '("-o" "display_link_number=0")))
  :bind
  (:map w3m-mode-map
	("<mouse-8>" . w3m-view-previous-page)
	("<mouse-9>" . w3m-view-next-page)
	("R" . tsa/w3m-toggle-readability)
	("M-o" . ace-link-w3m))

  :config
  ;; from https://tech.toryanderson.com/2021/06/09/how-to-get-readable-mode-in-emacs-w3m/
  (defun tsa/readability (url)
    "Get the Readable.JS version of URL"
    (interactive "P")
    (message "readabilizing...")
    (erase-buffer)
    (insert (shell-command-to-string (concat "curl " url " 2>/dev/null | readability " url))))

  (defun tsa/w3m-toggle-readability (&arg)
    "Toggle readibility and reload the current page"
    (interactive "P")
    (w3m-toggle-filtering nil)
    (w3m-reload-this-page)
    (w3m-toggle-filtering nil))

  (add-to-list 'w3m-filter-configuration '(t "Make page readable" ".*" tsa/readability)))

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
