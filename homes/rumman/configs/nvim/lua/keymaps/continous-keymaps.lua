-- =============================================================================
-- Continuous Keymaps (Hydra)
-- =============================================================================
-- Hydra definitions for modeless "chords" that stay active until ESC is pressed.
-- These are window resize and window swap/move commands triggered by
-- <C-w>r and <C-w>m respectively.
-- =============================================================================

local Hydra = require("hydra")
local icons = require("lib.icons")

-- =============================================================================
-- Resize Hydra: <C-w>r → h/j/k/l to resize windows
-- =============================================================================

Hydra({
	name = "Resize",
	mode = "n",
	body = _G.window_key1 .. "r",  -- <C-w>r
	config = {
		invoke_on_body = true,      -- show hint when activated
	},
	hint = " _h_ " .. icons.keymap.separator .. " Left    \n"
		.. " _j_ " .. icons.keymap.separator .. " Down    \n"
		.. " _k_ " .. icons.keymap.separator .. " Up    \n"
		.. " _l_ " .. icons.keymap.separator .. " Right    \n",
	heads = {
		{ "h", "<cmd>SmartResizeLeft<cr>",  { desc = "Resize left" } },
		{ "j", "<cmd>SmartResizeDown<cr>",  { desc = "Resize down" } },
		{ "k", "<cmd>SmartResizeUp<cr>",    { desc = "Resize up" } },
		{ "l", "<cmd>SmartResizeRight<cr>", { desc = "Resize right" } },
	},
})

-- =============================================================================
-- Swap/Move Hydra: <C-w>m → h/j/k/l to swap windows
-- =============================================================================
-- Shifted keys (H/J/K/L) for moving windows are defined but disabled.
-- ===========================================================================

Hydra({
	name = "Move/Swap",
	mode = "n",
	body = _G.window_key1 .. "m",  -- <C-w>m
	config = {
		invoke_on_body = true,      -- show hint when activated
	},
	hint = " _h_ " .. icons.keymap.separator .. " Left [Swap]    \n"
		.. " _j_ " .. icons.keymap.separator .. " Down [Swap]   \n"
		.. " _k_ " .. icons.keymap.separator .. " Up [Swap]   \n"
		.. " _l_ " .. icons.keymap.separator .. " Right [Swap]   \n",
		-- .." _H_ " .. icons.keymap.separator .. " Left [Move]   \n"
		-- .." _J_ " .. icons.keymap.separator .. " Down [Move]   \n"
		-- .." _K_ " .. icons.keymap.separator .. " Up [Move]   \n"
		-- .." _L_ " .. icons.keymap.separator .. " Right [Move]   \n",
	heads = {
		{ "h", "<cmd>SmartSwapLeft<cr>",  { desc = "Swap left" } },
		{ "j", "<cmd>SmartSwapDown<cr>",  { desc = "Swap down" } },
		{ "k", "<cmd>SmartSwapUp<cr>",    { desc = "Swap up" } },
		{ "l", "<cmd>SmartSwapRight<cr>", { desc = "Swap right" } },
		-- { "H", "<cmd>SmartSwapLeft<cr>",  { desc = "Move left" } },
		-- { "J", "<cmd>SmartSwapDown<cr>",  { desc = "Move down" } },
		-- { "K", "<cmd>SmartSwapUp<cr>",    { desc = "Move up" } },
		-- { "L", "<cmd>SmartSwapRight<cr>", { desc = "Move right" } },
	},
})
