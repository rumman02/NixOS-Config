-- =============================================================================
-- lualine.nvim — Statusline
-- =============================================================================
-- Custom statusline with mode, git branch, diff, diagnostics,
-- file info, LSP status, and position indicators.
-- =============================================================================

return {
	"nvim-lualine/lualine.nvim",
	event = { "BufReadPre", "BufAdd", "BufNewFile" },

	opts = function()
		local icons = require("lib.icons")

		-- -- Custom scrollbar widget for statusline (currently disabled)
		-- local function scrollbar()
		-- 	local SCROLL_BAR = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " }
		-- 	local cursor_pos = vim.api.nvim_win_get_cursor(0)
		-- 	local current_line = cursor_pos[1]
		-- 	local total_lines = vim.api.nvim_buf_line_count(0)
		-- 	local scroll_index = math.min(math.floor((current_line - 1) / total_lines * #SCROLL_BAR) + 1, #SCROLL_BAR)
		-- 	local hl_name = "ScrollBarCustom"
		-- 	vim.api.nvim_set_hl(0, hl_name, { link = "special" })
		-- 	return "%#" .. hl_name .. "#" .. SCROLL_BAR[scroll_index] .. "%*"
		-- end

		return {
			options = {
				theme = "auto",                 -- auto-detect theme from colorscheme
				globalstatus = true,            -- single statusline for entire vim
				component_separators = { left = "", right = "" },
				section_separators = { left = icons.separators.slant_left_1, right = icons.separators.slant_right_1 },
				-- section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {
					"snacks_picker_list",        -- hide when picker is focused
				},
				refresh = {
					statusline = 5,              -- refresh every 5ms
				},
			},

			-- ===================================================================
			-- Sections (left to right: a > b > c | x > y > z)
			-- ===================================================================

			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(mode) return " " .. mode end,
						color = { gui = "bold" },
					},
					-- Hydra statusline (disabled)
					-- { require("hydra.statusline").get_name, cond = require("hydra.statusline").is_active },
					-- Recording indicator
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg == "" then return "" end
							return "REC [" .. reg .. "]"
						end,
					},
				},
				lualine_b = {
					-- Git branch
					{ "branch", icon = "" },
					-- Git diff (added/modified/removed counts)
					{
						"diff",
						symbols = {
							added = icons.git.added .. " ",
							modified = icons.git.modified .. " ",
							removed = icons.git.removed .. " ",
						},
					},
					-- LSP diagnostics summary
					{
						"diagnostics",
						sources = { "nvim_lsp", "nvim_diagnostic" },
						sections = { "error", "warn", "info", "hint" },
						symbols = {
							info = icons.diagnostic.info .. " ",
							error = icons.diagnostic.error .. " ",
							warn = icons.diagnostic.warn .. " ",
							hint = icons.diagnostic.hint .. " ",
						},
					},
				},
				lualine_c = {
					-- Filetype icon (center-left)
					{ "filetype", icon_only = true, padding = { left = 1, right = 0 } },
					-- Filename with modified/readonly indicators
					{
						"filename",
						path = 0,
						symbols = {
							modified = icons.filesystem.modified,
							readonly = " " .. icons.filesystem.readonly,
							unnammed = icons.filesystem.unnammed,
							newfile = icons.filesystem.newfile,
						},
						padding = { left = 0, right = 0 },
					},
				},
				lualine_x = {
					"searchcount",              -- / search match count
					-- LSP status (running servers with spinner)
					{
						"lsp_status",
						icon = "",
						symbols = {
							spinner = { "", "", "", "", "" },
							done = "",
							separator = " | ",
						},
						ignore_lsp = {},
					},
					"encoding",
					"filesize",
					-- File format (unix/dos/mac)
					{
						"fileformat",
						symbols = {
							unix = " ",
							dos = " ",
							mac = " ",
						},
					},
				},
				lualine_y = {
					"filetype",                 -- filetype name
				},
				lualine_z = {
					-- Cursor position (line:col)
					{ "location", padding = { left = 1, right = 0 } },
					-- Scroll progress percentage
					{ "progress" },
					-- Custom scrollbar widget (disabled)
					-- { scrollbar, color = "Spacial" },
				},
			},
		}
	end,
}
