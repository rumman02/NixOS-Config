-- =============================================================================
-- mini.nvim — Collection of minimal Lua plugins
-- =============================================================================
-- Uses multiple mini modules: ai, align, trailspace, splitjoin.
-- Many modules are disabled in favor of alternatives (surround → nvim-surround,
-- pairs → ultimate-autopairs, files → neo-tree, etc.).
-- =============================================================================

return {
	"echasnovski/mini.nvim",
	enabled = true,
	event = { "BufReadPre", "BufAdd", "BufNewFile" },
	-- priority = 1001,
	-- lazy = false,

	-- ===================================================================
	-- Keymaps
	-- ===================================================================

	keys = function()
		return {
			-- { _G.explorer_key1.."e", function() require("mini.files").open() end, desc = "[E]xplorer" },
			{ _G.format_key1 .. "s", function() require("mini.trailspace").trim() end, desc = "Remove trail[S]pace" },
		}
	end,

	init = function()
		-- Disable trailspace highlight on snacks dashboard
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = "snacks_dashboard",
			callback = function()
				vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "NONE", fg = "NONE" })
			end,
		})
	end,

	-- ===================================================================
	-- Setup active mini modules
	-- ===================================================================

	config = function()
		local utils = require("lib.utils")
		local color = nixCats.extra.stylix_color

		-- Active modules
		require("mini.ai").setup()          -- better around text objects (ia, aa)
		require("mini.align").setup()       -- align text interactively
		require("mini.trailspace").setup()  -- highlight trailing whitespace
		require("mini.splitjoin").setup()   -- split/join multi-line constructs

		-- -- mini.base16 — color palette theming (disabled)
		-- require("mini.base16").setup({ ... })

		-- -- mini.surround — replaced by nvim-surround
		-- require("mini.surround").setup({ ... })

		-- -- mini.pairs — replaced by ultimate-autopairs
		-- require("mini.pairs").setup({ ... })

		-- -- mini.clue — key hint system (disabled, insufficient for needs)
		-- require("mini.clue").setup({ ... })

		-- -- mini.files — replaced by neo-tree.nvim
		-- require("mini.files").setup({ ... })
	end,
}
