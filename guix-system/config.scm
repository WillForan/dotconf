;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (gnu system)
	     ;(gnu system locale)
	     (gnu services)
	     (gnu services desktop) ; %desktop-services
	     (gnu packages admin)
	     (gnu services networking)
             (srfi srfi-1) ; lset<=
)
(use-service-modules ssh xorg networking)

;; 20230520 - remove services by name
(define *desktop-rm* '(network-manager-applet network-manager gdm
                       avahi mtp modem-manager sane  cups-pk-helper
                       wpa-supplicant ; redefined
                       gdm-file-system geoclue ))
(define (not-excluded s)
   "check the service kind name against an excluded list (global)"
   (not (lset<= eq? (list (service-type-name (service-kind s))) *desktop-rm*)))

(operating-system
  ;(locale %default-locale-definitions)
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "cn60-guix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "foranw")
                  (comment "Will")
                  (group "users")
                  (home-directory "/home/foranw")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list
		     (specification->package "tmux")
		     (specification->package "git")
		     (specification->package "vim") (specification->package "emacs")
		     (specification->package "i3-wm") (specification->package "i3status")
		     (specification->package "xterm") (specification->package "st")
		     (specification->package "rofi") (specification->package "dmenu")
		     (specification->package "nss-certs"))
		    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
      (cons*
       (service slim-service-type
		(slim-configuration
		  (display ":0")
		  (vt "vt7")
		  (xorg-configuration
		   (xorg-configuration (keyboard-layout keyboard-layout)))))
       (service openssh-service-type)

       ;; https://gitgud.io/znavko/guix-configs/-/blob/master/guix-config-dual-boot.scm 2020-12-04
       ;; guix system: error: =>: bad use of '=>' syntactic keyword
       ;; https://lists.gnu.org/archive/html/help-guix/2019-04/msg00036.html
       (service wpa-supplicant-service-type 
		(wpa-supplicant-configuration
		 (interface "wlp2s0")
		 (config-file "/etc/abraham_linksys_5g.conf")))
       (service dhcp-client-service-type (dhcp-client-configuration (interfaces '("wlp2s0"))))

       ;; desktop but without gdm (replace w/slim) and known wifi network
       ;(modify-services %desktop-services
       ; 		(delete network-manager-service-type)
       ; 		(delete gdm-service-type)
       ; 		(delete avahi-service-type))

       ; service if not exclued otherwise false so filtermap will discard
       (filter-map (lambda (x) (if (not-excluded x) x #f)) %desktop-services)))	

  ;; (services
  ;;  (append (list
  ;;                ;; To configure OpenSSH, pass an 'openssh-configuration'
  ;;                ;; record as a second argument to 'service' below.
  ;;                (service openssh-service-type)
  ;;                (set-xorg-configuration
  ;;                 (xorg-configuration (keyboard-layout keyboard-layout))))
  ;;          ;; This is the default list of services we
  ;;          ;; are appending to.
  ;;          %desktop-services))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "C2E6-A8EA"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "0c448fa2-b0b0-47dd-8a01-fff33b867c30"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
