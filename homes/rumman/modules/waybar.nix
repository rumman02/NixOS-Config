{ config, pkgs, ... }: let
	color = config.lib.stylix.colors;
	brightness_value_set = pkgs.writeShellScript "brightness_value_set" (builtins.readFile ../../../scripts/hyprland/brightness_value_set.sh);
	focus_workspace_window = pkgs.writeShellScript "focus_workspace_window" (builtins.readFile ../../../scripts/waybar/focus_workspace_window.sh);
	font = config.stylix.fonts.monospace.name;
in {
	home.packages = with pkgs; [
		gawk # used in waybar brightness script
		xdg-desktop-portal-gtk # using for waybar
	];

	programs.waybar = {
		enable = true;
		settings = {
			main_bar = {
				name = "main_bar";
				layer = "top";
				position = "top";
				height = 28;
				margin-top = 8;
				margin-left = 10;
				margin-right = 10;
				margin-bottom = 8;
				modules-left = [
					"group/group-power"
					"hyprland/workspaces"
					# "hyprland/window"
				];
				modules-center = [
				];
				modules-right = [
					"network"
					"cpu"
					"memory"
					"disk"
					"wireplumber"
					"custom/brightness"
					"clock"
				];
				"group/group-power" = {
					orientation = "horizontal";
					drawer = {
						children-class = "not-power";
						transition-left-to-right = true;
					};
					modules = [
						"custom/logo"
						"custom/lock"
						"custom/quit"
						"custom/sleep"
						"custom/reboot"
						"custom/power"
					];
				};
				"custom/logo" = {
					format = "";
					tooltip= false;
				};
				"custom/quit" = {
					format = " ";
					tooltip-format = "Logout";
					on-click = "hyprctl dispatch exit";
					# on-click = "uwsm stop";
				};
				"custom/lock" = {
					format = " ";
					tooltip-format = "Lock";
					on-click = "loginctl lock-session";
				};
				"custom/sleep" = {
					format = " 󰤄";
					tooltip-format = "Sleep";
					on-click = "systemctl suspend";
				};
				"custom/reboot" = {
					format = " ";
					tooltip-format = "Reboot";
					# on-click = "reboot";
					on-click = "systemctl reboot";
				};
				"custom/power" = {
					format = " ";
					tooltip-format = "Shutdown";
					on-click = "systemctl poweroff";
				};
				"hyprland/workspaces" = {
					on-click = "activate";
					# format = "{icon} {windows}";
					format = "{windows}";
					on-scroll-up = "hyprctl dispatch workspace e+1";
					on-scroll-down = "hyprctl dispatch workspace e-1";
					swap-icon-label = false;
					workspace-taskbar = {
						enable = true;
						icon-size = 16;
						format = "{icon}";
						update-active-window = true;
						on-click-window = "${focus_workspace_window} {address} {button}";
					};
				};
				# "hyprland/window" = {
				# 	format = "{title}";
				# 	max-length = 100;
				# 	icon = true;
				# 	icon-size = 18;
				# };
				clock = {
					interval = 60;
					# format = " {:%a, %b %d, %Y   %r}";
					# format = "{:%a, %b %d  %I:%M %p}";
					format = " {:%a, %b %d  %I:%M %p}";
					calendar = {
						mode = "month";
						mode-mon-col = 3;
						weeks-pos = "right";
						on-scroll = 1;
					};
					actions = {
						on-click = "mode";
						on-click-middle = "shift_reset";
						on-click-up = "shift_up";
						on-click-down = "shift_down";
					};
					tooltip-format = "<tt><small>{calendar}</small></tt>";
				};
				network = {
					interval = 1;
					format-ethernet = "󰈀  {bandwidthDownBits:>8}  {bandwidthUpBits:>8}";
					format-wifi = "  {bandwidthDownBits:>8}  {bandwidthUpBits:>8}";
					format-disconnected = "";
					tooltip-format-ethernet = "󰈀  {bandwidthDownBits}  {bandwidthUpBits}";
					tooltip-format-wifi = "  {bandwidthDownBits}  {bandwidthUpBits}";
					tooltip-format-disconnected = " No internet";
					on-click = "nmtui";
				};
				cpu = {
					interval = 1;
					format = " {usage:>2}%";
				};
				memory = {
					interval = 1;
					format = " {percentage:>2}%";
				};
				disk = {
					interval = 30;
					format = "󰋊 {specific_used:0.1f}G";
					unit = "GiB";
					tooltip-format = "Used {specific_used:0.1f}G  Total {specific_total:0.1f}G";
				};
				wireplumber = {
					format = "{icon} {volume}%";
					format-muted = "󰖁";
					format-icons = ["󰕿" "󰖀" "󰕾"];
					scroll-step = 5.0;
					on-click = "pavucontrol";
					on-scroll-down = "wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
					on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
				};
				"custom/brightness" = {
					interval =1;
					format = "󰃞 {}%";
					exec = "cat /tmp/brightness_value.txt";
					on-scroll-down = "${brightness_value_set} increase";
					on-scroll-up = "${brightness_value_set} decrease";
					tooltip-format = "󰃞  {}%";
				};
			};
			key_map = {
				name = "key_map";
				layer = "top";
				position = "bottom";
				height = 28;
				mode = "overlay";
				modules-center = [
					"hyprland/submap"
				];
				"hyprland/submap" = {
					actions =  {
						on-click = "hyprctl dispatch submap reset";
					};
				};
			};
		};
		style = /*css*/''
			*{
				/* font-family: "TX-02", "Anek Bangla", "JetBrainsMono Nerd Font Propo"; */
				font-family: "${font}", "JetBrainsMono Nerd Font Propo";
				font-size: 13px;
				font-weight: 500;
				margin: 0px;
				padding: 0px;
				border: 0px;
				background-color: transparent;
				/* transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94); */
			}

			.modules-left * {
				margin-right: 10px;
			}

			.modules-right * {
				margin-left: 10px;
			}

			#group-power:last-child {
				padding-right: 0px;
			}

			tooltip {
				background-color: #${color.base00};
				border-radius: 8px;
			}

			#submap,
			#group-power,
			#workspaces button,
			#window,
			#clock,
			#custom-nix-updates,
			#network,
			#cpu,
			#memory,
			#disk,
			#wireplumber,
			#custom-brightness {
				border-width: 2px;
				border-radius: 8px;
				border-style: solid;
				background-color: #${color.base00};
				padding: 0px 10px;
				color: #${color.base05};
			}

			#submap {
				padding: 0px 30px;
				border-color: #${color.base0E};
			}

			#group-power {
				border-color: #${color.base08};
				color: #${color.base05};
			}

			#workspaces * {
				margin: 0px;
				padding: 0px;
			}

			#workspaces button {
				margin-right: 10px;
				padding: 0px 10px;
				border: 2px solid transparent;
			}

			#workspaces button.active {
				border-color: #${color.base0E};
			}

			#workspaces .taskbar-window {
				padding: 0px 5px 0 5px;
			}

			#workspaces .taskbar-window.active image {
			}

			#workspaces .taskbar-window.active {
				background-color: #${color.base04};
				border-radius: 6px;
			}

			#window {
				border-color: #${color.base0D};
			}

			#network {
				border-color: #${color.base09};
			}

			#cpu {
				border-color: #${color.base0A};
			}

			#memory {
				border-color: #${color.base0B};
			}

			#disk {
				border-color: #${color.base0C};
			}

			#wireplumber {
				border-color: #${color.base0D};
			}

			#custom-brightness {
				border-color: #${color.base0E};
			}

			#clock {
				border-color: #${color.base0F};
			}

		'';
	};
}

# #workspaces button {
# 	margin-right: 10px;
# 	padding: 0px;
# 	border: 2px solid transparent;
# }
#
# #workspaces button.active {
# 	border-color: #${color.base0E};
# }
#
# #workspaces button.empty {
# 	padding: 0 10px;
# }
#
# /* #workspaces .workspace-label { */
# /* 	padding: 0px 12px 0px 20px; */
# /* 	margin-right: 0px; */
# /* 	border-radius: 6px; */
# /* } */
#
# #workspaces .taskbar-window {
# 	padding: 0px 5px;
# }

