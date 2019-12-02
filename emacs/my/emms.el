(use-package emms
  :config
  (emms-all)
  (emms-default-players)
  (setq emms-source-file-default-directory "/mnt/storage/Music/")
  (setq emms-playlist-buffer-name "*Music*")
  ; (setq emms-info-asynchronously t)
  ; (require 'emms-info-libtag) 
  ; (setq emms-info-functions '(emms-info-libtag))
  ; (use-package emms-info-mediainfo :ensure t)
  ; add libre.fm in ~/.authinfo.gpg
  ; install mp3info mpg321
)

