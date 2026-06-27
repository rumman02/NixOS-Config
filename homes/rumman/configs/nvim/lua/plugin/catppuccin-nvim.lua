-- =============================================================================
-- catppuccin-nvim — Color scheme
-- =============================================================================
-- Sets up the Catppuccin Mocha theme with custom highlight overrides
-- and integrations for plugins. Eagerly loaded (not lazy) since it's
-- needed before any UI renders.
-- =============================================================================

return {
	"catppuccin/nvim",
	name = "catppuccin-nvim",
	enabled = true,
	-- enabled = false,
	priority = 1001,          -- load before other plugins
	lazy = false,             -- don't defer loading
	cond = require("nixCatsUtils").lazyAdd(function()
		return vim.fn.executable "make" == 1  -- require make for building treesitter highlights
	end),

	init = function()
	end,

	opts = function()
		local utils = require("lib.utils")

		return {
			default_integrations = true,
			transparent_background = true,  -- no background color
			highlight_overrides = {
				mocha = function(mocha)
					return {
						Comment = { fg = mocha.surface2 },
						Folded = { fg = mocha.mauve, bg = "NONE" },
						BlinkCmpMenu = { bg = mocha.base },
						BlinkCmpMenuBorder = { bg = mocha.base },
						MiniJump = { fg = mocha.peach, bg = "NONE", underline = true },
						MiniClueSeparator = { link = "Comment" },
						HopNextKey = { fg = mocha.peach, bold = true },
						HopNextKey1 = { fg = mocha.blue, bold = true },
						HopNextKey2 = { fg = mocha.green, bold = true },
						HydraHint = { fg = mocha.flamingo },
						HydraRed = { fg = mocha.red },
						HydraBlue = { fg = mocha.blue },
						HydraAmaranth = { fg = mocha.peach },
						HydraTeal = { fg = mocha.teal },
						HydraPink = { fg = mocha.flamingo },
						NeoTreeNormal = { bg = mocha.mantle },
						NeoTreeNormalNC = { bg = mocha.mantle },
					}
				end,
			},
			styles = {
				-- keywords = { "italic" },  -- optional keyword style
			},

			-- ===================================================================
			-- Plugin integrations
			-- ===================================================================

			integrations = {
				barbar = true,
				neotree = true,
				cmp = true,
				hop = false,
				leap = true,
				noice = true,
				notify = true,
				notifier = true,
				render_markdown = true,
				markview = true,
				markdown = true,
				mason = true,
				which_key = true,
				ufo = true,
				snacks = { enabled = true, indent_scope_color = "mauve" },
				gitsigns = { enabled = true, transparent = false },
				blink_cmp = { enabled = true, border = utils.ui.float.border },
				mini = { enabled = true, indentscope_color = "mauve" },
			},
		}
	end,

	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd("colorscheme catppuccin")
	end,
}
