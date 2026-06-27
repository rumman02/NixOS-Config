# {
# 	programs.kitty = {
# 		enable = true;
# 		# theme = "Catppuccin-Mocha";
# 		# font = {
# 		# 	name = "TX-02";
# 		# 	size = 11;
# 		# };
# 		shellIntegration.enableZshIntegration = true;
# 		shellIntegration.enableBashIntegration = true;
# 		shellIntegration.mode = "no-cursor";
# 		settings = {
# 			cursor_shape_unfocused = "hollow";
# 			cursor_blink_interval = "0.5 ease-out";
# 			cursor_stop_blinking_after = 0;
# 			cursor_beam_thickness = "1.5";
# 			cursor_underline_thickness = "1.5";
# 			cursor_trail = 1;
# 			disable_ligatures = "never";
# 			modify_font = "underline_position -2";
# 			# modify_font = "underline_thickness 150%";
# 			# modify_font = "strikethrough_position 2px";
# 			# modify_font = "cell_width 100%";
# 			# modify_font = "cell_height -2px";
# 			# modify_font = "baseline 3";
# 			# adjust_cell_width = "10px";
# 			# cursor_shape = "beam";
# 			cursor_trail_decay = "0.1 0.4";
# 			cursor_trail_start_threshold = 2;
# 			enabled_layout = "*";
# 			window_margin_width = 0;
# 			single_window_margin_width = 0;
# 			window_border_width = "0pt";
# 			hide_window_decorations = "yes";
# 			window_padding_width = "0 0 0 0";
# 			tab_bar_edge = "bottom";
# 			tab_bar_margin_width = "0.0";
# 			tab_bar_margin_height = "0.0 0.0";
# 			tab_bar_style = "powerline";
# 			tab_bar_align = "left";
# 			tab_bar_min_tabs = 2;
# 			tab_powerline_style = "round";
# 			tab_activity_symbol = "none";
# 			tab_title_max_length = 0;
# 			tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}";
# 			active_tab_title_template = "none";
# 			inactive_tab_font_style = "normal";
# 			# term = "xterm-256color";
# 			confirm_os_window_close = 0;
# 			# background_opacity = "1.0";
# 			background_blur = 0;
# 			scrollback_lines = 50000;
# 			wheel_scroll_multiplier = "5.0";
# 			enable_audio_bell = "no";
# 			undercurl_style = "thin-sparse";
# 			box_drawing_scale = "0.6, 0.5, 0.8, 0.8";
# 			# repaint_delay = 1;
# 			# sync_to_monitor = "yes";
# 		};
# 		# keybindings = {
# 		# 	"super" = "discard_event";
# 		# 	"ctrl+alt+k" = "scroll_line_up";
# 		# 	"ctrl+alt+j" = "scroll_line_down";
# 		#
# 		# 	"ctrl+shift+c" = "copy_to_clipboard";
# 		# 	"ctrl+shift+v" = "paste_from_clipboard";
# 		# };
# 		# extraConfig = ''
# 		# 	clear_all_shortcuts yes
# 		# 	kitty_mod ctrl+alt
# 		# 	symbol_map U+2591,U+2592,U+2593 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e5fa-U+e6b7 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e700-U+e8ef JetBrainsMono Nerd Font
# 		# 	symbol_map U+ed00-U+f2ff JetBrainsMono Nerd Font
# 		# 	symbol_map U+e200-U+e2a9 JetBrainsMono Nerd Font
# 		# 	symbol_map U+f0001-U+f1af0 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e300-U+e3e3 JetBrainsMono Nerd Font
# 		# 	symbol_map U+f400-U+f533 JetBrainsMono Nerd Font
# 		# 	symbol_map U+2665 JetBrainsMono Nerd Font
# 		# 	symbol_map U+26A1 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e0a0-U+e0a2 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e0b0-U+e0b3 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e0b4-U+e0c8 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e0cc-U+e0d7 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e0a3 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e0ca JetBrainsMono Nerd Font
# 		# 	symbol_map U+23fb-U+23fe JetBrainsMono Nerd Font
# 		# 	symbol_map U+2b58 JetBrainsMono Nerd Font
# 		# 	symbol_map U+f300-U+f381 JetBrainsMono Nerd Font
# 		# 	symbol_map U+e000-U+e00a JetBrainsMono Nerd Font
# 		# 	symbol_map U+ea60-U+ec1e JetBrainsMono Nerd Font
# 		# 	symbol_map U+276c-U+2771 JetBrainsMono Nerd Font
# 		# 	symbol_map U+2500-U+259f JetBrainsMono Nerd Font
# 		# 	symbol_map U+ee00-U+ee0b JetBrainsMono Nerd Font
# 		# '';
# 	};
# }


