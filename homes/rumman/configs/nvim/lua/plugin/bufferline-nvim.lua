-- =============================================================================
-- bufferline.nvim — Tab/Buffer bar
-- =============================================================================
-- Visual buffer list at the top of the editor with sorting, pinning,
-- and grouping support.
-- =============================================================================

return {
	"akinsho/bufferline.nvim",
	enabled = true,
	event = { "BufReadPre", "BufAdd", "BufNewFile" },

	-- ===================================================================
	-- Keymaps: navigation, closing, sorting, pinning
	-- ===================================================================

	keys = function()
		return {
			-- Cycle buffers
			{ "<c-s-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
			{ "<c-s-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },

			-- Go to buffer by number (Ctrl+1 through Ctrl+0 = buffer 10)
			{ "<c-1>", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Buffer 1" },
			{ "<c-2>", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Buffer 2" },
			{ "<c-3>", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Buffer 3" },
			{ "<c-4>", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Buffer 4" },
			{ "<c-5>", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Buffer 5" },
			{ "<c-6>", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Buffer 6" },
			{ "<c-7>", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Buffer 7" },
			{ "<c-8>", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Buffer 8" },
			{ "<c-9>", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Buffer 9" },
			{ "<c-0>", "<cmd>BufferLineGoToBuffer 10<cr>", desc = "Buffer 10" },

			-- Pick a buffer by single character
			{ _G.buffer_key1 .. "p", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },

			-- Close buffers
			{ _G.buffer_key1 .. "xa", function() Snacks.bufdelete.all() end, desc = "[A]ll buffers" },
			{ _G.buffer_key1 .. "xH", "<cmd>BufferLineCloseLeft<cr>", desc = "Left of current" },
			{ _G.buffer_key1 .. "xL", "<cmd>BufferLineCloseRight<cr>", desc = "Right of current" },
			{ _G.buffer_key1 .. "xo", function() Snacks.bufdelete.other() end, desc = "[O]thers" },
			{ _G.buffer_key1 .. "xp", "<cmd>BufferLinePickClose<cr>", desc = "[P]ick to close" },

			-- Sort buffers
			{ _G.buffer_key2 .. "st", "<cmd>BufferLineSortByTabs<cr>", desc = "By [T]abs" },
			{ _G.buffer_key2 .. "sd", "<cmd>BufferLineSortByDirectory<cr>", desc = "By [D]irectory" },
			{ _G.buffer_key2 .. "se", "<cmd>BufferLineSortByExtension<cr>", desc = "By [E]xtension" },
			{ _G.buffer_key2 .. "sr", "<cmd>BufferLineSortByRelativeDirectory<cr>", desc = "By [R]elative directory" },
			{ _G.buffer_key2 .. "g", "<cmd>BufferLineGroupToggle<cr>", desc = "Toggle group" },
			{ _G.buffer_key2 .. "p", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
			{ _G.buffer_key2 .. "xg", "<cmd>BufferLineGroupClose<cr>" },
		}
	end,

	dependencies = {
		{
			"tiagovla/scope.nvim",
			enabled = nixCats("bufferline"),
			keys = function()
				return {
					{ _G.buffer_key1 .. "t", "<cmd>ScopeMoveBuf<cr>", desc = "Move to tab" },
				}
			end,
			opts = {
				hooks = {
					pre_tab_leave = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabLeavePre" })
					end,
					pre_tab_enter = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabEnterPost" })
					end,
				},
			},
		},
	},

	opts = function()
		local bufferline = require("bufferline")
		local icons = require("lib.icons")

		-- local mocha = require("catppuccin.palettes").get_palette "mocha"

		return {
			-- -- Catppuccin theme integration (disabled, using default)
			-- highlights = require("catppuccin.groups.integrations.bufferline").get_theme { ... },

			options = {
				mode = "buffers",
				style_preset = {
					bufferline.style_preset.default,
					bufferline.style_preset.no_italic,
					bufferline.style_preset.no_bold,
					-- bufferline.style_preset.minimal,
				},
				themable = true,           -- allow highlight overrides
				indicator = {
					-- icon = "▎",        -- customize indicator style
					-- style = "icon",
				},
				groups = {
					items = {
						require("bufferline.groups").builtin.pinned:with({ icon = " 󰐃" }),
					},
				},
				truncate_names = false,    -- show full buffer names
				tab_size = 20,
				color_icons = true,        -- color buffer icons by filetype
				show_buffer_icons = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				show_tab_indicators = true,
				show_duplicate_prefix = true,
				persist_buffer_sort = true, -- remember manual sort order
				move_wraps_at_ends = true,  -- wrap around when cycling
				separator_style = { "", "" }, -- no separators between buffers
				-- separator_style = "slant",
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				auto_toggle_bufferline = true,
				-- Use Snacks.bufdelete for clean buffer closing
				close_command = function(n)
					Snacks.bufdelete(n)
				end,
				middle_mouse_command = function(n)
					Snacks.bufdelete(n)
				end,
				-- close_command = "bdelete! %d",
				-- left_mouse_command = "buffer %d",
				right_mouse_command = nil,
				left_mouse_command = nil,
				buffer_close_icon = " ",
				modified_icon = icons.filesystem.modified,
				close_icon = " ",
				left_trunc_marker = " ",
				right_trunc_marker = " ",
				pick = {
					alphabet = "abcdefghijklmopqrstuvwxyz",
				},
			},
		}
	end,

	config = function(_, opts)
		require("bufferline").setup(opts)
	end,
}
