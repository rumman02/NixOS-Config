-- =============================================================================
-- which-key.nvim — Keybinding helper popup
-- =============================================================================
-- Shows a popup with available keybindings after typing a prefix key.
-- Uses customizable replacements to clean up mapping descriptions.
-- =============================================================================

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	enabled = true,

	opts = function()
		local utils = require("lib.utils")
		local icons = require("lib.icons")

		return {
			-- ===================================================================
			-- Display preset: Helix-style (compact, bottom-right popup)
			-- ===================================================================

			preset = "helix",
			-- preset = "classic",
			delay = 0,  -- show immediately

			triggers = {
				{ "<auto>", mode = "nvxstoc" },  -- auto-detect leader-like prefixes
				{ "s", mode = "nvo" },            -- s prefix (navigation)
				{ " ", mode = "nvxstoc" },         -- space (leader)
				{ "\\", mode = "nvxstoc" },        -- backslash (localleader)
			},

			-- ===================================================================
			-- Plugin integrations
			-- ===================================================================

			plugins = {
				marks = false,                     -- don't show marks popup
				registers = false,                 -- don't show registers popup
				spelling = {
					enabled = false,
					suggestions = 20,
				},
				presets = {
					-- operators = false,
					-- motions = false,
					-- text_objects = false,
					windows = false,               -- disable <C-w> hints (we have Hydra)
					-- nav = false,
					-- z = false,
					-- g = false,
				},
			},

			-- ===================================================================
			-- Window appearance
			-- ===================================================================

			win = {
				no_overlap = false,
				-- width = 1,
				-- height = { min = 4, max = 25 },
				-- col = 0,
				-- row = math.huge,
				border = utils.ui.float.border,
				-- padding = { 0, 0 },
				title = true,
				title_pos = utils.ui.float.title_pos,
				zindex = 1000,
				-- Additional vim.wo and vim.bo options
				bo = {},
				wo = {
					-- winblend = 10,
				},
			},
			-- layout = {
			-- 	width = { min = 0 },
			-- 	spacing = 0,
			-- },

			-- ===================================================================
			-- Scroll keys
			-- ===================================================================

			keys = {
				scroll_down = "<c-d>",
				scroll_up = "<c-u>",
			},

			sort = { "local", "order", "group", "alphanum", "mod" },
			expand = 0,

			-- ===================================================================
			-- Text replacements: clean up raw key descriptions
			-- ===================================================================

			replace = {
				key = {
					{ "<Space>", "󱁐 " },
					{ "<Esc>", "󱊷 " },
					{ "<BS>", "󰁮 " },
				},
				desc = {
					-- Strip <Plug>(...) wrapper
					{ "<Plug>%(([^%)]+)%)", "%1" },   -- <Plug>(content) → content
					{ "<Plug>([^<>]+)", "%1" },        -- <Plug>content → content

					-- Clean up VM (visual-multi) prefixes
					{ "^VM%-", "" },                   -- VM-Align → Align
					{ "%-", " " },                     -- dashes → spaces

					{ "^%+", "" },
					{ "<[cC]md>", "" },
					{ "<[cC][rR]>", "" },
					{ "<[sS]ilent>", "" },
					{ "^lua%s+", "" },
					{ "^call%s+", "" },
					{ "^:%s*", "" },
				},
			},

			-- ===================================================================
			-- Icon settings
			-- ===================================================================

			icons = {
				breadcrumb = "󰊎 ",
				separator = icons.keymap.separator,
				group = "+ ",
				ellipsis = "…",
				mappings = true,
				rules = false,                       -- don't show rules column
				colors = true,                       -- color-grouped items
			},
			show_help = false,
			show_keys = false,
			disable = {
				ft = { "snacks_dashborad" },
				bt = {},
			},

			-- ===================================================================
			-- Custom group labels for leader key prefixes
			-- ===================================================================

			spec = {
				{ _G.buffer_key1, group = "Buffer" },
				{ _G.buffer_key1 .. "p", group = "Pick" },
				{ _G.buffer_key1 .. "s", group = "Sort" },
				{ _G.buffer_key1 .. "x", group = "Close" },
				{ _G.buffer_key2, group = "More..." },
				{ _G.buffer_key2 .. "s", group = "Sort" },
				{ _G.buffer_key2 .. "x", group = "Close" },

				{ _G.explorer_key1, group = "Explorer" },

				{ _G.find_key1, group = "Find" },
				{ _G.find_key2, group = "More..." },

				{ _G.window_key1, group = "Window" },
				{ _G.window_key1 .. "x", group = "Close" },

				{ _G.tab_key1, group = "Tab" },

				{ _G.format_key1, group = "Format" },

				{ _G.git_key1, group = "Git" },

				{ _G.history_key1, group = "History" },

				{ _G.git_key1, group = "Git" },
			}
		}
	end,

	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end
}
