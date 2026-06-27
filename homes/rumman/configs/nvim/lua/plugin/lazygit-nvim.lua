-- =============================================================================
-- lazygit.nvim — LazyGit integration
-- =============================================================================
-- Opens LazyGit in a floating window. Only enabled inside git repos.
-- =============================================================================

return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	cond = function()
		return vim.fn.finddir(".git", ".;") ~= ''
	end,

	-- ===================================================================
	-- Configuration: floating window appearance
	-- ===================================================================

	init = function()
		local utils = require("lib.utils")
		vim.g.lazygit_floating_window_winblend = 0  -- fully opaque
		vim.g.lazygit_floating_window_scaling_factor = 1.0  -- no scaling
		vim.g.lazygit_floating_window_border_chars = utils.ui.float.border
		-- vim.g.lazygit_floating_window_use_plenary = 0
		-- vim.g.lazygit_use_neovim_remote = 1
		-- vim.g.lazygit_on_exit_callback = nil
	end,

	-- ===================================================================
	-- Keymap: <leader>gg
	-- ===================================================================

	keys = function()
		local git_key1 = _G.git_key1
		return {
			{ git_key1 .. "g", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
		}
	end,
}
