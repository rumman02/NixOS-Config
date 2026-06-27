-- =============================================================================
-- ultimate-autopairs — Auto-pairing brackets, quotes, etc.
-- =============================================================================
-- Replaces nvim-autopairs with a more feature-rich alternative.
-- Handles automatic closing of braces, quotes, and backspace cleanup.
-- =============================================================================

return {
	"altermo/ultimate-autopair.nvim",
	enabled = true,
	event = "InsertEnter",
	branch = "v0.6",
	opts = {
		bs = {
			enable = true,  -- delete matching pair on backspace
		},
	}
}
