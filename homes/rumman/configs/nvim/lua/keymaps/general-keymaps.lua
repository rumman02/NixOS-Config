-- =============================================================================
-- General Keymaps
-- =============================================================================
-- Core bindings for navigation, window management, editing, tabs, search, etc.
-- Uses vim.keymap.set (modern keymap API that supports Lua functions).
-- =============================================================================

local map = vim.keymap.set

-- =============================================================================
-- Undo / Redo (suppress notifications)
-- =============================================================================

map("n", "u", "<cmd>silent undo<cr>", { desc = "Undo" })
map("n", "<c-r>", "<cmd>silent redo<cr>", { desc = "Redo" })

-- =============================================================================
-- Misc fixes
-- =============================================================================

map("n", "l", "l", { noremap = true })     -- ensure l stays as plain l (no remap)
-- map("n", "K", "l", { noremap = true })  -- remap K (man/hover) to l — currently disabled

-- Custom q handler: if not recording a macro, treat q + next char as input
-- so a bare q doesn't accidentally start macro recording.
map("n", "q", function()
	if vim.fn.reg_recording() == "" then
		local key = vim.fn.getcharstr()
		if key ~= ":" then
			vim.api.nvim_feedkeys("q" .. key, "n", true)
		end
	else
		vim.api.nvim_feedkeys("q", "n", true)
	end
end, { desc = "Custom q mapping (disable macro recording)" })

-- =============================================================================
-- Window management
-- =============================================================================

-- Remove default bindings that conflict with custom setup
vim.keymap.del("n", _G.window_key1.."<c-d>")  -- default: show diagnostics under cursor
vim.keymap.del("n", _G.window_key1.."d")      -- default: show diagnostics under cursor

map("n", _G.window_key1.."S", "<cmd>split<cr>", { desc = "Split horizontally" })
map("n", _G.window_key1.."s", "<cmd>vsplit<cr>", { desc = "Split vertically" })
map("n", _G.window_key1.."x", "<c-w>q", { desc = "Close window" })
map("n", _G.window_key1.."X", "<c-w>o", { desc = "Close other windows" })
-- map("n", _G.window_key1.."rh", "<cmd>vertical resize -5<cr>", { desc = "Decrease width" })
-- map("n", _G.window_key1.."rj", "<cmd>resize +2<cr>",     { desc = "Increase height" })
-- map("n", _G.window_key1.."rk", "<cmd>resize -2<cr>",     { desc = "Decrease height" })
-- map("n", _G.window_key1.."rl", "<cmd>vertical resize +5<cr>", { desc = "Increase width" })

-- =============================================================================
-- Window navigation (Ctrl+hjkl in normal & terminal mode)
-- =============================================================================

-- Normal mode — move cursor between windows
map("n", "<c-h>", "<c-w>h", { desc = "Go to left window" })
map("n", "<c-j>", "<c-w>j", { desc = "Go to window below" })
map("n", "<c-k>", "<c-w>k", { desc = "Go to window above" })
map("n", "<c-l>", "<c-w>l", { desc = "Go to right window" })

-- Terminal mode — exit insert mode first, then navigate
map("t", "<c-h>", "<c-\\><c-n><c-w>h", { desc = "Go to left window" })
map("t", "<c-j>", "<c-\\><c-n><c-w>j", { desc = "Go to window below" })
map("t", "<c-k>", "<c-\\><c-n><c-w>k", { desc = "Go to window above" })
map("t", "<c-l>", "<c-\\><c-n><c-w>l", { desc = "Go to right window" })
map("t", "<c-l>", "<right>", { desc = "Accept completion" })

-- =============================================================================
-- Insert mode navigation
-- =============================================================================

map("i", "<c-h>", "<left>", { desc = "Move left" })
map("i", "<c-j>", "<down>", { desc = "Move down" })
map("i", "<c-k>", "<up>", { desc = "Move up" })
map("i", "<c-l>", "<right>", { desc = "Move right" })

