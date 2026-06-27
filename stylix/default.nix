{ pkgs, config, ... }: {
	stylix = {
		enable = true;
		autoEnable = true; # by default all apps should integrated with stylix
		polarity = "dark";
		base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
		image = ../wallpapers/vimal-s-GBg3jyGS-Ug-unsplash;
		# image = pkgs.fetchurl {
		# 	url = "https://w.wallhaven.cc/full/yq/wallhaven-yq8x8d.jpg";
		# 	hash = "sha256-vn/XKDlbNczeC8RY/X8MR0IXs2pjlp7fRsi5tb5NesM=";
		# };
		cursor = {
			# package = pkgs.catppuccin-cursors.mochaMauve;
			# name = "catppuccin-mocha-mauve-cursors";
			package = pkgs.bibata-cursors;
			name = "Bibata-Modern-Classic";
			# name = "Bibata-Modern-Amber";
			# package = pkgs.google-cursor;
			# name = "GoogleDot-White";
			# package = pkgs.apple-cursor;
			# name = "macOS";
			size = 24;
		};
		fonts = {
			serif = {
				# name = "Iosevka Nerd Font Propo";
				name = "TX-02";
				# name = "SF Pro Display";
			};
			sansSerif = config.stylix.fonts.serif;
			monospace = {
				# name = "Iosevka Nerd Font Propo";
				name = "TX-02";
			};
			emoji = {
				package = pkgs.noto-fonts-color-emoji;
				name = "Noto Color Emoji";
			};
			sizes = {
				applications = 10;
				terminal = 11;
				desktop = 10;
				popups = 10;
			};
		};
	};
}