# kitty.nix - DRY Home Manager configuration for Kitty terminal
{ lib, ... }:
let
	sharedConfig = import ../../../config.nix;

	# Helper function to generate escape sequences for Kitty
	mkEscape = code: modifier: "\\x1b[${toString code};${toString modifier}u";

	# Helper function to create keybindings for a set of keys with different modifiers
	mkKeybindings = keys: modifierSets:
		lib.listToAttrs (lib.flatten (
			lib.mapAttrsToList (keyName: code:
				map (modSet: {
					name = "${modSet.combo}+${keyName}";
					value = "send_text all ${mkEscape code modSet.modifier}";
				}) modifierSets
			) keys
		));

	# Define modifier combinations
	modifiers = [
		{ combo = "ctrl"; modifier = 5; }
		{ combo = "ctrl+shift"; modifier = 6; }
		{ combo = "alt+shift"; modifier = 4; }
		{ combo = "ctrl+alt"; modifier = 7; }
		{ combo = "ctrl+alt+shift"; modifier = 8; }
	];

	# Define number keys (0-9) with their ASCII codes
	numberKeys = lib.listToAttrs (map (n: {
		name = toString n;
		value = 48 + n;  # ASCII codes: 0=48, 1=49, ..., 9=57
	}) (lib.range 0 9));

	# Define punctuation keys with their ASCII codes
	punctuationKeys = {
		"comma" = 44;
		"period" = 46;
		"slash" = 47;
		"semicolon" = 59;
		"apostrophe" = 39;
		"left_bracket" = 91;
		"right_bracket" = 93;
		"backslash" = 92;
		"minus" = 45;
		"equal" = 61;
		"grave_accent" = 96;
	};

	# Define special keys with their ASCII codes
	specialKeys = {
		"enter" = 13;
		"tab" = 9;
		"backspace" = 127;
		"escape" = 27;
		"space" = 32;
	};

	# Special modifiers for special keys (includes shift, alt, etc.)
	specialModifiers = [
		{ combo = "shift"; modifier = 2; }
		{ combo = "alt"; modifier = 3; }
		{ combo = "alt+shift"; modifier = 4; }
		{ combo = "ctrl"; modifier = 5; }
		{ combo = "ctrl+shift"; modifier = 6; }
		{ combo = "ctrl+alt"; modifier = 7; }
		{ combo = "ctrl+alt+shift"; modifier = 8; }
	];

	# Define F keys (F1-F24) - these use a different escape sequence pattern
	fKeys = lib.listToAttrs (map (n: {
		name = "f${toString n}";
		value = n;
	}) (lib.range 1 24));

	# Helper function for F key escape sequences (different pattern than regular keys)
	mkFKeyEscape = fNum: modifier: "\\x1b[1;${toString modifier}${if fNum <= 12 then "R" else "S"}";

	# Generate F key bindings
	fKeyBindings = lib.listToAttrs (lib.flatten (
		lib.mapAttrsToList (keyName: fNum:
			map (modSet: {
				name = "${modSet.combo}+${keyName}";
				value = "send_text all ${mkFKeyEscape fNum modSet.modifier}";
			}) specialModifiers
		) fKeys
	));

	# Combine all generated keybindings
	allKeybindings = fKeyBindings
		// mkKeybindings numberKeys modifiers
		// mkKeybindings punctuationKeys modifiers
		// mkKeybindings specialKeys specialModifiers;

	# Essential keybindings that should use Kitty's native actions
	essentialKeybindings = {
		"ctrl+shift+c" = "copy_to_clipboard";
		"ctrl+shift+v" = "paste_from_clipboard";
	};

	# Combine essential bindings with generated ones
	finalKeybindings = essentialKeybindings // allKeybindings;

