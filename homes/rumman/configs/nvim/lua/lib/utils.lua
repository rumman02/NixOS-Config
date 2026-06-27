-- =============================================================================
-- Utility Values
-- =============================================================================
-- Shared configuration values used across keymap and plugin files
-- (UI settings, indent sizes, editor options).
-- =============================================================================

local M = {}

-- =============================================================================
-- UI configuration
-- =============================================================================

M.ui = {
	frame_rate = 120,         -- target animation frame rate
	float = {
		width = 0.85,         -- floating window width (ratio of editor)
		height = 0.85,        -- floating window height (ratio of editor)
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },  -- rounded border chars
		backdrop = 60,        -- backdrop transparency percentage
		title_pos = "center", -- title alignment in floating windows
	},
}

-- =============================================================================
-- Indentation presets
-- =============================================================================

M.indent = {
	explorer = 2,             -- indent level for file explorer trees
	editor = 4                -- default editor tab width (matches options.lua)
}

-- =============================================================================
-- Shared editor options
-- =============================================================================

M.options = {
	wrap = false,             -- line wrapping disabled (matches options.lua)
}

return M
