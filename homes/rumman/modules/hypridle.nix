{ pkgs, ... }: let
	brightness_value_set = pkgs.writeShellScript "brightness_value_set" (builtins.readFile ../../../scripts/hypridle/brightness.sh);
in {
	# ===========================================================================
	# HYPRIDLE (HYPRLAND IDLE MANAGEMENT DAEMON)
	# ===========================================================================
	services.hypridle = {
		enable = true;
		settings = {
			# ===========================================================================
			# GENERAL SETTINGS
			# ===========================================================================
			general = {
				lock_cmd = "pidof hyprlock || hyprlock";
				before_sleep_cmd = "loginctl lock-session";
				after_sleep_cmd = "hyprctl dispatch dpms on";
				ignore_dbus_inhibit = false;
				ignore_systemd_inhibit = false;
			};

			# ===========================================================================
			# LISTENERS
			# ===========================================================================
			listener = [
				{
					timeout = builtins.floor(1.5*60); # in minutes
					on-timeout = "${brightness_value_set} on_timeout";
					on-resume = "${brightness_value_set} on_resume";
				}
				# {
				#   timeout = 1.5*60; # in minutes
				# 	on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
				# 	on-resume = "brightnessctl -rd rgb:kbd_backlight";
				# }
				{
					timeout = 3*60; # in minutes
					on-timeout = "loginctl lock-session";
				}
				{
					timeout = 5*60; # in minutes
					on-timeout = "hyprctl dispatch dpms off";
					on-resume = "hyprctl dispatch dpms on";
				}
				{
					timeout = 15*60; # in minutes
					on-timeout = "systemctl suspend";
				}
			];
		};
	};

}