in {
	programs.kitty = {
		enable = true;
		# theme = "Catppuccin-Mocha";
		# font = {
		#   name = "TX-02";
		#   size = 11;
		# };
		shellIntegration.enableZshIntegration = true;
		shellIntegration.enableBashIntegration = true;
		shellIntegration.mode = "no-cursor";
		settings = {
			cursor_shape_unfocused = "hollow";
			cursor_blink_interval = "0.5 ease-out";
			cursor_stop_blinking_after = 0;
			cursor_beam_thickness = "1.5";
			cursor_underline_thickness = "1.5";
			cursor_trail = 1;
			disable_ligatures = "never";
			modify_font = "underline_position -2";
			# modify_font = "underline_thickness 150%";
			# modify_font = "strikethrough_position 2px";
			# modify_font = "cell_width 100%";
			# modify_font = "cell_height -2px";
			# modify_font = "baseline 3";
			# adjust_cell_width = "10px";
			# cursor_shape = "beam";
			cursor_trail_decay = "0.1 0.4";
			cursor_trail_start_threshold = 2;
			window_margin_width = 0;
			single_window_margin_width = 0;
			window_border_width = "0pt";
			hide_window_decorations = "yes";
			window_padding_width = "0 0 0 0";
			tab_bar_edge = "bottom";
			tab_bar_margin_width = "0.0";
			tab_bar_margin_height = "0.0 0.0";
			tab_bar_style = "powerline";
			tab_bar_align = "left";
			tab_bar_min_tabs = 2;
			tab_powerline_style = "round";
			tab_activity_symbol = "none";
			tab_title_max_length = 0;
			tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}";
			active_tab_title_template = "none";
			inactive_tab_font_style = "normal";
			# term = "xterm-256color";
			confirm_os_window_close = 0;
			# background_opacity = "1.0";
			background_blur = 0;
			scrollback_lines = sharedConfig.scrollback;
			wheel_scroll_multiplier = "5.0";
			enable_audio_bell = "no";
			undercurl_style = "thin-sparse";
			box_drawing_scale = "0.6, 0.5, 0.8, 0.8";
			# repaint_delay = 1;
			# sync_to_monitor = "yes";
		};

		keybindings = finalKeybindings;

		extraConfig = ''
	  # clear_all_shortcuts yes
	  kitty_mod ctrl+alt

	  # Symbol mappings for Nerd Font icons
	  symbol_map U+2591,U+2592,U+2593 JetBrainsMono Nerd Font
	  symbol_map U+e5fa-U+e6b7 JetBrainsMono Nerd Font
	  symbol_map U+e700-U+e8ef JetBrainsMono Nerd Font
	  symbol_map U+ed00-U+f2ff JetBrainsMono Nerd Font
	  symbol_map U+e200-U+e2a9 JetBrainsMono Nerd Font
	  symbol_map U+f0001-U+f1af0 JetBrainsMono Nerd Font
	  symbol_map U+e300-U+e3e3 JetBrainsMono Nerd Font
	  symbol_map U+f400-U+f533 JetBrainsMono Nerd Font
	  symbol_map U+2665 JetBrainsMono Nerd Font
	  symbol_map U+26A1 JetBrainsMono Nerd Font
	  symbol_map U+e0a0-U+e0a2 JetBrainsMono Nerd Font
	  symbol_map U+e0b0-U+e0b3 JetBrainsMono Nerd Font
	  symbol_map U+e0b4-U+e0c8 JetBrainsMono Nerd Font
	  symbol_map U+e0cc-U+e0d7 JetBrainsMono Nerd Font
	  symbol_map U+e0a3 JetBrainsMono Nerd Font
	  symbol_map U+e0ca JetBrainsMono Nerd Font
	  symbol_map U+23fb-U+23fe JetBrainsMono Nerd Font
	  symbol_map U+2b58 JetBrainsMono Nerd Font
	  symbol_map U+f300-U+f381 JetBrainsMono Nerd Font
	  symbol_map U+e000-U+e00a JetBrainsMono Nerd Font
	  symbol_map U+ea60-U+ec1e JetBrainsMono Nerd Font
	  symbol_map U+276c-U+2771 JetBrainsMono Nerd Font
	  symbol_map U+2500-U+259f JetBrainsMono Nerd Font
	  symbol_map U+ee00-U+ee0b JetBrainsMono Nerd Font
		'';
	};

	# Copy shaders/themes if they exist (adjust path as needed)
	# xdg.configFile."kitty/themes".source = ../configs/kitty;
}


