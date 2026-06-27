-- =============================================================================
-- noice.nvim — UI overlay for cmdline, messages, and notifications
-- =============================================================================
-- Replaces the default vim cmdline, command output, and message
-- display area with a nicer floating window UI.
-- =============================================================================

return {
	"folke/noice.nvim",
	enabled = true,
	event = "VeryLazy",

	opts = {
		-- Disable vim's built-in notification (noice handles it)
		notify = { enabled = false },

		-- LSP progress bar
		lsp = {
			progress = { enabled = false },
		},

		-- Message display settings
		messages = {
			enabled = true,
			view_search = false,  -- don't show "pattern not found" virtual text
		},

		-- ===================================================================
		-- Command-line appearance
		-- ===================================================================

		cmdline = {
			enabled = true,
			view = "cmdline_popup",  -- styled floating window
			format = {
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "", lang = "bash" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
				input = { view = "cmdline_input", icon = "󰲶 " },
			},
		},
	},
}
