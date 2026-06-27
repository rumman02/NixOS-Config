-- =============================================================================
-- gitsigns.nvim — Git integration in sign column
-- =============================================================================
-- Shows git diff markers (added/changed/deleted) in the sign column,
-- with hunk navigation, staging, blame, and diff capabilities.
-- Only enabled inside git repositories.
-- =============================================================================

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufAdd", "BufRead" },
	cond = function()
		return vim.fn.finddir(".git", ".;") ~= ''
	end,

	-- ===================================================================
	-- Keymaps: hunk navigation, staging, blame, diff, toggles
	-- ===================================================================

	keys = function()
		local git_key1 = _G.git_key1
		local git_key2 = _G.git_key2
		return {
			-- Quick hunk navigation (standard keys)
			{ "[g", "<cmd>Gitsigns next_hunk<cr>", desc = "Next hunk" },
			{ "]g", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous hunk" },

			-- Buffer operations
			{ git_key1 .. "b", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
			{ git_key1 .. "s", "<cmd>Gitsigns show<cr>", desc = "Show file" },
			{ git_key1 .. "r", "<cmd>Gitsigns refresh<cr>", desc = "Refresh" },
			{ git_key1 .. "a", "<cmd>Gitsigns get_actions<cr>", desc = "Get actions" },
			{ git_key1 .. "dw", "<cmd>Gitsigns toggle_word_diff<cr>", desc = "Toggle word diff" },

			-- Hunk operations
			{ git_key1 .. "ha", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
			{ git_key1 .. "hu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage hunk" },
			{ git_key1 .. "hp", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Preview hunk inline" },
			{ git_key1 .. "hP", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
			{ git_key1 .. "hr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
			{ git_key1 .. "hs", "<cmd>Gitsigns select_hunk<cr>", desc = "Select hunk" },
			{ git_key1 .. "hg", "<cmd>Gitsigns get_hunks<cr>", desc = "Get hunks" },
			{ git_key1 .. "hv", "<cmd>Gitsigns nav_hunk<cr>", desc = "Navigate hunk" },

			-- Diff views
			{ git_key1 .. "dh", "<cmd>Gitsigns diffthis<cr><cmd>wincmd L<cr>", desc = "Diff left" },
			{ git_key1 .. "dj", "<cmd>Gitsigns diffthis<cr><cmd>wincmd K<cr>", desc = "Diff down" },
			{ git_key1 .. "dk", "<cmd>set nosplitbelow<cr><cmd>Gitsigns diffthis<cr><cmd>wincmd J<cr>", desc = "Diff up" },
			{ git_key1 .. "dl", "<cmd>set splitright<cr><cmd>Gitsigns diffthis<cr><cmd>wincmd H<cr>", desc = "Diff right" },

			-- Blame
			{ git_key1 .. "bc", "<cmd>Gitsigns blame_line<cr>", desc = "Blame current line" },
			{ git_key1 .. "be", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle line blame" },
			{ git_key1 .. "bs", "<cmd>Gitsigns blame<cr>", desc = "Blame split view" },

			-- Toggle visual indicators
			{ git_key1 .. "ts", "<cmd>Gitsigns toggle_signs<cr>", desc = "Toggle signs" },
			{ git_key1 .. "tl", "<cmd>Gitsigns toggle_linehl<cr>", desc = "Toggle line highlight" },
			{ git_key1 .. "tn", "<cmd>Gitsigns toggle_numhl<cr>", desc = "Toggle number highlight" },
			{ git_key1 .. "td", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle deleted" },

			-- Base commit
			{ git_key1 .. "Bc", "<cmd>Gitsigns change_base<cr>", desc = "Change base" },
			{ git_key1 .. "Br", "<cmd>Gitsigns reset_base<cr>", desc = "Reset base" },

			-- Reset operations
			{ git_key1 .. "Ri", "<cmd>Gitsigns reset_buffer_index<cr>", desc = "Reset buffer index" },
			{ git_key1 .. "Rb", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },

			-- Location and quickfix lists
			{ git_key1 .. "ll", "<cmd>Gitsigns setloclist<cr>", desc = "Set location list" },
			{ git_key1 .. "lq", "<cmd>Gitsigns setqflist<cr>", desc = "Set quickfix list" },
		}
	end,

	-- ===================================================================
	-- Sign appearance
	-- ===================================================================

	opts = function()
		return {
			-- Unstaged signs: minimal pipe character
			signs = {
				add = { text = "|" },
				change = { text = "|" },
				delete = { text = "|" },
				topdelete = { text = "|" },
				changedelete = { text = "|" },
				untracked = { text = "|" },
			},
			-- Staged signs: different visual style
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "~" },
				untracked = { text = "║" },
			},
		}
	end,
}
