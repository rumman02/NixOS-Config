# In your main configuration file
{ pkgs, config, ... }: let
	submapGenerator = import ./submap-generator.nix { inherit pkgs; };
	layout = config.wayland.windowManager.hyprland.settings.general.layout;
	is_hy3 = if layout == "hy3" then "hy3:" else "";

	window_blur = pkgs.writeShellScript "window_blur" (builtins.readFile ../../../../../scripts/hyprland/window_blur.sh);
	window_border = pkgs.writeShellScript "window_border" (builtins.readFile ../../../../../scripts/hyprland/window_border.sh);
	window_gap = pkgs.writeShellScript "window_gap" (builtins.readFile ../../../../../scripts/hyprland/window_gap.sh);
	window_opacity = pkgs.writeShellScript "window_opacity" (builtins.readFile ../../../../../scripts/hyprland/window_opacity.sh);
	window_shadow = pkgs.writeShellScript "window_shadow" (builtins.readFile ../../../../../scripts/hyprland/window_shadow.sh);
	split_window = pkgs.writeShellScript "split_window" (builtins.readFile ../../../../../scripts/hyprland/split_window.sh);
	tab_window = pkgs.writeShellScript "tab_window" (builtins.readFile ../../../../../scripts/hyprland/tab_window.sh);

