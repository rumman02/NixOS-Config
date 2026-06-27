-- =============================================================================
-- flash.nvim — Fuzzy jump navigation
-- =============================================================================
-- Replaces f/F/t/T with labeled character jumping for faster navigation.
-- =============================================================================

return {
	"folke/flash.nvim",
	enabled = true,

	-- ===================================================================
	-- Keymaps: f/F/t/T replaced with flash-enhanced versions
	-- ===================================================================

	keys = {
		{
			"f",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump({
					search = { forward = true, wrap = false, multi_window = false },
					label = { after = { 0, 0 } },
					pattern = "^"  -- match beginning of words
				})
			end,
			desc = "Flash forward to character",
		},
		{
			"F",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump({
					search = { forward = false, wrap = false, multi_window = false },
					label = { after = { 0, 0 } },
					pattern = "^",
				})
			end,
			desc = "Flash backward to character",
		},
		{
			"t",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump({
					search = { forward = true, wrap = false, multi_window = false },
					label = { after = { 0, 0 } },
					pattern = "^",
					action = function(match, state)
						state:jump(vim.tbl_extend("force", match, { pos = { match.pos[1], match.pos[2] - 1 } }))
					end,
				})
			end,
			desc = "Flash forward till character",
		},
		{
			"T",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump({
					search = { forward = false, wrap = false, multi_window = false },
					label = { after = { 0, 0 } },
					pattern = "^",
					action = function(match, state)
						state:jump(vim.tbl_extend("force", match, { pos = { match.pos[1], match.pos[2] + 1 } }))
					end,
				})
			end,
			desc = "Flash backward till character",
		},
		-- -- Additional flash modes (disabled)
		-- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
		-- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		-- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
		-- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		-- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	},

	opts = {
		label = {
			uppercase = true,      -- use uppercase labels
			distance = true,       -- show distance in label
		},
		search = {
			exclude = {
				"Telescope", "TelescopePrompt", "noice",
				"flash_prompt", "notify",
			},
		},
		modes = {
			search = {
				enabled = false,     -- don't enhance /? search
			},
			char = {
				-- keys = { "f", "F", "t", "T" },
				jump_labels = true,  -- show labels even for single match
			},
		},
		prompt = {
			enabled = false,
			prefix = { { "󰃧 " } },
		},
	},
}
