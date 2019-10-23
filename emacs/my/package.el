;; packaging
(require 'package)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq package-check-signature nil)
(add-to-list 'package-archives    '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives    '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives    '("org"   . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives    '("elpy"  . "https://jorgenschaefer.github.io/packages/"))
(package-initialize)
;; make sure we have use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
