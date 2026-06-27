-- =============================================================================
-- hop.nvim — Ez-motion (character/line/word jumping)
-- =============================================================================
-- Advanced motion plugin with hinted jumps for characters, lines,
-- words, camelCase segments, and more. Single-window (s) and
-- multi-window (ss) variants.
-- =============================================================================

return {
	"smoka7/hop.nvim",
	enabled = true,

	-- ===================================================================
	-- Keymaps: s for single-window, ss for multi-window
	--   Directional: h/j/k/l  Character: f/F/t/T
	--   Words: w/b/e/ge  Lines: 0/^/<C-j>/<C-k>
	--   CamelCase: c  Patterns: u/z
	--   HopYank/HopPaste: y/p
	-- ===================================================================

	keys = function()
		local hint = require("hop.hint").HintDirection
		local pos = require("hop.hint").HintPosition

		return {
			-- -- Directional hints (single window) -----------------------
			{ _G.navigation_key1 .. "h", function() require("hop").hint_anywhere({ direction = hint.BEFORE_CURSOR, current_line_only = true }) end, desc = "Hop left", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "j", function() require("hop").hint_vertical({ direction = hint.AFTER_CURSOR }) end, desc = "Hop down", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "k", function() require("hop").hint_vertical({ direction = hint.BEFORE_CURSOR }) end, desc = "Hop up", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "l", function() require("hop").hint_anywhere({ direction = hint.AFTER_CURSOR, current_line_only = true }) end, desc = "Hop right", mode = { "n", "v", "o" } },

			-- Jump to non-whitespace start of line
			{ _G.navigation_key1 .. "J", function() require("hop").hint_lines_skip_whitespace({ direction = hint.AFTER_CURSOR }) end, desc = "Hop down (to first char)", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "K", function() require("hop").hint_lines_skip_whitespace({ direction = hint.BEFORE_CURSOR }) end, desc = "Hop up (to first char)", mode = { "n", "v", "o" } },

			-- Multi-window variants
			{ _G.navigation_key2 .. "h", function() require("hop").hint_anywhere({ direction = hint.BEFORE_CURSOR, multi_windows = true }) end, desc = "Hop left (multi-window)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "j", function() require("hop").hint_vertical({ direction = hint.AFTER_CURSOR, multi_windows = true }) end, desc = "Hop down (multi-window)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "k", function() require("hop").hint_vertical({ direction = hint.BEFORE_CURSOR, multi_windows = true }) end, desc = "Hop up (multi-window)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "l", function() require("hop").hint_anywhere({ direction = hint.AFTER_CURSOR, multi_windows = true }) end, desc = "Hop right (multi-window)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "J", function() require("hop").hint_lines_skip_whitespace({ multi_windows = true, direction = hint.AFTER_CURSOR }) end, desc = "Hop down (multi, to first char)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "K", function() require("hop").hint_lines_skip_whitespace({ multi_windows = true, direction = hint.BEFORE_CURSOR }) end, desc = "Hop up (multi, to first char)", mode = { "n", "v", "o" } },

			-- -- Character hints (single window: f/F/t/T) ----------------
			{ _G.navigation_key1 .. "f", function() require("hop").hint_char1({ current_line_only = true, direction = hint.AFTER_CURSOR }) end, desc = "Hint forward (f)", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "F", function() require("hop").hint_char1({ current_line_only = true, direction = hint.BEFORE_CURSOR }) end, desc = "Hint backward (F)", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "t", function() require("hop").hint_char1({ current_line_only = true, direction = hint.AFTER_CURSOR, hint_offset = -1 }) end, desc = "Hint till forward (t)", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "T", function() require("hop").hint_char1({ current_line_only = true, direction = hint.BEFORE_CURSOR, hint_offset = 1 }) end, desc = "Hint till backward (T)", mode = { "n", "v", "o" } },

			-- Multi-window character hints
			{ _G.navigation_key2 .. "f", function() require("hop").hint_char1({ current_line_only = false, multi_windows = true, direction = hint.AFTER_CURSOR }) end, desc = "Hint forward multi (f)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "F", function() require("hop").hint_char1({ current_line_only = false, multi_windows = true, direction = hint.BEFORE_CURSOR }) end, desc = "Hint backward multi (F)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "t", function() require("hop").hint_char1({ current_line_only = false, multi_windows = true, direction = hint.AFTER_CURSOR, hint_offset = -1 }) end, desc = "Hint till forward multi (t)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "T", function() require("hop").hint_char1({ current_line_only = false, multi_windows = true, direction = hint.BEFORE_CURSOR, hint_offset = 1 }) end, desc = "Hint till backward multi (T)", mode = { "n", "v", "o" } },

			-- -- HopYank / HopPaste ------------------------------------
			{ _G.navigation_key1 .. "y", function() vim.cmd("HopYankChar1CurrentLine") end, desc = "Yank to hint", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "Y", function() vim.cmd("HopYankChar1CurrentLine") end, desc = "Yank to hint", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "y", function() vim.cmd("HopYankChar1") end, desc = "Yank to hint multi", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "Y", function() vim.cmd("HopYankChar1") end, desc = "Yank to hint multi", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "p", function() vim.cmd("HopPasteChar1CurrentLine") end, desc = "Paste from hint", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "p", function() vim.cmd("HopPasteChar1") end, desc = "Paste from hint multi", mode = { "n", "v", "o" } },

			-- -- CamelCase hints --------------------------------------
			{ _G.navigation_key1 .. "c", function() require("hop").hint_camel_case({ current_line_only = true }) end, desc = "Hint camelcase", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "c", function() require("hop").hint_camel_case({ multi_windows = true }) end, desc = "Hint camelcase multi", mode = { "n", "v", "o" } },

			-- -- Pattern hints ----------------------------------------
			{ _G.navigation_key1 .. "u", function() require("hop").hint_patterns({ current_line_only = true }) end, desc = "Hint pattern", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "z", function() require("hop").hint_char2({ current_line_only = true }) end, desc = "Hint 2 chars", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "u", function() require("hop").hint_patterns({ multi_windows = true }) end, desc = "Hint pattern multi", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "z", function() require("hop").hint_char2({ current_line_only = false, multi_windows = true }) end, desc = "Hint 2 chars multi", mode = { "n", "v", "o" } },

			-- -- Word hints (w/b/e/ge) --------------------------------
			{ _G.navigation_key1 .. "b", function() require("hop").hint_words({ current_line_only = true, direction = hint.BEFORE_CURSOR, hint_position = pos.BEGIN }) end, desc = "Hop word begin (back)", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "w", function() require("hop").hint_words({ current_line_only = true, direction = hint.AFTER_CURSOR, hint_position = pos.BEGIN }) end, desc = "Hop word begin (fwd)", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "e", function() require("hop").hint_words({ current_line_only = true, direction = hint.AFTER_CURSOR, hint_position = pos.END }) end, desc = "Hop word end", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "ge", function() require("hop").hint_words({ current_line_only = true, direction = hint.BEFORE_CURSOR, hint_position = pos.END }) end, desc = "Hop word end (back)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "w", function() require("hop").hint_words({ current_line_only = false, multi_windows = true, direction = hint.AFTER_CURSOR, hint_position = pos.BEGIN }) end, desc = "Hop word begin multi", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "b", function() require("hop").hint_words({ current_line_only = false, multi_windows = true, direction = hint.BEFORE_CURSOR, hint_position = pos.BEGIN }) end, desc = "Hop word begin back multi", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "e", function() require("hop").hint_words({ current_line_only = false, multi_windows = true, direction = hint.AFTER_CURSOR, hint_position = pos.END }) end, desc = "Hop word end multi", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "ge", function() require("hop").hint_words({ current_line_only = false, multi_windows = true, direction = hint.BEFORE_CURSOR, hint_position = pos.END }) end, desc = "Hop word end back multi", mode = { "n", "v", "o" } },

			-- -- Line hints (like native 0 and ^) ---------------------
			{ _G.navigation_key1 .. "0", function() require("hop").hint_lines({}) end, desc = "Hop to start (0)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "0", function() require("hop").hint_lines({ multi_windows = true }) end, desc = "Hop to start multi (0)", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "^", function() require("hop").hint_lines_skip_whitespace({}) end, desc = "Hop to first non-ws (^)", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "^", function() require("hop").hint_lines_skip_whitespace({ multi_windows = true }) end, desc = "Hop to first non-ws multi (^)", mode = { "n", "v", "o" } },

			-- -- Line jump with Ctrl+j/k (0-like line selection) ------
			{ _G.navigation_key1 .. "<c-j>", function() require("hop").hint_lines({ direction = hint.AFTER_CURSOR }) end, desc = "0 down", mode = { "n", "v", "o" } },
			{ _G.navigation_key1 .. "<c-k>", function() require("hop").hint_lines({ direction = hint.BEFORE_CURSOR }) end, desc = "0 up", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "<c-j>", function() require("hop").hint_lines({ multi_windows = true, direction = hint.AFTER_CURSOR }) end, desc = "0 down multi", mode = { "n", "v", "o" } },
			{ _G.navigation_key2 .. "<c-k>", function() require("hop").hint_lines({ multi_windows = true, direction = hint.BEFORE_CURSOR }) end, desc = "0 up multi", mode = { "n", "v", "o" } },
		}
	end,

	opts = {
		keys = "asdghklqwertyuiopzxcvbnmfj",  -- hint characters
		x_bias = 100,               -- horizontal bias for hint placement
		dim_unmatched = true,       -- dim non-target text
		hint_type = "overlay",      -- show hints on top of text
		jump_on_sole_occurrence = false,  -- don't auto-jump if only one match
	},
}
