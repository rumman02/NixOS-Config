-- =============================================================================
-- obsidian.nvim — Obsidian vault integration
-- =============================================================================
-- Loads only when opening files in the Obsidian Vaults directory.
-- Configures personal and work vaults.
-- =============================================================================

return {
	"epwalsh/obsidian.nvim",
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/Documents/Obsidian-Vaults/",
		"BufNewFile " .. vim.fn.expand("~") .. "/Documents/Obsidian-Vaults/"
	},
	opts = function()
		local vault = "~/Documents/Obsidian-Vaults/"
		return {
			-- Vault workspaces
			workspaces = {
				{ name = "personal", path = vault .. "Personal" },
				{ name = "work",     path = vault .. "Work" },
			},
			ui = { enable = false },  -- don't override Obsidian UI
		}
	end,
}
