# ghostty.nix - DRY Home Manager configuration for Ghostty terminal
{ lib, inputs, pkgs, ... }:
let
	sharedConfig = import ../../../config.nix;

	# Helper function to generate escape sequences
	mkEscape = code: modifier: "text:\\x1b[${toString code};${toString modifier}u";

	# Helper function to create keybindings for a set of keys with different modifiers
	mkKeybindings = keys: modifierSets:
		lib.listToAttrs (lib.flatten (
			lib.mapAttrsToList (keyName: code:
				map (modSet: {
					name = "${modSet.combo}+${keyName}";
					value = mkEscape code modSet.modifier;
				}) modifierSets
			) keys
		));

	# Convert attribute set of keybindings to list format expected by Ghostty
	keybindingsToList = bindings:
		lib.mapAttrsToList (key: value: "${key}=${value}") bindings;

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
	mkFKeyEscape = fNum: modifier: "text:\\x1b[1;${toString modifier}${if fNum <= 12 then "R" else "S"}";

	# Generate F key bindings
	fKeyBindings = lib.listToAttrs (lib.flatten (
		lib.mapAttrsToList (keyName: fNum:
			map (modSet: {
				name = "${modSet.combo}+${keyName}";
				value = mkFKeyEscape fNum modSet.modifier;
			}) specialModifiers
		) fKeys
	));

	# Combine all generated keybindings
	allKeybindings = fKeyBindings
		// mkKeybindings numberKeys modifiers
		// mkKeybindings punctuationKeys modifiers
		// mkKeybindings specialKeys specialModifiers;

in {
	programs.ghostty = {
		enable = true;
		# package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
		clearDefaultKeybinds = true;
		settings = {
			# font-family = [
			#   "TX-02"
			#   "JetBrainsMono Nerd Font"
			# ];
			# font-style = "Regular";
			# font-style-bold = "Bold";
			# font-style-italic = "Oblique";
			# font-style-bold-italic = "Bold Oblique";
			# font-size = 11;
			background-opacity = 1;
			background-blur = false;
			window-theme = "auto";
			window-colorspace = "display-p3";
			# window-padding-x = "5";
			# window-padding-y = "5";
			window-padding-balance = true;
			window-padding-color = "background";
			window-decoration = "none";
			# window-vsync = true;
			# cursor-style = "bar";
			# cursor-invert-fg-bg = false;
			cursor-style-blink = false;
			adjust-cursor-thickness = 1;
			mouse-hide-while-typing = true;
			# shell-integration = "detect";
			shell-integration-features = "no-cursor";
			resize-overlay = "never";
			quick-terminal-position = "top";
			quick-terminal-screen = "main";
			scrollback-limit = sharedConfig.scrollback;
			confirm-close-surface = false;
			keybind = [
				"ctrl+shift+c=copy_to_clipboard"
				"ctrl+shift+v=paste_from_clipboard"
			] ++ keybindingsToList allKeybindings;
			custom-shader = "shaders/cursor_smear_fade.glsl";
		};
	};
	xdg.configFile."ghostty/shaders".source = ../configs/ghostty/shaders;
}


