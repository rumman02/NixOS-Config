-- =============================================================================
-- nvim-surround — Surround management
-- =============================================================================
-- Add/delete/change surrounding pairs (quotes, parens, brackets, tags, etc.).
-- =============================================================================

return {
	"kylechui/nvim-surround",
	enabled = true,
	version = "^3.0.0",  -- pin to stable tag
	event = "VeryLazy",

	-- Custom keymaps disabled (using default surround mappings)
	keys = function()
		local surround_key1 = _G.surround_key1
		local surround_key2 = _G.surround_key2
		return {
			-- -- Uncomment to override default keymaps:
			-- { surround_key1, "<Plug>(nvim-surround-normal)", mode = "n", desc = "Surround (normal)" },
			-- { surround_key1 .. "s", "<Plug>(nvim-surround-normal-cur)", mode = "n", desc = "Surround (current line)" },
			-- { surround_key2, "<Plug>(nvim-surround-normal-line)", mode = "n", desc = "Surround (new line)" },
			-- { surround_key2 .. "S", "<Plug>(nvim-surround-normal-cur-line)", mode = "n", desc = "Surround (cur line + new line)" },
		}
	end,
	opts = {},
}