-- Shift-modified: insert or create new lines without leaving insert mode
map("i", "<c-s-h>", "<space>", { desc = "Insert space" })
map("i", "<c-s-j>", "<esc>O", { desc = "New line above" })
map("i", "<c-s-k>", "<esc>o", { desc = "New line below" })
map("i", "<c-s-l>", "<space><left>", { desc = "Insert space and move left" })

-- Undo breaks: punctuation characters get their own undo step so you can
-- undo one comma/semicolon at a time rather than re-typing whole sentences.
map("i", ",", ",<c-g>u", { desc = "Insert comma (undo break)" })
map("i", ".", ".<c-g>u", { desc = "Insert period (undo break)" })
map("i", ";", ";<c-g>u", { desc = "Insert semicolon (undo break)" })
map("i", ":", ":<c-g>u", { desc = "Insert colon (undo break)" })
map("i", "!", "!<c-g>u", { desc = "Insert exclamation (undo break)" })
map("i", "?", "?<c-g>u", { desc = "Insert question mark (undo break)" })

-- =============================================================================
-- Search & navigation
-- =============================================================================

-- map("n", "n", "nzzzv", { desc = "Next search result, center cursor" })
-- map("n", "N", "Nzzzv", { desc = "Previous search result, center cursor" })

map({ "n", "v" }, "??", function() vim.api.nvim_feedkeys("?", "n", false) end, { desc = "Reverse search" })
map("n", "?r", function() vim.api.nvim_feedkeys(":%s/", "n", false) end, { desc = "Search & replace in buffer" })
map("v", "?r", function() vim.api.nvim_feedkeys(":s/", "n", false) end, { desc = "Search & replace in selection" })
map("n", "<esc>", "<esc><cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- =============================================================================
-- Clipboard-safe cut/paste
-- =============================================================================

map("v", "p", '"_dP', { desc = "Paste over selection (don't replace clipboard)" })
map("v", "x", '"_x', { desc = "Delete char (don't replace clipboard)" })

-- =============================================================================
-- Indentation
-- =============================================================================

map("v", "<", "<gv", { desc = "Deindent and reselect" })
map("v", ">", ">gv", { desc = "Indent and reselect" })

-- =============================================================================
-- Format by indent (gg=G preserving cursor)
-- =============================================================================

map("n", _G.format_key1.."i", function()
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd("silent! normal! gg=G")
	vim.api.nvim_win_set_cursor(0, pos)
	vim.cmd("normal! zz")
end, { desc = "Format entire buffer (by indent)" })

-- =============================================================================
-- Tab management
-- =============================================================================

map("n", "<c-s-j>", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<c-s-k>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", _G.tab_key1.."o", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", _G.tab_key1.."f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", _G.tab_key1.."l", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", _G.tab_key1.."L", "<cmd>tablist<cr>", { desc = "List tabs" })
map("n", _G.tab_key1.."xc", "<cmd>tabclose<cr>", { desc = "Close current tab" })
map("n", _G.tab_key1.."xo", "<cmd>tabonly<cr>", { desc = "Close other tabs" })

-- =============================================================================
-- Editor misc
-- =============================================================================

map("n", "<c-cr>", "<cmd>restart<cr>", { desc = "Restart Neovim" })
map("i", "<c-p>", "<cmd>normal! p<cr>", { desc = "Paste in insert mode" })

-- =============================================================================
-- External
-- =============================================================================

map("n", "gx", "gx", { desc = "Open URL under cursor in browser" })

-- =============================================================================
-- [DISABLED] Fold toggles
-- =============================================================================
-- map("n", "zl", "zo", { desc = "Open fold" })
-- map("n", "zh", "zc", { desc = "Close fold" })

-- =============================================================================
-- [DISABLED] Move lines up/down (Alt+j/k)
-- =============================================================================
-- map("n", "<a-j>", ":m .+1<cr>==", { desc = "Move line down", silent = true })
-- map("n", "<a-k>", ":m .-2<cr>==", { desc = "Move line up", silent = true })
-- map({ "v", "x" }, "<a-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down", silent = true })
-- map({ "v", "x" }, "<a-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up", silent = true })
