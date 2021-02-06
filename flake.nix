{
  description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		#nixpkgs.url = "nixpkgs/trunk-combined/tested";
		master.url = "nixpkgs/master";
		home.url = "github:rycee/home-manager/bqv-flakes";
		flake-utils.url = "github:numtide/flake-utils";
	};

  outputs = { self, master, home, nixpkgs, flake-utils }: {

    nixosConfigurations.xeaal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, config, lib, ... }: {

        imports =
          [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
          ];

        boot = {
		kernelPackages = pkgs.linuxPackages_latest;
        	plymouth.enable = true;
        	#initrd.kernelModules = [ "amdgpu" ];
        	supportedFilesystems = [ "ntfs" ];
          		loader = {
            			grub = {
              				enable = true;
              				version = 2;
              				device = "/dev/sda";
              				useOSProber = true;
            			};
          		};
          };

        fileSystems."/media/windows"= {
          device = "/dev/sdb3";
          fsType = "ntfs";
          options = [ "rw" "uid=alex" ];
        };
	
#	powerManagement = {
#		cpufreq.min = 3200000;
#		cpufreq.max = 4200000;
#	};

          # Enable sound.
        sound.enable = true;
        hardware = {
		cpu = {
			amd.updateMicrocode = true;
		};
          pulseaudio = {
            enable = true; 
            support32Bit = true;
          };
          opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
#            extraPackages = with pkgs; [
#              rocm-opencl-icd
#              rocm-opencl-runtime
#              amdvlk
#            ];
#            extraPackages32 = with pkgs; [
#              driversi686Linux.amdvlk
#            ];
          };
        };

        programs = {
          steam = {
            enable = true;
          };
          qt5ct.enable = true;
          sway = {
            enable = true;
            extraPackages = with pkgs; [
              swayidle
              swaylock-effects
              swaylock-fancy
              sway-contrib.grimshot
              xwayland
              waybar
              mako
              kanshi
              swaybg
              wofi
              qt5.qtwayland
              bemenu
              obs-wlrobs
              fuzzel
		grim
		slurp
		swappy
		autotiling
#		firefox-wayland
            ];
          };
          waybar.enable = true;
        };

        # Enable the X11 windowing system.
        services = {
          xserver = {
            enable = true;
            layout = "us,ru";
	    xkbModel = "pc104";
            xkbOptions = "grp:alt_shift_toggle";
            videoDrivers = [ "nvidia" ];
            deviceSection = ''
              Option "TearFree" "true"
            '';
            libinput = {
		enable = true;
		mouse = {
            		#  tapping = true;
              		accelProfile = "flat";
              		middleEmulation = false;
		};
            };
            wacom.enable = true;
            windowManager = {
              bspwm = {
                enable = true;
                configFile = "/home/alex/.dots/bspwm/bspwmrc";
                sxhkd.configFile = "/home/alex/.dots/bspwm/sxhkdrc";
              };
            };
            displayManager = {
              sddm = {
                enable = true;
              };
              lightdm = {
                enable = false;
              };
              gdm = {
                enable = false;
                wayland = true;
                #defaultSession = "Sway";
              };
            };
            desktopManager.plasma5.enable = true;
          };
#		jack.alsa.enable = true;
#		pipewire = {
#			enable = true;
#			alsa.enable = true;
#			pulse.enable = true;
#			jack.enable = true;
#		};
        };


        #Network
        networking = {
          networkmanager.enable = true;
          useDHCP = false;
          interfaces.eno1.useDHCP = true;
          hostName = "xeaal";
          firewall = {
            allowedTCPPorts = [ 7777 25565 ];
            allowedUDPPorts = [ 7777 25565 ];
          };
        };

        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";
        console = {
          font = "Lat2-Terminus16";
          keyMap = "us";
        };

        # Set your time zone.
        time.timeZone = "Asia/Yekaterinburg";

        # List packages installed in system profile. To search, run:
          environment = {
          systemPackages = with pkgs; [
            #base
#		network
#		cmake
            cpu-x
            gwenview
            rng-tools
            inteltool
            iucode-tool
            microcodeIntel
            polkit_gnome
            suidChroot
            doas
            libappindicator-gtk3
            hwdata
            qt5ct
            feh
		wineWowPackages.stable
#		wine
            networkmanager
            networkmanagerapplet
            pavucontrol
            ark
            kate
            mpd
            mpv
            killall
            pcmanfm
            #window manager
            sxhkd
            bspwm
            polybar
            kitty
            picom
            dunst
            rofi
            i3lock-fancy
            sway
            wayland
		xmonad-with-packages
            #internet
		gnunet
		libgnurl
		gnunet-gtk
            firefox-wayland
	    ungoogled-chromium
            torbrowser
            git
            qbittorrent
            discord
            element-desktop
            tdesktop
#            viber
            zoom-us
            spotify
#		nuclear
#		qMasterPassword
		qtpass
#		ripasso-cursive
#		lesspass-cli
		keepassxc
#		keeweb
#		keepassx2
#		keepassx-community
		pass
#		pass-wayland
		gnupg
		pinentry
		pinentry-qt
#		pinentry-curses
		pwgen
#		libtoxcore
#		qtox
#		ratox
#		utox
#		smack
#		psi-plus
            #gaming
            steam
		lutris
#		hedgewars
#            minecraft
            multimc
#                osu-lazer
		#coding
#		atom
		kate
		#vim
		#neovim
		spacevim
		emacs
		rustc
		rustfmt
#		kdevelop
#		qtcreator
#		rustup
		#music
#		audacity
		reaper
		carla
#		airwave
#		hydrogen
#		ardour
#		lmms
#		jack2
#		pipewire
		#bitwig-studio
            #additional software
            killall
            neofetch
            spectacle
            gimp
	    obs-studio
            winetricks
            nitrogen
            libreoffice
            qemu
            krita
            plymouth
            mesa
            vulkan-tools
            vulkan-headers
            vulkan-loader
            vulkan-validation-layers
#            vkquake
            dmidecode
            breeze-qt5
            breeze-gtk
            libwacom
            xf86_input_wacom
            wacomtablet
            gparted
            etcher
            playerctl
#            radeontools
#            radeon-profile
            w3m
		zenstates
		microcodeAmd
		zenmonitor
		linuxPackages_zen.zenpower
		linuxPackages_zen.cpupower
		polkit-kde-agent
            (
                      pkgs.writeTextFile {
                      name = "startsway";
                      destination = "/bin/startsway";
                      executable = true;
                      text =''
                      #! ${pkgs.bash}/bin/bash

                      # first import environment variables from the login manager
                      systemctl --user import-environment
                      # then start the service
                      exec systemctl --user start sway.service
                      '';
                      }
                  )

          ];
          variables = {
          #XDG_CURRENT_DESKTOP = "Unity";
			#MOZ_ENABLE_WAYLAND = "1";
                  EDITOR = "spacevim";
                  #VISUAL = "atom";
            QT_QPA_PLATFORMTHEME = "qt5ct";
            XCURSOR_THEME = "Layan-cursors";
                };
          etc = {
          	"sway/config".source = "/home/alex/.dots/sway/config";
                "xdg/waybar/config".source = "/home/alex/.dots/waybar/config";
                "xdg/waybar/style.css".source = "/home/alex/.dots/waybar/style.css";
          };
            };


          fonts = {
              fonts = (with pkgs; [
                  siji
                  comfortaa
                  font-awesome_5
                  source-code-pro
                  fantasque-sans-mono
                  iosevka
                  wqy_zenhei
                  arphic-ukai
                  arphic-uming
                  ipafont
                  gyre-fonts
                  tex-gyre-bonum-math
                  tex-gyre-pagella-math
                  tex-gyre-schola-math
                  tex-gyre-termes-math
            roboto
            roboto-mono
            fira-mono
            fira
            overpass
            fira-code
            camingo-code
            spleen
          mononoki
          monoid
          material-design-icons
      #	    nerdfonts
      #		(nerdfonts.override {
      #		fonts = [ "Mononoki" "Monoid" ];
      #		})
              ]);
          };

          # Define a user account. Don't forget to set a password with ‘passwd’.
        users = {
          users = {
            alex = {
              home = "/home/alex";
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" "audio" ];
              #packages = with pkgs; [
              #];
            };
          };
        };

        # Some programs need SUID wrappers, can be configured further or are
        # started in user sessions.
         programs.mtr.enable = true;
         programs.gnupg.agent = {
           enable = true;
           enableSSHSupport = true;
           pinentryFlavor = "qt";
         };

        # This value determines the NixOS release from which the default
        # settings for stateful data, like file locations and database versions
        # on your system were taken. It‘s perfectly fine and recommended to leave
        # this value at the release version of the first install of this system.
        # Before changing this value read the documentation for this option
        # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
        system.stateVersion = "20.03"; # Did you read the comment?

      #Nix channels (packages)

        nixpkgs = {
          config = {
            allowUnfree = true;
            allowBroken = true;
          };
        };

      #Nix settings

        nix = {
          allowedUsers = [ "alex" ];
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
          package = pkgs.nixUnstable;
        };


          systemd.user.targets.sway-session = {
          description = "Sway compositor session";
          documentation = [ "man:systemd.special(7)" ];
          bindsTo = [ "graphical-session.target" ];
          wants = [ "graphical-session-pre.target" ];
          after = [ "graphical-session-pre.target" ];
        };

        systemd.user.services.sway = {
          description = "Sway - Wayland window manager";
          documentation = [ "man:sway(5)" ];
          bindsTo = [ "graphical-session.target" ];
          wants = [ "graphical-session-pre.target" ];
          after = [ "graphical-session-pre.target" ];
          # We explicitly unset PATH here, as we want it to be set by
          # systemctl --user import-environment in startsway
          environment.PATH = lib.mkForce null;
          serviceConfig = {
            Type = "simple";
            ExecStart = ''
              ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
            '';
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };

        systemd.user.services.kanshi = {
          description = "Kanshi output autoconfig ";
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          serviceConfig = {
            # kanshi doesn't have an option to specifiy config file yet, so it looks
            # at .config/kanshi/config
            ExecStart = ''
              ${pkgs.kanshi}/bin/kanshi
            '';
            RestartSec = 5;
            Restart = "always";
          };
        };
        })
      ];
    };

	#Unfree packages
	flake-utils.lib.eachDefaultSystem = (system:
		let
			pkgs = import nixpkgs {
				config = { allowUnfree = true; };
			};
		in
		{
			defaultPackage = pkgs.mkl;
		}
	);

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

  };
}
