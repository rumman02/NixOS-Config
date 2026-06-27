-- =============================================================================
-- Icon Definitions
-- =============================================================================
-- Centralized Nerd Font icon mappings used across the config (keymaps,
-- diagnostics, file explorers, statusline, etc.).
-- =============================================================================

local M = {}

-- =============================================================================
-- Keymap UI icons
-- =============================================================================

M.keymap = {
	separator = "",         -- icon between key and description in hint text
	breadcrumb = " ",        -- breadcrumb trail icon
	group = "+ ",             -- prefix for grouped keymaps
}

-- =============================================================================
-- File explorer icons
-- =============================================================================

M.filesystem = {
	file = {
		add = "󰝒",            -- create new file
		default = "󰈔",        -- generic file icon
		find = "󰱼",           -- search/find result
		import = "󰈠",         -- imported file
		recent = "󱋡",         -- recently opened file
		written = "",        -- saved/modified file
	},
	folder = {
		default = "󰉋",        -- standard closed folder
		empty = "󰉖",          -- empty folder
		multi = "󰉓",          -- multiple folder (tree root)
		opened = "󰝰",         -- open/expanded folder
		tree = "󰙅",           -- tree/project root
	},
	modified = "󰑊",           -- file has unsaved changes
	readonly = "",           -- read-only file
	unnammed = "",           -- unnamed/scratch buffer
	newfile = "",            -- new file indicator
}

-- =============================================================================
-- Diagnostic severity icons
-- =============================================================================

M.diagnostic = {
	debug = "󰃤",
	error = "󰅙",
	hint = "󱤅",
	-- hint = "󰌵",
	info = "󰋼",
	ques = "󰋗",
	warn = "󰀨",
	trace = "",
	-- warn = "󰀦",
}

-- =============================================================================
-- Git status icons
-- =============================================================================

M.git = {
	added = "󰐙",
	-- added = "󰐗",
	-- added = "󰐖",
	branch = "",
	conflict = "󱨧",
	-- conflict = "󱡝",
	commit = "󰜘",
	diff = "󰆗",
	ignored = "󱥸",
	modified = "󰻃",
	logo = "󰊤",
	-- modified = "󰻂",
	-- modified = "󰪥",
	octoface = "",           -- GitHub Octocat placeholder
	-- removed = "󰜺",
	-- removed = "󰍵",
	removed = "󰍷",
	-- removed = "󰍶",
	renamed = "󰮍",
	-- renamed = "󰟃",
	repo = "",               -- repository icon
	staged = "󰬭",
	-- staged = "󰬬",
	tag = "",                -- git tag
	unstaged = "󰬧",
	-- unstaged = "󰬦",
	untracked = "󰄰",
	-- untracked = "󰋗",
}

-- =============================================================================
-- Separator / divider icons
-- =============================================================================

M.separators = {
	slant_left_rev_1 = "",
	slant_right_rev_1 = "",
	-- slant_left_2 = "",
	-- slant_right_2 = "",
	slant_right_2 = "╲",      -- diagonal right (backward slash)
	slant_left_2 = "╱",       -- diagonal left (forward slash)
	slant_left_1 = "",
	slant_right_1 = "",
	shadow_left_1 = "▓▒░",    -- gradient fade left
	shadow_right_1 = "░▒▓",   -- gradient fade right
	rounded_left_1 = "",
	rounded_right_1  = "",
	rounded_left_2= "",
	rounded_right_2 = "",
}

-- =============================================================================
-- Plugin loading state icons
-- =============================================================================

M.loading_state = {
	loaded = "󰗠",            -- plugin loaded successfully
	pending = "󱥸",           -- plugin pending/installing
	not_loaded = "",        -- plugin not loaded
}

return M
