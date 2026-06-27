-- =============================================================================
-- Lazy.nvim Plugin Manager Setup
-- =============================================================================
-- Uses the lazyCat wrapper from nixCatsUtils for nix-based plugin management.
-- =============================================================================

-- Setup nixCatsUtils for compatibility with both nix and non-nix environments
require('nixCatsUtils').setup({ non_nix_value = true })

-- NOTE: nixCats: You might want to move the lazy-lock.json file
-- Resolve the lockfile path — nix uses the unwrapped config path
local function getlockfilepath()
	if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
		return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
	else
		return vim.fn.stdpath 'config' .. '/lazy-lock.json'
	end
end

local icons = require("lib.icons")
local utils = require("lib.utils")

-- Setup lazy.nvim using lazyCat wrapper from nixCatsUtils
-- First argument: plugin spec from nixCats ("allPlugins" > "start" > "lazy.nvim")
-- Second argument: import local plugin definitions from lua/plugin/
-- Third argument: lazy.nvim options table
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible {"allPlugins", "start", "lazy.nvim"}, {
	{ import = "plugin" }
}, {
	-- Default options applied to all plugins
	defaults = {
		lazy = true,           -- defer loading until needed
		version = false,       -- always use latest, never pin to released versions
		enabled = false,       -- plugins must be explicitly enabled via nixCats
	},

	-- Colorscheme to use during install (fallback if theme not yet loaded)
	install = { --[[missing = false,]] colorscheme = { vim.g.colors_name, "havamax" } },

	lockfile = getlockfilepath(),  -- dynamic lockfile path for nix/non-nix

	-- Lazy.nvim UI appearance
	ui = {
		size = {
			width = utils.ui.float.width,    -- floating window width
			height = utils.ui.float.height,  -- floating window height
		},
		wrap = utils.options.wrap,            -- respect editor wrap setting
		border = utils.ui.float.border,       -- border style from shared config
		backdrop = utils.ui.float.backdrop,   -- semi-transparent background
		title = " Lazy Plugin Manager ",      -- window title
		title_pos = utils.ui.float.title_pos, -- title alignment
		icons = {
			-- Icons shown next to plugin attributes in the lazy UI
			cmd = " ",
			config = "󰒓 ",
			debug = "󰃤 ",
			event = "󰉁 ",
			favorite = "󰓎 ",
			ft = "󰈔 ",
			init = "󰟒 ",
			import = "󰈠 ",
			keys = "󰌆 ",
			lazy = "󰒲 ",
			loaded = icons.loading_state.loaded,     -- uses custom icon set
			not_loaded = icons.loading_state.not_loaded,
			plugin = "󰆦 ",
			runtime = "󰓅 ",
			require = "󰢱 ",
			source = "󰐤 ",
			start = "󰗍 ",
			task = "󱃔 ",
			-- Tree indentation levels for nested plugin lists
			list = {
				"",
				"  ",
				"    ",
				"      ",
			},
		},
	},

	-- Periodically check for plugin updates
	checker = {
		enabled = true,
		notify = false,      -- don't show a popup when updates are available
	},

	-- Auto-reload lazy.nvim when plugin config files change
	change_detection = {
		enabled = true,
		notify = false,      -- don't notify on config change
	},

	custom_keys = false,     -- use default keybindings for lazy UI

	-- Startup performance tuning
	performance = {
		rtp = {
			-- Built-in plugins to skip — they're not needed or cause issues
			disabled_plugins = {
				"gzip",           -- not needed (handled externally)
				"matchit",        -- enhanced % matching (not used)
				-- "matchparen",  -- disabled because it causes cursor to stay at top-left on snacks dashboard
				"netrwPlugin",    -- replaced by snacks/file explorers
				"tarPlugin",      -- not needed for tar file browsing
				"tohtml",         -- HTML export not used
				"tutor",          -- nvim tutor not needed
				"zipPlugin",      -- zip support not needed
			},
		},
	},
})
