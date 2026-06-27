{
	programs.wezterm = {
		enable = true;
		enableZshIntegration = true;
		extraConfig = ''
	  -- ===========================================================================
	  -- WEZTERM CONFIGURATION
	  -- ===========================================================================
	  local wezterm = require("wezterm")
	  local config = {}

	  -- ===========================================================================
	  -- FONTS
	  -- ===========================================================================
	  config.font = wezterm.font {
		family = "JetBrainsMono NF",
		weight = "Regular"
	  }
	  config.font_size = 10.5
	  config.bold_brightens_ansi_colors = "BrightAndBold"
	  config.freetype_render_target = "Normal"

	  -- ===========================================================================
	  -- DECORATIONS
	  -- ===========================================================================
	  config.enable_tab_bar = false
	  config.window_decorations = "RESIZE"
	  config.window_padding = { left = 0, top = 0, right = 0, bottom = 0 }
	  config.cell_width = 1.0
	  config.line_height = 1.0

	  -- ===========================================================================
	  -- CURSOR
	  -- ===========================================================================
	  config.default_cursor_style = "BlinkingBlock"
	  config.cursor_blink_rate = 500
	  config.cursor_blink_ease_in = "Linear"
	  config.cursor_blink_ease_out = "Linear"
	  config.hide_mouse_cursor_when_typing = true

	  -- ===========================================================================
	  -- APPEARANCE
	  -- ===========================================================================
	  config.window_background_opacity = 1.0
	  config.text_background_opacity = 1.0
	  config.macos_window_background_blur = 100

	  -- ===========================================================================
	  -- SETTINGS
	  -- ===========================================================================
	  config.max_fps = 120
	  config.animation_fps = 120
	  config.front_end = "OpenGL"
	  config.enable_wayland = false
	  config.audible_bell = "Disabled"
	  config.check_for_updates = false
	  config.enable_scroll_bar = false
	  config.enable_kitty_keyboard = true
	  config.use_resize_increments = true
	  config.warn_about_missing_glyphs = true
	  config.automatically_reload_config = true
	  config.disable_default_key_bindings = true
	  config.window_close_confirmation = "NeverPrompt"
	  config.adjust_window_size_when_changing_font_size = false

	  -- ===========================================================================
	  -- THEME
	  -- ===========================================================================
	  config.color_scheme = "Catppuccin Mocha"

	  -- ===========================================================================
	  -- KEYMAPS
	  -- ===========================================================================
	  -- This function generates key mappings for wezterm to send escape codes
	  -- for various key combinations. This is useful for applications like
	  -- Neovim to distinguish between different key presses (e.g., Ctrl+a vs. a).
	  local function generate_key_mappings()
		  local SendString = wezterm.action.SendString

		  -- Helper function to create a key mapping.
		  local function map_key(key, mods, code)
			  return { key = key, mods = mods, action = SendString(code) }
		  end

		  -- Define number keys and their ASCII codes.
		  local keycodes_num = {
			  ['0'] = 48, ['1'] = 49, ['2'] = 50, ['3'] = 51, ['4'] = 52,
			  ['5'] = 53, ['6'] = 54, ['7'] = 55, ['8'] = 56, ['9'] = 57,
		  }

		  -- Define modifier combinations.
		  local mods_codes = {
			  CTRL = 5, ALT = 3, SHIFT = 2,
			  ["CTRL|SHIFT"] = 6, ["ALT|SHIFT"] = 4,
			  ["CTRL|ALT"] = 7, ["CTRL|ALT|SHIFT"] = 8,
		  }

		  local mappings = {}

		  -- Generate mappings for number keys with modifiers.
		  for key, code in pairs(keycodes_num) do
			  for mods, mod_code in pairs(mods_codes) do
				  table.insert(mappings, map_key(key, mods, string.format('\x1b[%d;%du', code, mod_code)))
			  end
		  end

		  -- Define symbol keys and their ASCII codes.
		  local symbols = {
			  [','] = 44, ['.'] = 46, ['/'] = 47, [';'] = 59, ["'"] = 39,
			  ['['] = 91, [']'] = 93, ['\'] = 92, ['-'] = 45, ['='] = 61, ['`'] = 96,
		  }

		  -- Generate mappings for symbol keys with modifiers.
		  for key, code in pairs(symbols) do
			  for mods, mod_code in pairs(mods_codes) do
				  table.insert(mappings, map_key(key, mods, string.format('\x1b[%d;%du', code, mod_code)))
			  end
		  end

		  -- Define special keys and their ASCII codes.
		  local special_keys = {
			  Enter = 13, Tab = 9, Backspace = 127, Escape = 27, Space = 32,
		  }

		  -- Define special modifier combinations.
		  local special_mods = {
			  SHIFT = 2, ALT = 3, ["ALT|SHIFT"] = 4,
		  }

		  -- Generate mappings for special keys with modifiers.
		  for key, code in pairs(special_keys) do
			  for mods, mod_code in pairs(special_mods) do
				  table.insert(mappings, map_key(key, mods, string.format('\x1b[%d;%du', code, mod_code)))
			  end
		  end

		  return mappings
	  end
	  config.keys = generate_key_mappings()

	  return config
		'';
	};
}

