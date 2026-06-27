-- =============================================================================
-- smart-splits.nvim — Smart window resizing and swapping
-- =============================================================================
-- Provides smooth resize/swap commands used by the Hydra in global-keymaps.lua.
-- No default keymaps — keys are defined via Hydra in continous-keymaps.lua.
-- =============================================================================

return {
	"mrjones2014/smart-splits.nvim",
	enabled = true,
	version = ">=1.0.0",
	cmd = {
		"SmartResizeLeft", "SmartResizeDown", "SmartResizeUp", "SmartResizeRight",
		"SmartSwapLeft", "SmartSwapDown", "SmartSwapUp", "SmartSwapRight",
	},

	-- No default keymaps (disabled; Hydra handles these)
	keys = function()
		return {
			-- { "<c-h>", "<cmd>SmartCursorMoveLeft<cr>", desc = "Left" },
			-- { "<c-j>", "<cmd>SmartCursorMoveDown<cr>", desc = "Down" },
			-- { "<c-k>", "<cmd>SmartCursorMoveUp<cr>", desc = "Up" },
			-- { "<c-l>", "<cmd>SmartCursorMoveRight<cr>", desc = "Right" },
		}
	end,

	opts = {
		multiplexer_integration = false,  -- supports "tmux" or "wezterm" if needed
		ignored_buftypes = {
			"nofile", "quickfix", "prompt",
		},
		ignored_filetypes = {
			"NvimTree", "Trouble", "qf", "help", "TelescopePrompt",
		},
		default_amount = 3,             -- columns/lines per resize
		move_cursor_same_row = false,   -- don't keep row when swapping
		resize_mode = {
			quit_key = "<ESC>",
			resize_keys = { "h", "j", "k", "l" },
			silent = false,
			hooks = {
				on_enter = function()
					vim.notify("Entering resize mode", vim.log.levels.INFO)
				end,
				on_leave = function()
					vim.notify("Exiting resize mode", vim.log.levels.INFO)
					-- Restore buffer sizes after resizing
					require("bufresize").register()
				end,
			},
			ignored_events = { "BufEnter", "WinEnter" },
		},
		at_edge = "stop",               -- "stop", "wrap", or "require"
		cursor_follows_swapped_bufs = true,  -- cursor moves with swapped buffer
	},
	config = function(_, opts)
		require("smart-splits").setup(opts)
	end,
}
