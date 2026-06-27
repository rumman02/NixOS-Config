-- =============================================================================
-- conform.nvim — Code formatter
-- =============================================================================
-- Lightweight format runner that delegates to external formatters
-- (stylua, prettier, black, etc.) with LSP fallback.
-- =============================================================================

return {
	"stevearc/conform.nvim",

	-- ===================================================================
	-- Format key: <leader>Ff
	-- ===================================================================

	keys = {
		{ _G.format_key1 .. "f", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format via conform" },
	},

	opts = {
		-- Per-filetype formatter assignments
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			rust = { "rustfmt", lsp_format = "fallback" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			nix = { "nixfmt" },
		},
	},

	config = function(_, opts)
		require("conform").setup(opts)
		-- Use conform as the default formatexpr
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
