{ pkgs, config, lib, alt, ... }: let
	color = config.lib.stylix.colors;
	brightness_value_store = pkgs.writeShellScript "brightness_value_store" (builtins.readFile ../../../../scripts/hyprland/brightness_value_store.sh);
	keymaps = import ./keymaps { inherit pkgs config; };

in {
	home.packages = with pkgs; [
		bc # used for calcualting hyprland scripts
		jq # json processor, used for rename workspaces
	];

	xdg.configFile."hypr/keymaps.conf".text = keymaps;

	wayland.windowManager.hyprland = {
		enable = true;

		# systemd.enable = true;
		plugins = with pkgs.hyprlandPlugins; [
			hy3
			# hypr-dynamic-cursors
		];
		settings = {
			"$terminal" = "ghostty";
			"$statusbar" = "waybar";
			"$browser" = "firefox";
			"$explorer" = "dolphin";
			"$menu" = "rofi -show drun";
			"$lock" = "hyprlock";
			"$mainMod" = "super";
			general = {
				# layout = "dwindle";
				layout = "hy3";
				border_size = 2;
				no_border_on_floating = false;
				gaps_in = 5;
				gaps_out = "0, 8, 8, 8";
				gaps_workspaces = 0;
				# "col.active_border" = lib.mkForce "rgb(${color.base0E}) rgb(${color.base0D}) 45deg";
				# "col.active_border" = lib.mkForce "rgb(${color.base0E}) 0x00000000 0x00000000 rgb(${color.base0E}) 30deg";
				# "col.active_border" = lib.mkForce "rgb(${color.base0E}) rgb(${color.base0D}) rgb(${color.base0D}) rgb(${color.base0E}) 30deg";
				# "col.active_border" = lib.mkForce "rgb(${color.base0D}) rgb(${color.base0E}) rgb(${color.base0E}) rgb(${color.base0D}) 30deg";
				"col.active_border" = lib.mkForce "rgb(${color.base0D})";
				"col.inactive_border" = lib.mkForce "rgb(${color.base00})";
			};
			decoration = {
				rounding = 8;
				rounding_power = 3.0;
				active_opacity = 1.0;
				inactive_opacity = 1.0;
			};
			binds = {
				workspace_back_and_forth = false;
				allow_workspace_cycles = true;
			};
			input = {
				repeat_rate = 50;
				repeat_delay = 350;
				natural_scroll = true;
				follow_mouse = 1;
			};
			group = {
				auto_group = true;
			};
			animations = {
				enabled = true;
				bezier = [
					"overshot, 0.13, 0.99, 0.29, 1.1"
					"elastic, 0.68, -0.55, 0.265, 1.55"
					"easeInOutBack, 0.68, -0.6, 0.32, 1.6"
					"easeOutBack, 0.34, 1.56, 0.64, 1"
					"smooth, 0.25, 0.46, 0.45, 0.94"
					"smoothOut, 0.36, 0, 0.66, -0.56"
					"smoothIn, 0.25, 1, 0.5, 1"
				];

				animation = [
					"windows, 1, 6, elastic, slide"
					"windowsIn, 1, 6, elastic, slide"
					"windowsOut, 1, 5, easeInOutBack, slide"
					"windowsMove, 1, 5, elastic, slide"
					"fade, 1, 10, easeOutBack"
					"workspaces, 1, 4, overshot, slidevert"
					"specialWorkspace, 1, 3, overshot, slidevert"
					"border, 1, 1, smooth"
					"borderangle, 1, 1, smooth"
				];
			};
			misc = {
				disable_hyprland_logo = true;
				disable_splash_rendering = true;
				animate_manual_resizes = false;
				animate_mouse_windowdragging = false;
				render_unfocused_fps = 120;
				# enable_swallow = true;
				# swallow_regex = [
				# 	"^(kitty)$"
				# 	"^(g|G)hostty$"
				# ];
			};
			cursor = {
				min_refresh_rate = 120;
				no_warps = true;
				enable_hyprcursor = false;
			};
			plugin = {
				# dynamic-cursors = {
				# 	enable = true;
				# 	mode = "none";
				# 	shake = {
				# 		enable = true;
				# 		limit = 1.5;
				# 	};
				# 	hyprcursor = {
				# 		resolution = 2;
				# 	};
				# };
				hy3 = {
					no_gaps_when_only = 0;
					node_collapse_policy = 1;
					group_inset = 0;
					tab_first_window = true;

					tabs = {
						height = 28;
						padding = 4;
						from_top = false;
						radius = 8;
						border_width = 2;
						render_text = true;
						text_center = true;
						# text_font = "Sans";
						text_height = 10;
						text_padding = 10;
						"col.active" = "rgb(${color.base00})";
						"col.active.border" = "rgb(${color.base0E})";
						"col.inactive" = "rgb(${color.base00})";
						"col.inactive.border" = "rgba(ffffff00)";
						"col.active.text" = "rgba(ffffffff)";
						"col.focused" = "rgba(60606040)";
						"col.focused.border" = "rgba(808080ee)";
						"col.focused.text" = "rgba(ffffffff)";
						"col.inactive.text" = "rgba(ffffffff)";
						"col.urgent" = "rgba(ff223340)";
						"col.urgent.border" = "rgba(ff2233ee)";
						"col.urgent.text" = "rgba(ffffffff)";
						"col.locked" = "rgba(90903340)";
						"col.locked.border" = "rgba(909033ee)";
						"col.locked.text" = "rgba(ffffffff)";
						blur = true;
						opacity = 1.0;
					};

					autotile = {
						enable = false;
						ephemeral_groups = true;
						trigger_width = 0;
						trigger_height = 0;
						workspaces = "all";
					};
				};
			};
			exec = [
				# "sleep 1 && hyprctl keyword source ${config.xdg.configHome}/hypr/keymaps.conf"
			];
			exec-once = [
				"waybar"
				# "kanata -c ${config.xdg.configHome}/kanata/config.kbd"
				"${brightness_value_store}"
				"hyprpaper"
			];
			# Layer rules for status bar
			layerrule = [
				"blur, $statusbar"              # Apply blur effect to status bar
				"ignorezero, $statusbar"        # Ignore zero-opacity areas on status bar

				# Rofi layer rules
				# "dimaround, rofi"                # Dim background around rofi
				# "blur, rofi"                     # Apply blur effect to rofi
				# "animation popin 90%, rofi"      # Set rofi popup animation to 90% scale
			];


			# Window rules v2 (newer syntax with more options)
			windowrulev2 = [
				# Example windowrule v2 (commented examples from config)
				# "float,class:^(kitty)$,title:^(kitty)$"

				# Fix some dragging issues with XWayland (commented example)
				# "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

				# virt manager
				# "float, center, class:(.virt-manager-wrapped)"

				# audio controller
				"float, class:^(org.pulseaudio.pavucontrol)$"
				"size 800 600, class:^(org.pulseaudio.pavucontrol)$"

				# android emulator
				"float, class:^(Emulator)$"

				# gnome-calculator
				"float, class:^(org.gnome.Calculator)$"

				# Prevent any applications from being maximized
				"suppressevent maximize, class:.*"

				# Remove right click menu blur on browsers (fixes context menu issues)
				"noblur, class:^()$, title:^()$"

				# Make file picker dialogs floating and centered
				"float, center, title:^(Open File|Open|Save|Save As|Export|Import|Choose File|Rename), class:^(.*)$"

				# XDG desktop portal windows (file pickers, etc.) - float and center
				"float, center, class:(xdg-desktop-portal-gtk)"
				"float, center, class:(xdg-desktop-portal-hyprland)"
				"float, center, class:(Xdg-desktop-portal-gtk)"      # Capitalized variant
				"float, center, class:(Xdg-desktop-portal-hyprland)" # Capitalized variant

				# Remove borders from GTK portal windows for cleaner look
				"opacity 0.0,class:^(void-window)$"
				"noborder,class:^(void-window)$"
				"noshadow,class:^(void-window)$"
				"noblur,class:^(void-window)$"
				"size 400 300,class:^(void-window)$"
				# "float,class:^(void-window)$"
			];

			# Window rules v1 (legacy syntax, still supported)
			windowrule = [
				# Example windowrule v1 (commented example from config)
				# "float, ^(kitty)$"

				# Keep browsers at full opacity (override any global transparency)
				# "opacity 1.0 override, class:(zen|librewolf|firefox|brave)"
			];
		};
		extraConfig = ''
			${keymaps}
		'';
	};
}

