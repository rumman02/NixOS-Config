-- =============================================================================
-- undotree — Persistent undo visualization
-- =============================================================================
-- Shows a tree of all undo states, allowing you to navigate back through
-- editing history visually. Supports custom window layouts and buffer-local
-- keymaps inside the undotree buffer.
-- =============================================================================

return {
	"mbbill/undotree",
	enabled = true,

	-- ===================================================================
	-- Keymaps: toggle with custom window layout
	-- ===================================================================

	keys = function()
		local undotree_window = function(undotree, diffpanel)
			vim.g.undotree_CustomUndotreeCmd = undotree
			vim.g.undotree_CustomDiffpanelCmd = diffpanel
			vim.cmd("UndotreeToggle")
			vim.cmd("UndotreeShow")
		end

		return {
			{ _G.undotree_key1, function() undotree_window("topleft vertical 30 new", "botright 10 new") end, desc = "Undotree (left + down)" },
			-- Additional window layout options (currently disabled)
			-- { _G.undotree_key1 .. "f", ..., desc = "Focus" },
			-- { _G.undotree_key1 .. "x", ..., desc = "Close" },
			-- { _G.undotree_key1 .. "mh", ..., desc = "Left" },
			-- { _G.undotree_key1 .. "ml", ..., desc = "Right" },
		}
	end,

	-- ===================================================================
	-- Buffer-local keymaps inside the undotree buffer
	-- ===================================================================

	config = function()
		vim.api.nvim_create_autocmd("Filetype", {
			pattern = "undotree",
			callback = function()
				-- Navigation
				vim.keymap.set("n", "<localleader>x", "<plug>UndotreeClose", { desc = "Close", buffer = true })
				vim.keymap.set("n", "<localleader>u", "<Plug>UndotreeUndo", { desc = "Undo", buffer = true })
				vim.keymap.set("n", "<localleader>r", "<Plug>UndotreeRedo", { desc = "Redo", buffer = true })

				-- Target and history
				vim.keymap.set("n", "<localleader>f", "<Plug>UndotreeFocusTarget", { desc = "Focus target", buffer = true })
				vim.keymap.set("n", "<localleader>c", "<Plug>UndotreeClearHistory", { desc = "Clear history", buffer = true })

				-- Display toggles
				vim.keymap.set("n", "<localleader>t", "<Plug>UndotreeTimestampToggle", { desc = "Toggle timestamps", buffer = true })
				vim.keymap.set("n", "<localleader>d", "<Plug>UndotreeDiffToggle", { desc = "Toggle diff", buffer = true })

				-- State navigation
				vim.keymap.set("n", "<localleader>K", "<Plug>UndotreeNextState", { desc = "Next state", buffer = true })
				vim.keymap.set("n", "<localleader>J", "<Plug>UndotreePreviousState", { desc = "Previous state", buffer = true })

				-- Saved state navigation
				vim.keymap.set("n", "<localleader>s", "<Plug>UndotreeNextSavedState", { desc = "Next saved", buffer = true })
				vim.keymap.set("n", "<localleader>S", "<Plug>UndotreePreviousSavedState", { desc = "Previous saved", buffer = true })

				-- Enter
				vim.keymap.set("n", "<localleader><cr>", "<Plug>UndotreeEnter", { desc = "Enter", buffer = true })
			end,
		})
	end,
}
