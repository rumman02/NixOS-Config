{ pkgs, ... }:
{
	# ===========================================================================
	# NOTIFICATION DAEMON (DUNST)
	# ===========================================================================
	home.packages = with pkgs;
		[ libnotify # notification daemon library
		];

	services.dunst = {
		enable = true;
		# iconTheme = {
		# 	name = "Adwaita";
		# 	package = pkgs.adwaita-icon-theme;
		# };
		settings = {
			global = {
				# Position and geometry
				offset = "8x0";
				# origin = "top-right";
				# width = "300";
				# height = "300";

				# Visual appearance
				transparency = 10; # only works in X11
				corner_radius = 8;
				frame_width = 2;        # Border thickness
				# frame_color = "#89b4fa"; # Border color (catppuccin blue)

				# Font and text
				# font = "JetBrains Mono 10";
				format = "<b>%s</b>\n%b";

				# Behavior
				# show_age_threshold = 60;
				# idle_threshold = 120;
				# history_length = 20;
				# sticky_history = true;
				# line_height = 0;
				# separator_height = 2;
				# padding = 8;
				# horizontal_padding = 8;
				# text_icon_padding = 0;
				# separator_color = "frame";
				# sort = true;

				# Mouse interaction
				mouse_left_click = "close_current";
				mouse_middle_click = "do_action, close_current";
				mouse_right_click = "close_all";
			};

			# Urgency-based styling
			# urgency_low = {
			# 	background = "#1e1e2e";
			# 	foreground = "#cdd6f4";
			# 	timeout = 10;
			# };
			#
			# urgency_normal = {
			# 	background = "#1e1e2e";
			# 	foreground = "#cdd6f4";
			# 	timeout = 10;
			# };
			#
			# urgency_critical = {
			# 	background = "#1e1e2e";
			# 	foreground = "#f38ba8";
			# 	frame_color = "#f38ba8";
			# 	timeout = 0;
			# };
		};
	};
}