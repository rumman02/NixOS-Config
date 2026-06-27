{ homedir, username, stateversion, pkgs, inputs, ... }: {

	# ===========================================================================
	# IMPORTS
	# ===========================================================================
	imports = [
		# Base configurations
		../../stylix
		../../stylix/home.nix
		../../vm/home.nix
		../../wrap/home.nix

		# Application and environment modules
		# ./modules/bash.nix
		# ./modules/bat.nix
		./modules/btop.nix
		# ./modules/cliphist.nix
		./modules/cava.nix
		# ./modules/eza.nix
		./modules/fastfetch.nix
		./modules/fd.nix
		./modules/firefox.nix
		./modules/fzf.nix
		./modules/ghostty.nix
		./modules/git.nix
		# ./modules/helix.nix
		# ./modules/htop.nix
		# ./modules/hypridle.nix
		./modules/hyprland
		./modules/hyprpaper.nix
		./modules/hyprlock.nix
		# ./modules/kanata.nix
		# ./modules/kitty.nix
		./modules/lazygit.nix
		./modules/mpv.nix
		./modules/neovim.nix
		./modules/notification.nix
		# ./modules/qutebrowser.nix
		./modules/ripgrep.nix
		./modules/rofi.nix
		./modules/starship.nix
		./modules/usb.nix
		./modules/tmux
		./modules/waybar.nix
		./modules/yazi.nix
		# ./modules/zellij.nix
		./modules/zoxide.nix
		./modules/zsh.nix
	];

	# ===========================================================================
	# HOME MANAGER CONFIGURATION
	# ===========================================================================
	home = {
		username = username;
		homeDirectory = homedir;
		stateVersion = stateversion;

		# Integrate Zsh with Home Manager
		shell.enableZshIntegration = true;

		# User-specific packages
		packages = with pkgs; [
			# System and productivity tools
			btop
			motrix
			bitwarden-desktop
			obsidian
			gemini-cli
			# ferdium # All-in-one messaging app
			# figma-linux
			# libreoffice-qt6-fresh
			nautilus # File manager
			# notes
			# google-chrome
			# expressvpn
			# cmatrix # Fun terminal screensaver
			localsend # File sharing over local network
			gnome-calculator
			rustdesk # open sourced remote desktop like anydesk
			# upscayl # AI image upscaler
			pavucontrol # audio controller
			android-studio
			# qbittorrent
			ollama-rocm
			n8n
			discord

			# Development tools
			(python3.withPackages (ps: with ps; [
				pip
				tkinter
				# pypresence
			]))
			# nbd # Network Block Device
			# wget

			# Disk utilities
			gnome-disk-utility
		];
	};

	# ===========================================================================
	# PROGRAMS
	# ===========================================================================
	programs = {
		# Enable Home Manager
		home-manager.enable = true;
	};

	# ===========================================================================
	# XDG MIME APPS
	# ===========================================================================
	xdg = {
		configFile."wallpapers".source = "${inputs.self}/wallpapers";
		mimeApps = {
			enable = true;
			defaultApplications = {
				# Default web browser
				"text/html" = "firefox.desktop";
				"x-scheme-handler/http" = "firefox.desktop";
				"x-scheme-handler/https" = "firefox.desktop";
				"x-scheme-handler/about" = "firefox.desktop";
				"x-scheme-handler/unknown" = "firefox.desktop";

				# Default terminal emulator
				"application/x-terminal-emulator" = "ghostty.desktop";
				"x-scheme-handler/terminal" = "ghostty.desktop";
			};
		};
	};

	# ===========================================================================
	# CUSTOM SCRIPTS (EXAMPLE)
	# ===========================================================================
	# home.file = {
	# 	".local/bin/my-script".source = pkgs.writeShellScript "my-script" ''
	#   #!/bin/bash
	#   echo "Hello from home-manager script!"
	#   # ${pkgs.neofetch}/bin/neofetch
	#   '';
	# };
}

