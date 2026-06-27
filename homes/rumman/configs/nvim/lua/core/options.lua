-- =============================================================================
-- Neovim Options
-- =============================================================================
-- All vim.opt and vim.g settings live here.
-- Organized by category: leader keys, UI, cursor, search, editing, etc.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Leader keys (vim.g -- must be set before plugins load)
-- -----------------------------------------------------------------------------

local globals = {
	mapleader = " ",        -- Space as leader key
	maplocalleader = "\\",  -- Backslash as buffer-local leader
}

-- -----------------------------------------------------------------------------
-- vim.opt settings
-- -----------------------------------------------------------------------------

local options = {

	-- === Appearance ===========================================================

	number = false,         -- don't show line numbers
	laststatus = 0,         -- hide the statusline (lualine manages this)
	ruler = false,          -- hide the ruler in the command line
	showmode = false,       -- don't display current mode (lualine shows it)
	cmdheight = 0,          -- fully hide the command line until needed

	cursorline = false,     -- don't highlight the current line

	-- characters used for UI elements
	fillchars = {
		foldopen  = "",    -- open fold indicator
		foldclose = "",    -- closed fold indicator
		fold      = " ",    -- folded text filler
		foldsep   = " ",    -- fold separator
		diff      = "╱",    -- diff mode separator
		eob       = " ",    --- end-of-buffer filler (hides ~)
	},

	-- custom block cursor for all modes
	guicursor = {
		"a:block",
	},

	-- === Behavior =============================================================

	wrap = false,           -- don't wrap long lines
	splitbelow = true,      -- horizontal splits open below
	splitright = true,      -- vertical splits open to the right

	scrolloff = 0,          -- no minimum scroll margin
	sidescrolloff = 0,      -- no minimum horizontal scroll margin

	confirm = true,         -- prompt to save changes before exiting

	-- === Search & Replace =====================================================

	ignorecase = true,      -- case-insensitive search by default
	smartcase = true,       --- switch to case-sensitive when query has uppercase
	hlsearch = true,        -- highlight all matches
	inccommand = "split",   -- preview :substitute results in a split window

	-- === Files & Undo =========================================================

	swapfile = false,       -- don't create .swp files
	undofile = true,        -- persist undo history across sessions
	undolevels = 10000,     -- max number of undo entries

	-- === Indentation ==========================================================
	-- Note: these are defaults; ftplugin or editorconfig usually override per
	-- language. tabstop=4 + expandtab=false means real tabs, 4 spaces wide.

	tabstop = 4,            -- number of visual spaces a <Tab> represents
	shiftwidth = 4,         -- number of spaces for each indent step
	expandtab = false,      -- use real tabs instead of spaces

	-- === Signs & Folding ======================================================

	signcolumn = "yes:2",   -- always reserve space for 2 sign columns

	-- === Performance ==========================================================

	updatetime = 2000,      -- ms of idle time before CursorHold fires / swap write
	timeout = true,         -- enable timeout for key codes and mappings
	timeoutlen = 1000,      -- ms to wait for a mapped sequence to complete

	-- === Session ==============================================================

	sessionoptions = {
		"buffers",           -- open buffers
		"curdir",            -- current directory
		"folds",             -- window folds
		"help",              -- help window
		"tabpages",          -- all tab pages
		"globals",           -- global variables
		"winsize",           -- window sizes
		"winpos",            -- window position
		"terminal",          -- terminal buffers
		"localoptions",      -- window-local and buffer-local options
	},

	-- === Cursor behavior =====================================================

	cursorlineopt = "both", -- highlight both the screen line and column
}

-- -----------------------------------------------------------------------------
-- Apply all settings
-- -----------------------------------------------------------------------------

local opt = vim.opt
for key, val in pairs(options) do
	opt[key] = val
end

local g = vim.g
for key, val in pairs(globals) do
	g[key] = val
end