in rec {
	# this is linked to extraConfig
	# apps = submapGenerator {
	# 	submap_name = "[A]pps";
	# 	mod_key = "SUPER";
	# 	sub_key = "a";
	# 	parent_submap = "";
	# 	body = [
	# 		{ "[B]rowser" = "bind = , b, exec, $browser"; }
	# 		{ "[F]ile Ex." = "bind = , f, exec, $file_explorer"; }
	# 		{ "[N]ote" = "bind = , n, exec, $note"; }
	# 		{ "[M]edia Pl." = "bind = , b, exec, $media_player"; }
	# 		{ "[T]erminal" = "bind = , t, exec, $terminal"; }
	# 	];
	# };

	# this is linked to extraConfig
	window = submapGenerator {
		submap_name = "[W]indow";
		mod_key = "SUPER";
		sub_key = "w";
		parent_submap = "";
		body = [
			{ "[B]lur" = blur; }
			{ "[󰘶B]order" = border; }
			{ "[F]loat" = float; }
			{ "[G]ap" = gap; }
			{ "[M]ove" = move; }
			{ "[O]pacity" = opacity; }
			{ "[R]esize" = resize; }
			# { "[S]hadow" = shadow; }
			{ "[X]Close" = close; }
			{ "[S]orizontal" = "bind = , s, exec, ${split_window} h"; }
			{ "[󰘶S]Vertical" = "bind = shift, s, exec, ${split_window} v"; }
		];
	};

	blur = submapGenerator {
		submap_name = "[B]lur";
		mod_key = "";
		sub_key = "b";
		parent_submap = "[W]indow";
		body = [
			{ "[P]asses" = passes; }
			{ "[S]ize" = size; }
		];
	};

	passes = submapGenerator {
		submap_name = "[P]asses";
		mod_key = "";
		sub_key = "p";
		parent_submap = "[B]lur";
		body = [
			{ "[K]Inc." = "binde = , k, exec, ${window_blur} window_blur_passes_plus"; }
			{ "[J]Dec." = "binde = , j, exec, ${window_blur} window_blur_passes_minus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:blur:passes 0"; }
		];
	};

	size = submapGenerator {
		submap_name = "[S]ize";
		mod_key = "";
		sub_key = "s";
		parent_submap = "[B]lur";
		body = [
			{ "[K]Inc." = "binde = , k, exec, ${window_blur} window_blur_size_plus"; }
			{ "[J]Dec." = "binde = , j, exec, ${window_blur} window_blur_size_minus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:blur:size 0"; }
		];
	};

	opacity = submapGenerator {
		submap_name = "[O]pacity";
		mod_key = "";
		sub_key = "o";
		parent_submap = "[W]indow";
		body = [
			{ "[A]ll" = opacity_all; }
			{ "[C]urrent" = opacity_current; }
			{ "[F]ullscreen" = opacity_fullscreen; }
			{ "[O]thers" = opacity_others; }
		];
	};

	opacity_all = submapGenerator {
		submap_name = "[A]ll";
		mod_key = "";
		sub_key = "a";
		parent_submap = "[O]pacity";
		body = [
			{ "[K]Inc." = "binde = , k, exec, ${window_opacity} all_window_opacity_plus"; }
			{ "[J]Dec." = "binde = , j, exec, ${window_opacity} all_window_opacity_minus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:active_opacity 1.0; hyprctl keyword decoration:inactive_opacity 1.0; hyprctl keyword decoration:fullscreen_opacity 1.0"; }
		];
	};

	opacity_current = submapGenerator {
		submap_name = "[C]urrent";
		mod_key = "";
		sub_key = "c";
		parent_submap = "[O]pacity";
		body = [
			{ "[K]Inc." = "binde = , k, exec, ${window_opacity} active_opacity_plus"; }
			{ "[J]Dec." = "binde = , j, exec, ${window_opacity} active_opacity_minus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:active_opacity 1.0"; }
		];
	};

	opacity_fullscreen = submapGenerator {
		submap_name = "[F]ullscreen";
		mod_key = "";
		sub_key = "f";
		parent_submap = "[O]pacity";
		body = [
			{ "[K]Inc." = "binde = , k, exec, ${window_opacity} fullscreen_opacity_plus"; }
			{ "[J]Dec." = "binde = , j, exec, ${window_opacity} fullscreen_opacity_minus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:fullscreen_opacity 1.0"; }
		];
	};

	opacity_others = submapGenerator {
		submap_name = "[O]thers";
		mod_key = "";
		sub_key = "o";
		parent_submap = "[O]pacity";
		body = [
			{ "[K]Inc." = "binde = , k, exec, ${window_opacity} inactive_opacity_plus"; }
			{ "[J]Dec." = "binde = , j, exec, ${window_opacity} inactive_opacity_minus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:inactive_opacity 1.0"; }
		];
	};

	gap = submapGenerator {
		submap_name = "[G]ap";
		mod_key = "";
		sub_key = "g";
		parent_submap = "[W]indow";
		body = [
			{ "[A]ll" = gap_all; }
			{ "[I]n" = gap_in; }
			{ "[O]ut" = gap_out; }
		];
	};

	gap_all = submapGenerator {
		submap_name = "[A]ll";
		mod_key = "";
		sub_key = "a";
		parent_submap = "[G]ap";
		body = [
			{ "[H]Right Inc." = "binde = , h, exec, ${window_gap} gaps_all_increase_right"; }
			{ "[J]Top Inc." = "binde = , j, exec, ${window_gap} gaps_all_increase_top"; }
			{ "[K]Bottom Inc." = "binde = , k, exec, ${window_gap} gaps_all_increase_bottom"; }
			{ "[L]Left Inc." = "binde = , l, exec, ${window_gap} gaps_all_increase_left"; }
			{ "[󰘶H]Left Dec." = "binde = shift, h, exec, ${window_gap} gaps_all_decrease_right"; }
			{ "[󰘶J]Bottom Dec." = "binde = shift, j, exec, ${window_gap} gaps_all_decrease_top"; }
			{ "[󰘶K]Top Dec." = "binde = shift, k, exec, ${window_gap} gaps_all_decrease_bottom"; }
			{ "[󰘶L]Right Dec." = "binde = shift, l, exec, ${window_gap} gaps_all_decrease_left"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword general:gaps_in 0; hyprctl keyword general:gaps_out 0";}
		];
	};

	gap_in = submapGenerator {
		submap_name = "[I]n";
		mod_key = "";
		sub_key = "i";
		parent_submap = "[G]ap";
		body = [
			{ "[H]Right Inc." = "binde = , h, exec, ${window_gap} gaps_in_increase_right"; }
			{ "[J]Top Inc." = "binde = , j, exec, ${window_gap} gaps_in_increase_top"; }
			{ "[K]Bottom Inc." = "binde = , k, exec, ${window_gap} gaps_in_increase_bottom"; }
			{ "[L]Left Inc." = "binde = , l, exec, ${window_gap} gaps_in_increase_left"; }
			{ "[󰘶H]Left Dec." = "binde = shift, h, exec, ${window_gap} gaps_in_decrease_left"; }
			{ "[󰘶J]Bottom Dec." = "binde = shift, j, exec, ${window_gap} gaps_in_decrease_bottom"; }
			{ "[󰘶K]Top Dec." = "binde = shift, k, exec, ${window_gap} gaps_in_decrease_top"; }
			{ "[󰘶L]Right Dec." = "binde = shift, l, exec, ${window_gap} gaps_in_decrease_right"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword general:gaps_in 0";}
		];
	};

	gap_out = submapGenerator {
		submap_name = "[O]ut";
		mod_key = "";
		sub_key = "o";
		parent_submap = "[G]ap";
		body = [
			{ "[H]Right Inc." = "binde = , h, exec, ${window_gap} gaps_out_increase_right"; }
			{ "[J]Top Inc." = "binde = , j, exec, ${window_gap} gaps_out_increase_top"; }
			{ "[K]Bottom Inc." = "binde = , k, exec, ${window_gap} gaps_out_increase_bottom"; }
			{ "[L]Left Inc." = "binde = , l, exec, ${window_gap} gaps_out_increase_left"; }
			{ "[󰘶H]Left Dec." = "binde = shift, h, exec, ${window_gap} gaps_out_decrease_left"; }
			{ "[󰘶J]Bottom Dec." = "binde = shift, j, exec, ${window_gap} gaps_out_decrease_bottom"; }
			{ "[󰘶K]Top Dec." = "binde = shift, k, exec, ${window_gap} gaps_out_decrease_top"; }
			{ "[󰘶L]Right Dec." = "binde = shift, l, exec, ${window_gap} gaps_out_decrease_right"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword general:gaps_out 0";}
		];
	};

	border = submapGenerator {
		submap_name = "[B]order";
		mod_key = "shift";
		sub_key = "b";
		parent_submap = "[W]indow";
		body = [
			{ "[R]adius" = border_radius; }
			{ "[T]hickness" = border_thickness; }
		];
	};

	border_radius = submapGenerator {
		submap_name = "[R]adius";
		mod_key = "";
		sub_key = "r";
		parent_submap = "[B]order";
		body = [
			{ "[J]Dec." = "binde = , j, exec, ${window_border} border_rounding_minus"; }
			{ "[K]Inc." = "binde = , k, exec, ${window_border} border_rounding_plus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:rounding 0";}
		];
	};

	border_thickness = submapGenerator {
		submap_name = "[T]hickness";
		mod_key = "";
		sub_key = "t";
		parent_submap = "[B]order";
		body = [
			{ "[J]Dec." = "binde = , j, exec, ${window_border} border_size_minus"; }
			{ "[K]Inc." = "binde = , k, exec, ${window_border} border_size_plus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:border_size 0";}
		];
	};

	resize = submapGenerator {
		submap_name = "[R]esize";
		mod_key = "";
		sub_key = "r";
		parent_submap = "[W]indow";
		body = [
			{ "[H]Left" = "binde = , h, resizeactive, -50 0"; }
			{ "[J]Bottom" = "binde = , j, resizeactive, 0 50"; }
			{ "[K]Top" = "binde = , k, resizeactive, 0 -50"; }
			{ "[L]Right" = "binde = , l, resizeactive, 50 0"; }
			{ "[󰘶H]Left" = "binde = shift, h, resizeactive, -10 0"; }
			{ "[󰘶J]Bottom" = "binde = shift, j, resizeactive, 0 10"; }
			{ "[󰘶K]Top" = "binde = shift, k, resizeactive, 0 -10"; }
			{ "[󰘶L]Right" = "binde = shift, l, resizeactive, 10 0"; }
			{ "[F]ullscreen" = "binde = , f, fullscreen, 1"; }
			{ "[M]aximize" = "bind = , m, fullscreen, 0";}
			{ "[P]seudo" = "bind = , p, pseudo";}
		];
	};

	float = submapGenerator {
		submap_name = "[F]loat";
		mod_key = "";
		sub_key = "f";
		parent_submap = "[W]indow";
		body = [
			{ "[C]enter" = "bind = , c, exec, hyprctl dispatch setfloating; hyprctl dispatch centerwindow"; }
			{ "[P]in" = "bind = , p, exec, hyprctl dispatch setfloating; hyprctl dispatch pin"; }
			{ "[T]oggle" = "bind = , t, exec, hyprctl dispatch togglefloating"; }
		];
	};

	close = submapGenerator {
		submap_name = "[X]Close";
		mod_key = "";
		sub_key = "x";
		parent_submap = "[W]indow";
		body = [
			{ "[C]urrent" = "bind = , c, killactive"; }
			{ "[H]Left" = "bind = , h, exec, hyprctl dispatch ${is_hy3}movefocus l; hyprctl dispatch killactive; hyprctl dispatch focuscurrentorlast"; }
			{ "[J]Bottom" = "bind = , j, exec, hyprctl dispatch ${is_hy3}movefocus d; hyprctl dispatch killactive; hyprctl dispatch focuscurrentorlast"; }
			{ "[K]Top" = "bind = , k, exec, hyprctl dispatch ${is_hy3}movefocus u; hyprctl dispatch killactive; hyprctl dispatch focuscurrentorlast"; }
			{ "[L]Right" = "bind = , l, exec, hyprctl dispatch ${is_hy3}movefocus r; hyprctl dispatch killactive; hyprctl dispatch focuscurrentorlast"; }
		]++ (if layout == "hy3" then [
			{ "[A]ll" = "bind = , a, exec, hyprctl dispatch hy3:changefocus top; hyprctl dispatch hy3:killactive; hyprctl dispatch submap reset"; }
			{ "[O]thers" = "bind = , o, exec, hyprctl dispatch togglefloating; hyprctl dispatch togglefocuslayer; hyprctl dispatch hy3:changefocus top; hyprctl dispatch hy3:killactive; hyprctl dispatch hy3:changefocus bottom; hyprctl dispatch hy3:togglefocuslayer; hyprctl dispatch togglefloating; hyprctl dispatch submap reset"; }
		] else []);
	};

	shadow = submapGenerator {
		submap_name = "[S]hadow";
		mod_key = "";
		sub_key = "s";
		parent_submap = "[W]indow";
		body = [
			{ "[J]Dec." = "binde = , j, exec, ${window_shadow} window_shadow_size_minus"; }
			{ "[K]Inc." = "binde = , k, exec, ${window_shadow} window_shadow_size_plus"; }
			{ "[R]eset" = "bind = , r, exec, hyprctl keyword decoration:shadow:range 0";}
		];
	};

	move = submapGenerator {
		submap_name = "[M]ove/swap";
		mod_key = "";
		sub_key = "m";
		parent_submap = "[W]indow";
		body = [
			{ "[H]Left Mv" = "binde = , h, movewindow, l"; }
			{ "[J]Bottom Mv" = "binde = , j, movewindow, d"; }
			{ "[K]Top Mv" = "binde = , k, movewindow, u"; }
			{ "[L]Right Mv" = "binde = , l, movewindow, r"; }
		]++ (if layout != "hy3" then [
			{ "[󰘶H]Left Sw" = "binde = shift, h, swapwindow, l"; }
			{ "[󰘶J]Bottom Sw" = "binde = shift, j, swapwindow, d"; }
			{ "[󰘶K]Top Sw" = "binde = shift, k, swapwindow, u"; }
			{ "[󰘶L]Right Sw" = "binde = shift, l, swapwindow, r"; }
		] else []);
	};

	# this is linked to extraConfig
	tab = submapGenerator {
		submap_name = "[T]ab";
		mod_key = "SUPER";
		sub_key = "t";
		parent_submap = "";
		body = [
		]++ (if layout == "hy3" then [
			{ "[A]ll tab" = "bind = , a, exec, hyprctl dispatch hy3:changefocus top && hyprctl dispatch hy3:changegroup tab && hyprctl dispatch hy3:changefocus bottom"; }
			{ "[󰘶A]ll untab" = "bind = shift, a, exec, hyprctl dispatch hy3:changefocus top && hyprctl dispatch hy3:changegroup untab && hyprctl dispatch hy3:changefocus bottom"; }
			{ "[N]ew" = "bind = , n, exec,  ${tab_window}"; }
		] else []);
	};

	# this is linked to extraConfig
	prefix = submapGenerator {
		submap_name = "[P]refix";
		mod_key = "SUPER";
		sub_key = "space";
		parent_submap = "";
		body = [
			{ "[Z]Power" = power; }
		];
	};

	power = submapGenerator {
		submap_name = "[Z]Power";
		mod_key = "";
		sub_key = "z";
		parent_submap = "[P]refix";
		body = [
			{ "[L]ock" = "bind = , l, exec, $lock"; }
			{ "[R]eboot" = "bind = , r, exec, systemctl reboot"; }
			{ "[S]leep" = "bind = , s, exec, systemctl suspend"; }
			{ "[󰘶S]hutdown" = "bind = shift, s, exec, systemctl poweroff"; }
			# { "[Q]Logout" = "bind = , q, exec, uwsm stop"; }
			{ "[Q]Logout" = "bind = , q, exec, hyprctl dispatch exit"; }
		];
	};

	# this is linked to extraConfig
	test = submapGenerator {
		submap_name = "[T]est";
		mod_key = "SUPER";
		sub_key = "z";
		parent_submap = "";
		body = [
			# { "[S]wallow" = "bind = , s, toggleswallow"; }
			{ "[S]wallow" = ''bind = , s, exec, ghostty -e "$(rofi -show run -dmenu)''; }
			{ "[M]ake_group" = makegroup; }
			{ "[C]hange_group" = changegroup; }
			{ "[W]move_window" = movewindow; }
			{ "[F]change_focus" = changefocus; }
		];
	};

	makegroup = submapGenerator {
		submap_name = "[M]ake_group";
		mod_key = "";
		sub_key = "m";
		parent_submap = "[T]est";
		body = [
			{ "[H]orizontal" = "bind = , h, hy3:makegroup, h"; }
			{ "[V]ertical" = "bind = , v, hy3:makegroup, v"; }
			{ "[O]pposite" = "bind = , o, hy3:makegroup, opposite"; }
			{ "[T]ab" = "bind = , t, hy3:makegroup, tab"; }
		];
	};
	changegroup = submapGenerator {
		submap_name = "[C]hange_group";
		mod_key = "";
		sub_key = "c";
		parent_submap = "[T]est";
		body = [
			{ "[H]orizontal" = "bind = , h, hy3:changegroup, h"; }
			{ "[V]ertical" = "bind = , v, hy3:changegroup, v"; }
			{ "[O]pposite" = "bind = , o, hy3:changegroup, opposite"; }
			{ "[T]ab" = "bind = , t, hy3:changegroup, tab"; }
			{ "[U]ntab" = "bind = , u, hy3:changegroup, untab"; }
		];
	};
	movewindow = submapGenerator {
		submap_name = "[W]move_window";
		mod_key = "";
		sub_key = "w";
		parent_submap = "[T]est";
		body = [
			{ "[H]Left" = "bind = , h, hy3:movewindow, l"; }
			{ "[J]Bottom" = "bind = , j, hy3:movewindow, d"; }
			{ "[K]Top" = "bind = , k, hy3:movewindow, u"; }
			{ "[L]Right" = "bind = , l, hy3:movewindow, r"; }
		];
	};
	changefocus = submapGenerator {
		submap_name = "[F]change_focus";
		mod_key = "";
		sub_key = "f";
		parent_submap = "[T]est";
		body = [
			{ "[T]op" = "bind = , t, hy3:changefocus, top"; }
			{ "[B]ottom" = "bind = , b, hy3:changefocus, bottom"; }
			{ "[R]aise" = "bind = , r, hy3:changefocus, raise"; }
			{ "[L]ower" = "bind = , l, hy3:changefocus, lower"; }
			{ "[M]tab" = "bind = , m, hy3:changefocus, tab"; }
			{ "[N]tabnode" = "bind = , n, hy3:changefocus, tabnode"; }
		];
	};
}

