(use-package calfw :ensure t)
(use-package calfw-ical :ensure t
  :after calfw
  :init
  (defun my/open-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:ical-create-source "Work" "~/.calendars/upmc_bigfile.ics" "Blue") ; see vdirsync
      ))))

(use-package khalel :ensure t)
