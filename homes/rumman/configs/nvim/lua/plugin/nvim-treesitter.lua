-- =============================================================================
-- nvim-treesitter — Syntax highlighting & indentation
-- =============================================================================
-- Tree-sitter based highlighting, indentation, and textobject support.
-- Auto-install of parsers is disabled (handled by nix).
-- =============================================================================

return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	build = require("nixCatsUtils").lazyAdd(":TSUpdate"),  -- only update on non-nix
	event = "VeryLazy",
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter").setup({
			auto_install = false,     -- don't auto-download parsers (nix manages them)
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false  -- no fallback regex highlighting
			},
			indent = {
				enable = true,        -- treesitter-based indentation
			},

			-- -- Textobjects: selections for parameters, functions, classes (disabled)
			-- textobjects = {
			-- 	select = {
			-- 		enable = true,
			-- 		lookahead = true,
			-- 		keymaps = {
			-- 			['ia'] = '@parameter.inner',
			-- 			['aa'] = '@parameter.outer',
			-- 			['if'] = '@function.inner',
			-- 			['af'] = '@function.outer',
			-- 			['ic'] = '@class.inner',
			-- 			['ac'] = '@class.outer',
			-- 		},
			-- 	},
			-- 	move = {
			-- 		enable = true,
			-- 		set_jumps = true,
			-- 		goto_next_start = { [']m'] = '@function.outer', ['[['] = '@class.outer' },
			-- 		goto_next_end = { [']M'] = '@function.outer', ['[]'] = '@class.outer' },
			-- 		goto_previous_start = { [']m'] = '@function.outer', ['][] ] = '@class.outer' },
			-- 		goto_previous_end = { [']M'] = '@function.outer', ['][] ] = '@class.outer' },
			-- 	},
			-- 	swap = {
			-- 		enable = true,
			-- 		swap_next = { ['<leader>a'] = '@parameter.inner' },
			-- 		swap_previous = { ['<leader>A'] = '@parameter.inner' },
			-- 	},
			-- },
		})
	end,
}
