;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
;	     (nongnu packages linux)
;	     (nongnu system linux-initrd)
;	     (nongnu packages nvidia)
	     (gnu services linux)
	     (guix transformations)
	     (gnu packages xorg)
	     (gnu packages xfce)
	     (gnu services security-token)
	     )
(use-service-modules desktop networking sddm ssh xorg)
(use-package-modules freedesktop)

;(define transform
;  (options->transformation
;    '((with-graft . "mesa=nvda"))))

(operating-system
;  (kernel linux-5.4)
;  (initrd microcode-initrd)
;  (firmware (list linux-firmware))
;  (kernel-arguments 
;	(append
;	  '("modprobe.blacklist=nouveau")
;	  %default-kernel-arguments))
;  (kernel-loadable-modules (list nvidia-driver))
  (locale "en_GB.utf8")
  (timezone "Asia/Yekaterinburg")
  (keyboard-layout (keyboard-layout "us,ru" #:options '("grp:alt_shift_toggle")))
  (host-name "teahouse")
  (users (cons* (user-account
                  (name "xeaal")
                  (comment "")
                  (group "users")
                  (home-directory "/home/xeaal")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
	(map specification->package 	'("openbox"
					  "nss-certs"
					  "xauth"
					  "qt5ct"
					  "zsh"
					  "lxappearance"
					  "dmenu"
					  "st"
					  "git"
					  "feh"
					  "pulseaudio"
					  "pavucontrol"
					  "nitrogen"
					  "xterm"
					  "mpv"
					  "mpd"
					  "vim"
					  "ranger"
					  "emacs"
					  "xsetroot"
					  "chili-sddm-theme"
					  "flatpak"
					  "htop"
					  ))
      %base-packages))
  (services
    (append
      (list (service xfce-desktop-service-type) ;(xfce-desktop-configuration (xfce (transform xfce))))
;            (service mate-desktop-service-type)
	    (service pcscd-service-type)
	    (simple-service 'env-var
			    session-environment-service-type
			    '(("EDITOR" . "emacs")
			      ("QT_QPA_PLATFORMTHEME" . "qt5ct")))
;	    (simple-service 'custom-udev-rules udev-service-type
;			    (list nvidia-driver))
;	    (service kernel-module-loader-service-type '("ipmi_devintf" "nvidia" "nvidia_modeset" "nvidia_uvm"))
            (service sddm-service-type
             (sddm-configuration
              (theme "chili")
              (xorg-configuration
               (xorg-configuration
;		(modules (cons* nvidia-driver %default-xorg-modules)) 
;		(drivers '("nvidia"))
;		(server (transform xorg-server))
                (keyboard-layout keyboard-layout)
		)))))
      (modify-services %desktop-services
        (delete gdm-service-type))))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "93eb1d7e-ef3c-4cff-a16b-7462b74eb150"
                     'btrfs))
             (type "btrfs"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "E3B5-4057" 'fat32))
             (type "vfat"))
           %base-file-systems)))
