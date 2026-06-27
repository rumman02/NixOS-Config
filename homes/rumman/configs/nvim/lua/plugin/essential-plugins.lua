-- =============================================================================
-- Essential Plugins (Dependencies)
-- =============================================================================
-- Shared utility plugins that other plugins depend on.
-- =============================================================================

return {
	{
		-- plenary: general async utilities required by many plugins
		"nvim-lua/plenary.nvim",
	},
	{
		-- nui.nvim: UI component library required by popup/modal plugins
		"MunifTanjim/nui.nvim",
	},
	{
		-- lspkind.nvim: VS Code-like icons for LSP completions (currently unused)
		-- "onsails/lspkind.nvim",
	},
	{
		-- nvim-web-devicons: filetype icons for file explorers, buffers, etc.
		"nvim-tree/nvim-web-devicons",
	},
}
