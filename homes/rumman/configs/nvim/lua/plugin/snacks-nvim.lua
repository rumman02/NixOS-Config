-- =============================================================================
-- snacks.nvim — Collection of QoL modules
-- =============================================================================
-- Large all-in-one plugin providing: dashboard, picker, terminal, notifier,
-- zen mode, dimming, big file handling, status column, scratch buffers, etc.
-- Eagerly loaded (not lazy) since dashboard loads on startup.
-- =============================================================================

return {
	"folke/snacks.nvim",
	enabled = true,
	lazy = false,
	priority = 1000,

	-- ===================================================================
	-- Dependencies
	-- ===================================================================

	dependencies = {
		{
			"folke/persistence.nvim",  -- session management
			opts = {
				options = {
					pre_save = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
					end,
				},
			},
		},
	},

	-- ===================================================================
	-- Keymaps
	-- ===================================================================

	keys = function()
		return {
			-- Picker shortcuts (most disabled, using fzf-lua)
			{ _G.find_key1 .. "i", function() Snacks.picker.icons() end, desc = "P[I]cker icons" },

			-- Notification history
			{ _G.history_key1 .. "n", function() Snacks.notifier.show_history() end, desc = "Notification history" },

			-- Terminal
			{ _G.terminal_key1 .. "s", function() Snacks.terminal.toggle(nil, { win = { position = "right", width = 0.3 } }) end, desc = "Terminal right" },
			{ _G.terminal_key1 .. "S", function() Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.3 } }) end, desc = "Terminal bottom" },

			-- Zen mode
			{ _G.fold_key1 .. "Z", function() Snacks.zen.zoom() end, desc = "Zoom" },
			{ _G.fold_key1 .. "z", function() Snacks.dim() end, desc = "Dim" },
			{ _G.fold_key1 .. "d", function() Snacks.zen.zoom() end, desc = "Dim (dim only)" },
		}
	end,

	-- ===================================================================
	-- Configuration
	-- ===================================================================

	opts = function()
		local utils = require("lib.utils")
		local icons = require("lib.icons")

		return {
			-- Animation settings
			animate = {
				enabled = false,
				fps = utils.ui.frame_rate,
			},

			-- Big file handling: disable heavy features for large files
			bigfile = {
				enabled = true,
				size = 1.5 * 1024 * 1024,  -- 1.5MB threshold
				line_length = 1000,
			},

			-- Clean buffer deletion (no empty buffers left)
			bufdelete = { enabled = true },

			-- ===================================================================
			-- Dashboard (startup screen)
			-- ===================================================================

			dashboard = (function()
				local version = vim.version()
				local nvim_version = " " .. version.major .. "." .. version.minor .. "." .. version.patch

				local go_marks = function()
					local char = vim.fn.input("Mark: ")
					if char ~= "" then
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("'" .. char, true, false, true),
							"n", false
						)
					else
						vim.notify("No char inserted")
					end
				end

				return {
					enabled = true,
					preset = {
						header = "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗\n"
						.. "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║\n"
						.. "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║\n"
						.. "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║\n"
						.. "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║\n"
						.. "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝\n"
						.. "                                           " .. nvim_version,
						keys = {
							-- Navigation
							{ key = "e", icon = "󰁂 ", desc = "Open explorer", action = function() vim.cmd("Neotree") end },
							{ key = "f", icon = "󰱼 ", desc = "Find files", action = function() vim.cmd("FzfLua files") end },
							{ key = "w", icon = "󱎸 ", desc = "Find text", action = function() vim.cmd("FzfLua live_grep") end },
							{ key = "r", icon = "󱋡 ", desc = "Find recents", action = function() vim.cmd("FzfLua oldfiles") end },

							-- Session
							{ key = "s", icon = "󰑌 ", desc = "Restore session", action = require("persistence").load },
							{ key = "S", icon = "󱈅 ", desc = "Find sessions", action = function() require("persistence").select() end },

							-- Management
							{ key = "p", icon = "󰐱 ", desc = "Plugin manager", action = "<cmd>Lazy<cr>", enabled = package.loaded.lazy ~= nil },
							{ key = "m", icon = "󰇖 ", desc = "Server manager", action = "<cmd>Mason<cr>" },
							{ key = "c", icon = "󰒓 ", desc = "Configs", action = function() Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") }) end },

							-- Misc
							{ key = "n", icon = "󰒓 ", desc = "New file", action = "<cmd>ene<Bar>startinsert<cr>" },
							{ key = "'", icon = "󰍎 ", desc = "Go marks", action = go_marks },
							{ key = "q", icon = "󰍃 ", desc = "Quit", action = "<cmd>quit<cr>" },
						},
					},
					formats = {
						icon = function(item)
							if item.file then
								if item.icon == "file" then
									return { icons.filesystem.file.default, width = 2, hl = "icon" }
								elseif item.icon == "directory" then
									return { icons.filesystem.folder.default, width = 2, hl = "icon" }
								end
							end
							return { item.icon, width = 2, hl = "icon" }
						end,
					},
					sections = {
						{ section = "header" },
						{ section = "keys", gap = 0, padding = { 2, 0 } },
						{ icon = icons.filesystem.file.default, title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 0 }, limit = 5 },
						{ icon = icons.filesystem.folder.default, title = "Projects", section = "projects", indent = 2, padding = { 2, 0 }, limit = 5 },
						{ icon = os.date("  %d-%m-%Y  󱑁 %I:%M:%S %p") .. "\n󰉁 ", section = "startup" },
					},
				}
			end)(),

			-- Debug mode
			debug = { enabled = true },

			-- Dimming non-active windows
			dim = {
				enabled = true,
				scope = {
					min_size = 1,
					max_size = 100,
					siblings = false,
				},
			},

			-- File explorer (disabled, using neo-tree)
			explorer = { enabled = false },

			-- Git integration
			git = {},
			gitbrowse = {},

			-- Image preview
			image = { enabled = true },

			-- Indent guide
			indent = {
				indent = { enabled = false },
				chunk = {
					enabled = true,
					char = {
						corner_top = utils.ui.float.border[1],
						corner_bottom = utils.ui.float.border[7],
						horizontal = utils.ui.float.border[2],
						vertical = utils.ui.float.border[4],
						arrow = "",
					},
				},
			},

			-- LazyGit integration (disabled, using lazygit.nvim)
			lazygit = {
				enabled = false,
				theme = {
					activeBorderColor = { fg = "@namespace", bold = true },
					inactiveBorderColor = { fg = "Comment" },
				},
			},

			-- Input prompt
			input = { enabled = true },

			-- Layout
			layout = {},

			-- Notification display
			notifier = {
				enabled = true,
				timer = 3000,  -- 3 second timeout
				icons = {
					error = icons.diagnostic.error,
					warn = icons.diagnostic.warn,
					info = icons.diagnostic.info,
					hint = icons.diagnostic.hint,
				},
			},
			notify = { enabled = true },

			-- ===================================================================
			-- Picker (fzf-like search)
			-- ===================================================================

			picker = {
				enabled = true,
				matcher = {
					frecency = true,  -- sort by frequency + recency
				},
				layouts = {
					default = { layout = { width = utils.ui.float.width + 0.02, height = utils.ui.float.height + 0.02 } },
					telescope = { layout = { width = utils.ui.float.width + 0.02, height = utils.ui.float.height + 0.02 } },
				},
				sources = {
					buffers = { layout = { preset = "select" } },
					colorschemes = { layout = { preset = "vscode" } },
					diagnostics = { layout = { preset = "right" } },
					files = { hidden = true, ignored = true, layout = { preset = "default" } },
					commands = { layout = { preset = "vscode" } },
					undo = { preview = "diff", layout = { preset = "default" } },
					explorer = {
						diagnostics_open = true,
						git_status_open = true,
						layout = { cycle = false },
						formatters = { severity = { pos = "right" } },
						win = {
							list = {
								keys = {
									["<bs>"] = false,
									["."] = false,
									["<m-h>"] = false,
									["<m-i>"] = false,
									["w"] = "",       ["e"] = "",     ["q"] = "close",
									["h"] = "explorer_close",
									["l"] = "confirm",
									["<"] = "explorer_up",
									[">"] = "explorer_focus",
									["H"] = "toggle_hidden",
									["I"] = "toggle_ignored",
									["[g"] = "explorer_git_next",
									["]g"] = "explorer_git_prev",
									["[d"] = "explorer_diagnostic_next",
									["]d"] = "explorer_diagnostic_prev",
									["[w"] = "explorer_warn_next",
									["]w"] = "explorer_warn_prev",
									["[e"] = "explorer_error_next",
									["]e"] = "explorer_error_prev",
									["[i"] = "explorer_info_next",
									["]i"] = "explorer_info_prev",
									["[h"] = "explorer_hint_next",
									["]h"] = "explorer_hint_prev",
								},
							},
						},
					},
				},
				icons = {
					files = { dir = icons.filesystem.folder.default, dir_open = icons.filesystem.folder.opened, file = icons.filesystem.file.default },
					tree = { vertical = " ", middle = " ", last = " " },
					git = {
						commit = icons.git.commit, staged = icons.git.staged, added = icons.git.added,
						deleted = icons.git.deleted, ignored = icons.git.ignored, modified = icons.git.modified,
						renamed = icons.git.renamed, unmerged = icons.git.unmerged, untracked = icons.git.untracked,
					},
					diagnostics = { Info = icons.diagnostic.info, Error = icons.diagnostic.error, Warn = icons.diagnostic.warn, Hint = icons.diagnostic.hint },
				},
			},

			-- Profiler
			profiler = {},

			-- Quick file handling
			quickfile = { enabled = true },

			-- File renaming with live preview
			rename = { enabled = true },

			-- Buffer scope
			scope = { enabled = true },

			-- Window style presets
			styles = {
				scratch = { width = utils.ui.float.width, height = utils.ui.float.height },
				lazygit = { wo = { winbar = "" }, backdrop = 100, width = 0.99, height = 0.99 },
				notification_history = { width = utils.ui.float.width, height = utils.ui.float.height },
				terminal = { wo = { winbar = "Terminal: %{b:snacks_terminal.id}" } },
				zen = { backdrop = { transparent = false } },
			},

			-- Scratch buffers
			scratch = { enabled = true },

			-- Smooth scrolling
			scroll = { enabled = false },

			-- Status column (sign + fold column)
			statuscolumn = {
				enabled = true,
				left = { "mark", "sign" },
				right = { "fold", "git" },
			},

			-- Integrated terminal
			terminal = {
				enabled = true,
				start_insert = true,
				auto_insert = true,
			},

			-- Toggle plugin
			toggle = { enabled = true },

			-- Utilities
			util = {},
			win = {},

			-- Word highlighting
			words = { enabled = false },

			-- Zen mode (zoom/dim)
			zen = {
				enabled = true,
				toggles = { dim = false },
			},
		}
	end,
}

-- ============================================================
-- Available picker layout presets:
-- bottom, default, dropdown, ivy, ivy_split, left, right,
-- select, sidebar, telescope, top, vertical, vscode
-- ============================================================
