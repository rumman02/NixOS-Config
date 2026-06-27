-- =============================================================================
-- todo-comments.nvim — Highlight TODO/FIXME/HACK/etc. comments
-- =============================================================================
-- Scans comments for special keywords and applies colored icons
-- and highlights for easy visual scanning.
-- =============================================================================

return {
	"folke/todo-comments.nvim",
	event = "BufReadPost",

	opts = {
		-- ===================================================================
		-- Keyword definitions with icons, colors, and aliases
		-- ===================================================================

		keywords = {
			FIX = {
				icon = "",
				color = "error",
				alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
			},
			TODO = { icon = "", color = "info" },
			HACK = { icon = "", color = "warning" },
			WARN = {
				icon = "",
				color = "warning",
				alt = { "WARNING", "XXX" },
			},
			PERF = {
				icon = "",
				alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
			},
			NOTE = {
				icon = "",
				color = "hint",
				alt = { "INFO" },
			},
			TEST = {
				icon = "",
				color = "test",
				alt = { "TESTING", "PASSED", "FAILED" },
			},
		},

		-- ===================================================================
		-- Visual style
		-- ===================================================================

		gui_style = {
			fg = "NONE",  -- no special font style for foreground text
			bg = "BOLD",  -- bold background for better visibility
		},
	},
}
