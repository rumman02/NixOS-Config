-- =============================================================================
-- nvim-spider — CamelCase-aware word motions
-- =============================================================================
-- Replaces w/e/b/ge to understand camelCase and snake_case,
-- jumping to sub-word boundaries instead of whole words.
-- =============================================================================

return {
	"chrisgrieser/nvim-spider",
	enabled = true,
	keys = {
		{ "w", "<cmd>lua require('spider').motion('w')<cr>", mode = { "n", "o", "x" } },
		{ "e", "<cmd>lua require('spider').motion('e')<cr>", mode = { "n", "o", "x" } },
		{ "b", "<cmd>lua require('spider').motion('b')<cr>", mode = { "n", "o", "x" } },
		{ "ge", "<cmd>lua require('spider').motion('ge')<cr>", desc = "Sub-word ge (spider)", mode = { "n", "o", "x" } },
	},
	opts = {},
}
