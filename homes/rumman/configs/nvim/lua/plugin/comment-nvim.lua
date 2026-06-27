-- =============================================================================
-- Comment.nvim — Smart commenting
-- =============================================================================
-- Comment/uncomment lines and blocks with Treesitter context awareness
-- (handles mixed languages like JSX correctly).
-- =============================================================================

return {
	"numToStr/Comment.nvim",
	name = "comment.nvim",

	-- ===================================================================
	-- Custom keymaps: gc for linewise, gb for blockwise
	-- ===================================================================

	keys = function()
		return {
			-- Blockwise comment (visual mode + normal mode)
			{ _G.comment_key2, "<Plug>(comment_toggle_blockwise_visual)", desc = "Comment block (visual)", mode = "v" },
			{ _G.comment_key2, "<Plug>(comment_toggle_blockwise)", desc = "Comment block" },
			{ _G.comment_key2 .. "A", function() require("Comment.api").insert.blockwise.eol() end, desc = "Comment block at EOL" },
			{ _G.comment_key2 .. "b", function() return vim.v.count == 0 and "<Plug>(comment_toggle_blockwise_current)" or "<Plug>(comment_toggle_blockwise_count)" end, expr = true, desc = "Comment block current line" },
			{ _G.comment_key2 .. "o", function() require("Comment.api").insert.blockwise.below() end, desc = "Comment block below" },
			{ _G.comment_key2 .. "O", function() require("Comment.api").insert.blockwise.above() end, desc = "Comment block above" },

			-- Linewise comment
			{ _G.comment_key1, "<Plug>(comment_toggle_linewise_visual)", desc = "Comment line (visual)", mode = "v" },
			{ _G.comment_key1, "<Plug>(comment_toggle_linewise)", desc = "Comment line" },
			{ _G.comment_key1 .. "A", function() require("Comment.api").insert.linewise.eol() end, desc = "Comment at EOL" },
			{ _G.comment_key1 .. "c", function() return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)" end, expr = true, desc = "Comment current line" },
			{ _G.comment_key1 .. "o", function() require("Comment.api").insert.linewise.below() end, desc = "Comment below" },
			{ _G.comment_key1 .. "O", function() require("Comment.api").insert.linewise.above() end, desc = "Comment above" },

			-- Paste yanked text as comment
			{ _G.comment_key1 .. "P", "VyP<Plug>(comment_toggle_linewise_current)gv<esc>", desc = "Paste yank above as comment" },
			{ _G.comment_key1 .. "p", "Vyp<Plug>(comment_toggle_linewise_current)gv<esc>", desc = "Paste yank below as comment" },
		}
	end,

	dependencies = "JoosepAlviste/nvim-ts-context-commentstring",

	config = function()
		return {
			-- Use ts-context-commentstring for mixed-language files (JSX, Vue, etc.)
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

			-- Disable default keymaps (we define custom ones in `keys`)
			mappings = {
				basic = false,  -- gcc, gbc
				extra = false,  -- gcO, gco, gcA
			},
		}
	end,
}