# ghostty.nix - Complete DRY Home Manager configuration for Ghostty terminal
# { lib, ... }:
# 	let
# 	sharedConfig = import ../shared.nix;
#
# 	# Helper function to generate escape sequences for regular keys
# 	mkEscape = code: modifier: "text:\\x1b[${toString code};${toString modifier}u";
#
# 	# Helper function to generate escape sequences for function keys
# 	mkFKeyEscape = fNum: modifier:
# 		let
# 			base = if fNum <= 12 then
# 				(if fNum <= 4 then toString (10 + fNum) else toString (11 + fNum))
# 			else toString (12 + fNum);
# 		in "text:\\x1b[${base};${toString modifier}~";
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
# 		in "text:\\x1b[1;${toString modifier}${keyMap.${key}}";
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
# 	# Convert internal modifier names to Ghostty key combination format
# 	modifierToCombo = {
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
# 	# Generate keybindings for a set of keys with escape sequence generator
# 	mkKeybindingsWithGen = keys: modifierSet: escapeGen:
# 		lib.listToAttrs (lib.flatten (
# 			lib.mapAttrsToList (keyName: code:
# 				lib.mapAttrsToList (modName: modCode: {
# 					name = if modifierToCombo.${modName} == "" then keyName
# 					else "${modifierToCombo.${modName}}+${keyName}";
# 					value = escapeGen code modCode;
# 				}) modifierSet
# 			) keys
# 		));
#
# 	# Regular keys that use standard escape sequences
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
# 	# Numpad keys (treated as regular keys with their own codes)
# 	numpadKeys = {
# 		kp_0 = 48;
# 		kp_1 = 49;
# 		kp_2 = 50;
# 		kp_3 = 51;
# 		kp_4 = 52;
# 		kp_5 = 53;
# 		kp_6 = 54;
# 		kp_7 = 55;
# 		kp_8 = 56;
# 		kp_9 = 57;
# 		kp_decimal = 46;
# 		kp_divide = 47;
# 		kp_multiply = 42;
# 		kp_subtract = 45;
# 		kp_add = 43;
# 		kp_enter = 13;
# 	};
#
# 	# Generate all keybindings
# 	letterBindings = mkKeybindingsWithGen letterKeys regularModifiers mkEscape;
# 	numberBindings = mkKeybindingsWithGen numberKeys regularModifiers mkEscape;
# 	punctuationBindings = mkKeybindingsWithGen punctuationKeys regularModifiers mkEscape;
# 	specialBindings = mkKeybindingsWithGen specialKeys modifiers mkEscape;
# 	functionBindings = mkKeybindingsWithGen functionKeys modifiers mkFKeyEscape;
# 	navigationBindings = mkKeybindingsWithGen navigationKeys modifiers mkNavEscape;
# 	numpadBindings = mkKeybindingsWithGen numpadKeys regularModifiers mkEscape;
#
# 	# Combine all generated keybindings
# 	allGeneratedKeybindings =
# 		letterBindings //
# 		numberBindings //
# 		punctuationBindings //
# 		specialBindings //
# 		functionBindings //
# 		navigationBindings //
# 		numpadBindings;
#
# 	# Convert keybindings to the list format expected by Ghostty
# 	keybindingsToList = bindings:
# 		lib.mapAttrsToList (key: value: "${key}=${value}") bindings;
#
# 	# Essential keybindings that should not be overridden
# 	essentialKeybindings = [
# 		"ctrl+shift+c=copy_to_clipboard"
# 		"ctrl+shift+v=paste_from_clipboard"
# 		# "ctrl+shift+n=new_window"
# 		# "ctrl+shift+t=new_tab"
# 		# "ctrl+shift+w=close_surface"
# 		# "ctrl+shift+page_up=previous_tab"
# 		# "ctrl+shift+page_down=next_tab"
# 		# "ctrl+shift+plus=increase_font_size:1"
# 		# "ctrl+shift+minus=decrease_font_size:1"
# 		# "ctrl+shift+equal=reset_font_size"
# 		# "ctrl+shift+enter=toggle_fullscreen"
# 	];
#
# 	in {
# 	programs.ghostty = {
# 		enable = true;
# 		clearDefaultKeybinds = true;
#
# 		settings = {
# 			# font-family = [
# 			#   "TX-02"
# 			#   "JetBrainsMono Nerd Font"
# 			# ];
# 			# font-style = "Regular";
# 			# font-style-bold = "Bold";
# 			# font-style-italic = "Oblique";
# 			# font-style-bold-italic = "Bold Oblique";
# 			# font-size = 11;
# 			# background-opacity = 1;
# 			window-theme = "auto";
# 			window-colorspace = "display-p3";
# 			# window-padding-x = "5";
# 			# window-padding-y = "5";
# 			window-padding-balance = true;
# 			window-padding-color = "background";
# 			window-decoration = "none";
# 			# window-vsync = true;
# 			# cursor-style = "bar";
# 			# cursor-invert-fg-bg = false;
# 			# cursor-style-blink = false;
# 			adjust-cursor-thickness = 1;
# 			mouse-hide-while-typing = true;
# 			# shell-integration = "detect";
# 			shell-integration-features = "no-cursor";
# 			resize-overlay = "never";
# 			quick-terminal-position = "top";
# 			quick-terminal-screen = "main";
# 			scrollback-limit = sharedConfig.scrollback;
# 			confirm-close-surface = false;
#
# 			# Combine essential keybindings with generated ones
# 			keybind = essentialKeybindings ++ keybindingsToList allGeneratedKeybindings;
# 		};
# 	};
#
# 	xdg.configFile."ghostty/shaders".source = ../configs/ghostty;
# }

