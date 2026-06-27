-- =============================================================================
-- Autocommands
-- =============================================================================
-- All vim.api.nvim_create_autocmd definitions.
-- Each autocmd is grouped in its own augroup (clear = true prevents duplicates).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Dynamic cursorcolumn: show colorcolumn at column 80 only in normal mode
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("DynamicCursorColumn", { clear = true }),
	desc = "Show column 80 guide in normal mode, hide when inserting (skip picker buffers)",
	callback = function(e)
		local ev = e.event == "InsertEnter"
		local buf = vim.bo[e.buf].filetype == "snacks_picker"
		vim.opt.colorcolumn = ev and not buf and "80" or ""
	end,
})

-- -----------------------------------------------------------------------------
-- Highlight yanked text briefly after yanking
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
	desc = "Flash highlight when yanking text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- -----------------------------------------------------------------------------
-- Ensure file ends with a blank line (trailing newline)
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("CreateBlankAtEOF", { clear = true }),
	desc = "Append a blank line at EOF if missing before saving",
	callback = function()
		if vim.bo.modifiable and vim.fn.getline(vim.fn.line("$")) ~= "" then
			vim.fn.append(vim.fn.line("$"), "")
		end
	end,
})

-- -----------------------------------------------------------------------------
-- Prevent auto-comment continuation on new lines (o/O/Enter)
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("DisableAutoComment", { clear = true }),
	desc = "Remove c/r/o from formatoptions so new lines don't auto-continue comments",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- -----------------------------------------------------------------------------
-- [DISABLED] Disable line numbers for very large buffers (>999999 lines)
--             Uncomment if large files cause performance issues
-- -----------------------------------------------------------------------------
--[[ vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
	group = vim.api.nvim_create_augroup("DisableNumber", { clear = true }),
	pattern = "*",
	callback = function(args)
		local buf = args.buf
		local line_count = vim.api.nvim_buf_line_count(buf)
		if line_count > 999999 then
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
		end
	end,
	desc = "Disable line numbers for large files"
}) ]]

-- -----------------------------------------------------------------------------
-- Persist and restore window view (folds, cursor position, etc.) per file.
-- Uses mkview/loadview, which stores data in the viewdir.
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("PersistedFold", { clear = true }),
	desc = "Save window view (folds, cursor, etc.) before leaving or saving",
	callback = function()
		-- Only save view for normal files (not special buffers like terminals or help)
		if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
			vim.cmd("silent! mkview")
		end
	end,
})

-- Load view on buffer enter
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = "PersistedFold",
	desc = "Restore window view when entering a buffer",
	callback = function()
		-- Only load view for normal files
		if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
			vim.cmd("silent! loadview")
		end
	end,
})

-- -----------------------------------------------------------------------------
-- [DISABLED] Show diagnostics float window on cursor hold (idle in normal mode)
--             Uncomment to get inline diagnostic popups when pausing on a line
-- -----------------------------------------------------------------------------
--[[ vim.api.nvim_create_autocmd("LspAttach", {
	group = "UserLspConfig",
	callback = function(args)
		local bufnr = args.buf
		vim.api.nvim_create_autocmd("CursorHold", {
			group = vim.api.nvim_create_augroup("UserLspDiagnosticOpenFloat", { clear = true }),
			buffer = bufnr,
			callback = function()
				if vim.api.nvim_get_mode().mode ~= "n" then
					return
				end
				local line_diagnostics = vim.diagnostic.get(bufnr, {
					lnum = vim.fn.line(".") - 1,
				})
				if next(line_diagnostics) then
					vim.diagnostic.open_float(nil, {
						focusable = false,
						close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertEnter" },
						scope = "line",     -- "cursor" for exact position
						source = "always",
					})
				end
			end,
		})
	end,
}) ]]

-- -----------------------------------------------------------------------------
-- Sync mini.files renames with Snacks for proper file tracking
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesActionRename",
	desc = "Trigger Snacks.rename when mini.files renames a file",
	callback = function(event)
		Snacks.rename.on_rename_file(event.data.from, event.data.to)
	end,
})

-- -----------------------------------------------------------------------------
-- Customize mini.files window appearance on open
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd('User', {
	pattern = 'MiniFilesWindowOpen',
	desc = "Style mini.files window: transparent background, rounded border with right-aligned title",
	callback = function(args)
		local win_id = args.data.win_id

		vim.wo[win_id].winblend = 0                    -- fully opaque window
		local config = vim.api.nvim_win_get_config(win_id)
		config.border, config.title_pos = 'rounded', 'right'
		vim.api.nvim_win_set_config(win_id, config)     -- apply new border/title styling
	end,
})