# { lib, ... }:
# let
# 	sharedConfig = import ../shared.nix;
#
# 	# Helper function to generate escape sequences for regular keys (similar to Ghostty)
# 	mkEscape = code: modifier: "\\x1b[${toString code};${toString modifier}u";
#
# 	# Helper function to generate escape sequences for function keys
# 	mkFKeyEscape = fNum: modifier:
# 		let
# 			base = if fNum <= 12 then
# 				(if fNum <= 4 then toString (10 + fNum) else toString (11 + fNum))
# 			else toString (12 + fNum);
# 		in "\\x1b[${base};${toString modifier}~";
#
# 	# Helper function to generate escape sequences for arrow/navigation keys
# 	mkNavEscape = key: modifier:
# 		let
# 			keyMap = {
# 				"up" = "A";
# 				"down" = "B";
# 				"right" = "C";
# 				"left" = "D";
# 				"home" = "H";
# 				"end" = "F";
# 				"page_up" = "5~";
# 				"page_down" = "6~";
# 				"insert" = "2~";
# 				"delete" = "3~";
# 			};
# 		in "\\x1b[1;${toString modifier}${keyMap.${key}}";
#
# 	# Define all modifier combinations with their numeric codes
# 	modifiers = {
# 		none = 1;
# 		shift = 2;
# 		alt = 3;
# 		alt_shift = 4;
# 		ctrl = 5;
# 		ctrl_shift = 6;
# 		ctrl_alt = 7;
# 		ctrl_alt_shift = 8;
# 		super = 9;
# 		super_shift = 10;
# 		super_alt = 11;
# 		super_alt_shift = 12;
# 		super_ctrl = 13;
# 		super_ctrl_shift = 14;
# 		super_ctrl_alt = 15;
# 		super_ctrl_alt_shift = 16;
# 	};
#
# 	# Convert internal modifier names to Kitty key combination format
# 	modifierToKittyCombo = {
# 		none = "";
# 		shift = "shift";
# 		alt = "alt";
# 		alt_shift = "alt+shift";
# 		ctrl = "ctrl";
# 		ctrl_shift = "ctrl+shift";
# 		ctrl_alt = "ctrl+alt";
# 		ctrl_alt_shift = "ctrl+alt+shift";
# 		super = "super";
# 		super_shift = "super+shift";
# 		super_alt = "super+alt";
# 		super_alt_shift = "super+alt+shift";
# 		super_ctrl = "super+ctrl";
# 		super_ctrl_shift = "super+ctrl+shift";
# 		super_ctrl_alt = "super+ctrl+alt";
# 		super_ctrl_alt_shift = "super+ctrl+alt+shift";
# 	};
#
# 	# Generate keybindings for sending escape sequences
# 	mkEscapeKeybindings = keys: modifierSet: escapeGen:
# 		lib.listToAttrs (lib.flatten (
# 			lib.mapAttrsToList (keyName: code:
# 				lib.mapAttrsToList (modName: modCode:
# 					let
# 						keyCombo = if modifierToKittyCombo.${modName} == "" then keyName
# 						else "${modifierToKittyCombo.${modName}}+${keyName}";
# 						escapeSeq = escapeGen code modCode;
# 					in {
# 						name = keyCombo;
# 						value = "send_text all ${escapeSeq}";
# 					}
# 				) modifierSet
# 			) keys
# 		));
#
# 	# Regular keys that use standard escape sequences (excluding none modifier for most)
# 	regularModifiers = lib.filterAttrs (n: v: n != "none") modifiers;
#
# 	# Letter keys (a-z) with their ASCII codes
# 	letterKeys = lib.listToAttrs (map (n: {
# 		name = lib.toLower (lib.substring n 1 "abcdefghijklmnopqrstuvwxyz");
# 		value = 97 + n; # ASCII: a=97, b=98, etc.
# 	}) (lib.range 0 25));
#
# 	# Number keys (0-9) with their ASCII codes
# 	numberKeys = lib.listToAttrs (map (n: {
# 		name = toString n;
# 		value = 48 + n; # ASCII: 0=48, 1=49, etc.
# 	}) (lib.range 0 9));
#
# 	# Punctuation and symbol keys
# 	punctuationKeys = {
# 		comma = 44;           # ,
# 		period = 46;          # .
# 		slash = 47;           # /
# 		semicolon = 59;       # ;
# 		apostrophe = 39;      # '
# 		left_bracket = 91;    # [
# 		right_bracket = 93;   # ]
# 		backslash = 92;       # \
# 		minus = 45;           # -
# 		equal = 61;           # =
# 		grave_accent = 96;    # `
# 	};
#
# 	# Special keys that need different handling
# 	specialKeys = {
# 		enter = 13;
# 		tab = 9;
# 		backspace = 127;
# 		escape = 27;
# 		space = 32;
# 	};
#
# 	# Function keys F1-F24
# 	functionKeys = lib.listToAttrs (map (n: {
# 		name = "f${toString n}";
# 		value = n;
# 	}) (lib.range 1 24));
#
# 	# Navigation and editing keys
# 	navigationKeys = {
# 		up = "up";
# 		down = "down";
# 		left = "left";
# 		right = "right";
# 		home = "home";
# 		end = "end";
# 		page_up = "page_up";
# 		page_down = "page_down";
# 		insert = "insert";
# 		delete = "delete";
# 	};
#
# 	# Generate all escape sequence keybindings
# 	letterEscapeBindings = mkEscapeKeybindings letterKeys regularModifiers mkEscape;
# 	numberEscapeBindings = mkEscapeKeybindings numberKeys regularModifiers mkEscape;
# 	punctuationEscapeBindings = mkEscapeKeybindings punctuationKeys regularModifiers mkEscape;
# 	specialEscapeBindings = mkEscapeKeybindings specialKeys modifiers mkEscape;
# 	functionEscapeBindings = mkEscapeKeybindings functionKeys modifiers mkFKeyEscape;
# 	navigationEscapeBindings = mkEscapeKeybindings navigationKeys modifiers mkNavEscape;
#
# 	# Combine all generated escape sequence keybindings
# 	allEscapeKeybindings =
# 		letterEscapeBindings //
# 		numberEscapeBindings //
# 		punctuationEscapeBindings //
# 		specialEscapeBindings //
# 		functionEscapeBindings //
# 		navigationEscapeBindings;
#
# 	# Essential Kitty keybindings that should not be overridden
# 	essentialKeybindings = {
# 		"ctrl+shift+c" = "copy_to_clipboard";
# 		"ctrl+shift+v" = "paste_from_clipboard";
# 		# "ctrl+shift+n" = "new_os_window";
# 		# "ctrl+shift+t" = "new_tab";
# 		# "ctrl+shift+w" = "close_tab";
# 		# "ctrl+shift+page_up" = "move_tab_backward";
# 		# "ctrl+shift+page_down" = "move_tab_forward";
# 		# "ctrl+tab" = "next_tab";
# 		# "ctrl+shift+tab" = "previous_tab";
# 		# "ctrl+shift+plus" = "change_font_size all +1.0";
# 		# "ctrl+shift+minus" = "change_font_size all -1.0";
# 		# "ctrl+shift+equal" = "change_font_size all 0";
# 		# "ctrl+shift+enter" = "toggle_fullscreen";
# 		# "ctrl+shift+f" = "show_scrollback";
# 		# "ctrl+alt+k" = "scroll_line_up";
# 		# "ctrl+alt+j" = "scroll_line_down";
# 		# "ctrl+shift+k" = "scroll_page_up";
# 		# "ctrl+shift+j" = "scroll_page_down";
# 		# "ctrl+shift+home" = "scroll_home";
# 		# "ctrl+shift+end" = "scroll_end";
# 	};
#
# 	# Filter out conflicting keybindings to prioritize essential ones
# 	filteredEscapeKeybindings = lib.filterAttrs (key: value:
# 		!essentialKeybindings ? ${key}
# 	) allEscapeKeybindings;
#
# 	# Combine essential and escape sequence keybindings
# 	allKeybindings = essentialKeybindings // filteredEscapeKeybindings;
#
# in {
# 	programs.kitty = {
# 		enable = true;
# 		# theme = "Catppuccin-Mocha";
# 		# font = {
# 		#   name = "TX-02";
# 		#   size = 11;
# 		# };
# 		shellIntegration.enableZshIntegration = true;
# 		shellIntegration.enableBashIntegration = true;
# 		shellIntegration.mode = "no-cursor";
#
# 		settings = {
# 			cursor_shape_unfocused = "hollow";
# 			cursor_blink_interval = "0.5 ease-out";
# 			cursor_stop_blinking_after = 0;
# 			cursor_beam_thickness = "1.5";
# 			cursor_underline_thickness = "1.5";
# 			cursor_trail = 1;
# 			disable_ligatures = "never";
# 			modify_font = "underline_position -2";
# 			cursor_trail_decay = "0.1 0.4";
# 			cursor_trail_start_threshold = 2;
# 			enabled_layout = "*";
# 			window_margin_width = 0;
# 			single_window_margin_width = 0;
# 			window_border_width = "0pt";
# 			hide_window_decorations = "yes";
# 			window_padding_width = "0 0 0 0";
# 			tab_bar_edge = "bottom";
# 			tab_bar_margin_width = "0.0";
# 			tab_bar_margin_height = "0.0 0.0";
# 			tab_bar_style = "powerline";
# 			tab_bar_align = "left";
# 			tab_bar_min_tabs = 2;
# 			tab_powerline_style = "round";
# 			tab_activity_symbol = "none";
# 			tab_title_max_length = 0;
# 			tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}";
# 			active_tab_title_template = "none";
# 			inactive_tab_font_style = "normal";
# 			confirm_os_window_close = 0;
# 			background_blur = 0;
# 			scrollback_lines = sharedConfig.scrollback or 50000;
# 			wheel_scroll_multiplier = "5.0";
# 			enable_audio_bell = "no";
# 			undercurl_style = "thin-sparse";
# 			box_drawing_scale = "0.6, 0.5, 0.8, 0.8";
# 		};
#
# 		# Apply all generated keybindings
# 		keybindings = allKeybindings;
#
# 		extraConfig = ''
# 	  # Clear all default shortcuts to have full control
# 	  clear_all_shortcuts yes
#
# 	  # Enable advanced key handling similar to Ghostty
# 	  # This allows for more complex key combinations and escape sequences
#
# 	  # Symbol mappings for Nerd Font compatibility
# 	  symbol_map U+2591,U+2592,U+2593 JetBrainsMono Nerd Font
# 	  symbol_map U+e5fa-U+e6b7 JetBrainsMono Nerd Font
# 	  symbol_map U+e700-U+e8ef JetBrainsMono Nerd Font
# 	  symbol_map U+ed00-U+f2ff JetBrainsMono Nerd Font
# 	  symbol_map U+e200-U+e2a9 JetBrainsMono Nerd Font
# 	  symbol_map U+f0001-U+f1af0 JetBrainsMono Nerd Font
# 	  symbol_map U+e300-U+e3e3 JetBrainsMono Nerd Font
# 	  symbol_map U+f400-U+f533 JetBrainsMono Nerd Font
# 	  symbol_map U+2665 JetBrainsMono Nerd Font
# 	  symbol_map U+26A1 JetBrainsMono Nerd Font
# 	  symbol_map U+e0a0-U+e0a2 JetBrainsMono Nerd Font
# 	  symbol_map U+e0b0-U+e0b3 JetBrainsMono Nerd Font
# 	  symbol_map U+e0b4-U+e0c8 JetBrainsMono Nerd Font
# 	  symbol_map U+e0cc-U+e0d7 JetBrainsMono Nerd Font
# 	  symbol_map U+e0a3 JetBrainsMono Nerd Font
# 	  symbol_map U+e0ca JetBrainsMono Nerd Font
# 	  symbol_map U+23fb-U+23fe JetBrainsMono Nerd Font
# 	  symbol_map U+2b58 JetBrainsMono Nerd Font
# 	  symbol_map U+f300-U+f381 JetBrainsMono Nerd Font
# 	  symbol_map U+e000-U+e00a JetBrainsMono Nerd Font
# 	  symbol_map U+ea60-U+ec1e JetBrainsMono Nerd Font
# 	  symbol_map U+276c-U+2771 JetBrainsMono Nerd Font
# 	  symbol_map U+2500-U+259f JetBrainsMono Nerd Font
# 	  symbol_map U+ee00-U+ee0b JetBrainsMono Nerd Font
# 		'';
# 	};
# }

