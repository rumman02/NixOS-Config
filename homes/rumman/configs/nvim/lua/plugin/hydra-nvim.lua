-- =============================================================================
-- hydra.nvim — Persistent keybindings (Hydra mode)
-- =============================================================================
-- Enables "sticky" mode where after pressing a prefix, multiple
-- commands can be executed sequentially until ESC is pressed.
-- The actual Hydra definitions are in keymaps/continous-keymaps.lua.
-- =============================================================================

return {
	"nvimtools/hydra.nvim",
	enabled = true,
	event = "VeryLazy",
	opts = {
		exit = false,               -- don't exit Hydra after executing a head
		foreign_keys = nil,         -- default foreign key behavior
		color = "pink",             -- hint color scheme
		timeout = 5000,             -- ms before Hydra hint disappears
		hint = {
			show_name = false,      -- don't show Hydra name in hint
			type = "window",        -- show hint in a floating window
			position = "bottom-right",
			float_opts = {
				border = "rounded",
				style = "minimal",
			},
		},
		invoke_on_body = false,     -- don't auto-show hint on activation
	},
	config = function(_, opts)
		require("hydra").setup(opts)
		-- Load continuous keymap Hydras (resize, swap/move)
		require("keymaps.continous-keymaps")
	end,
}
