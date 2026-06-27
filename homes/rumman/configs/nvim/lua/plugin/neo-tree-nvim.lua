-- =============================================================================
-- neo-tree.nvim — File explorer
-- =============================================================================
-- Multi-source file explorer: filesystem, buffers, git status.
-- Uses floating window with custom mappings, icons, and git/diagnostics.
-- =============================================================================

return {
	"nvim-neo-tree/neo-tree.nvim",
	enabled = true,
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		{ "s1n7ax/nvim-window-picker", version = "2.*", opts = {} },
	},

	-- ===================================================================
	-- Keymaps
	-- ===================================================================

	keys = function()
		local explorer_key1 = _G.explorer_key1

		-- Toggle reveal-current-file behavior
		local neotree_reveal_cwd = function(is_enabled, is_leave_dir_opened)
			local config = require("neo-tree").config or {}
			config.filesystem = config.filesystem or {}
			config.filesystem.follow_current_file = {
				enabled = is_enabled,
				leave_dirs_open = is_leave_dir_opened,
			}
			require("neo-tree").setup(config)

			if is_enabled and is_leave_dir_opened then
				vim.notify("Neotree: Reveal current file enabled,\n(Leave directory opened)")
			elseif is_enabled and not is_leave_dir_opened then
				vim.notify("Neotree: Reveal current file enabled,\n(Leave directory closed)")
			else
				vim.notify("Neotree: Reveal current file disabled")
			end

			vim.cmd("Neotree close")
			vim.cmd("Neotree")
		end

		return {
			{ explorer_key1 .. "e", "<cmd>Neotree toggle<cr>", desc = "Toggle explorer" },
			{ explorer_key1 .. "b", "<cmd>Neotree buffers<cr>", desc = "[B]uffers" },
			{ explorer_key1 .. "c", "<cmd>Neotree focus reveal filesystem<cr>", desc = "[R]eveal current" },
			{ explorer_key1 .. "g", "<cmd>Neotree git_status<cr>", desc = "[G]it status" },
			{ explorer_key1 .. "f", "<cmd>Neotree focus<cr>", desc = "[F]ocus" },
			{ explorer_key1 .. "mh", "<cmd>Neotree left<cr>", desc = "Position left" },
			{ explorer_key1 .. "mj", "<cmd>Neotree bottom<cr>", desc = "Position bottom" },
			{ explorer_key1 .. "mk", "<cmd>Neotree top<cr>", desc = "Position top" },
			{ explorer_key1 .. "ml", "<cmd>Neotree right<cr>", desc = "Position right" },
			{ explorer_key1 .. "mf", "<cmd>Neotree focus float<cr>", desc = "[F]loat" },
			{ explorer_key1 .. "x", "<cmd>Neotree close<cr><cmd>Neotree close filesystem<cr><cmd>Neotree close buffers<cr><cmd>Neotree close git_status<cr>", desc = "Close all" },
			{ explorer_key1 .. "rr", "<cmd>Neotree reveal<cr>", desc = "[R]eveal current" },
			{ explorer_key1 .. "ro", function() neotree_reveal_cwd(true, true) end, desc = "[O]pened (follow, keep open)" },
			{ explorer_key1 .. "rc", function() neotree_reveal_cwd(true, false) end, desc = "[C]losed (follow, close dirs)" },
			{ explorer_key1 .. "rx", function() neotree_reveal_cwd(false, false) end, desc = "Off (no follow)" },
		}
	end,

	-- ===================================================================
	-- Configuration
	-- ===================================================================

	opts = function()
		local utils = require("lib.utils")
		local icons = require("lib.icons")

		return {
			use_default_mappings = false,     -- use only custom mappings
			close_if_last_window = true,      -- close neo-tree if last window
			popup_border_style = "rounded",
			use_image_nvim = true,            -- support image preview
			enable_git_status = true,
			enable_diagnostics = true,
			separator = { left = "▏", right = "▕" },

			-- ===================================================================
			-- Source selector (filesystem, buffers, git status tabs)
			-- ===================================================================

			source_selector = {
				winbar = false,
				statusline = false,
				sources = {
					{ source = "filesystem", display_name = " 󰁂 Files " },
					{ source = "buffers", display_name = " 󰓩 Buffers " },
					{ source = "git_status", display_name = " 󰘬 Git " },
				},
				content_layout = "center",
				tabs_layout = "equal",
			},

			-- ===================================================================
			-- Default component configs (shared across sources)
			-- ===================================================================

			default_component_configs = {
				container = { enable_character_fade = true },
				indent = {
					with_markers = true,
					indent_size = utils.indent.explorer,
					padding = 0,
					indent_marker = "│",
					last_indent_marker = "─",
					highlight = "NeoTreeIndentMarker",
					with_expanders = nil,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = icons.filesystem.folder.default,
					folder_open = icons.filesystem.folder.opened,
					folder_empty = icons.filesystem.folder.empty,
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = icons.filesystem.modified,
					highlight = "NeoTreeModified",
				},
				diagnostics = {
					symbols = {
						hint = icons.diagnostic.hint,
						info = icons.diagnostic.info,
						warn = icons.diagnostic.warn,
						error = icons.diagnostic.error,
					},
				},
				git_status = {
					symbols = {
						added = icons.git.added,
						deleted = icons.git.removed,
						modified = icons.git.modified,
						renamed = icons.git.renamed,
						untracked = icons.git.untracked,
						ignored = icons.git.ignored,
						unstaged = icons.git.unstaged,
						staged = icons.git.staged,
						conflict = icons.git.conflict,
					},
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = false,  -- use filetype icon colors instead
					highlight = "NeoTreeFileName",
				},
			},

			-- ===================================================================
			-- Window settings and global mappings
			-- ===================================================================

			window = {
				position = "left",
				width = "35",
				mapping_options = { noremap = true, nowait = true },
				mappings = {
					-- Remove default keys that conflict with other mappings
					["o"] = "none",        ["O"] = "none",
					["w"] = "none",        ["0"] = "none",
					["b"] = "none",        ["e"] = "none",
					["z"] = "none",        ["s"] = "none",
					["$"] = "none",        ["<space>"] = "none",

					-- Navigation
					["R"] = "refresh",
					["i"] = "show_file_details",
					["E"] = "expand_all_nodes",
					["l"] = "toggle_node",
					["h"] = "close_node",
					["C"] = "close_all_nodes",
					["S"] = "close_all_subnodes",
					["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
					["I"] = "focus_preview",
					["<C-y>"] = { "scroll_preview", config = { direction = 1 } },
					["<C-e>"] = { "scroll_preview", config = { direction = -1 } },
					["<C-u>"] = { "scroll_preview", config = { direction = 10 } },
					["<C-d>"] = { "scroll_preview", config = { direction = -10 } },
					["<C-b>"] = { "scroll_preview", config = { direction = 30 } },
					["<C-f>"] = { "scroll_preview", config = { direction = -30 } },
					["q"] = "close_window",
					["<cr>"] = "open",
					["<c-s-l>"] = "next_source",
					["<c-s-h>"] = "prev_source",

					-- ===================================================================
					-- Custom <localleader> mappings
					-- ===================================================================

					["<localleader><space>"] = { "refresh", desc = "Refresh" },
					["<localleader>q"] = { "close_window", desc = "Quit" },
					["<localleader>P"] = { "toggle_preview", desc = "Toggle preview" },
					["<localleader>I"] = { "focus_preview", desc = "Focus preview" },

					-- File operations
					["<localleader>f"] = { function() end, desc = "File", nowait = false },
					["<localleader>fo"] = { function() end, desc = "Open", nowait = false },
					["<localleader>foh"] = { "open_leftabove_vs", desc = "Left" },
					["<localleader>fol"] = { "open_vsplit", desc = "Right" },
					["<localleader>foj"] = { "open_split", desc = "Down" },
					["<localleader>fop"] = { function() end, desc = "Picker", nowait = false },
					["<localleader>fopc"] = { "open_with_window_picker", desc = "Current" },
					["<localleader>foph"] = { "split_with_window_picker", desc = "Horizontal" },
					["<localleader>fopv"] = { "vsplit_with_window_picker", desc = "Vertical" },
					["<localleader>fot"] = { function() end, desc = "As tab", nowait = false },
					["<localleader>fotn"] = { "open_tabnew", desc = "New" },
					["<localleader>fotd"] = { "open_tab_drop", desc = "Drop" },

					-- Git operations
					["<localleader>g"] = { function() end, desc = "Git", nowait = false },
					["<localleader>ga"] = { "git_add_file", desc = "Stage file" },
					["<localleader>gA"] = { "git_add_all", desc = "Stage all" },
					["<localleader>gu"] = { "git_unstage_file", desc = "Unstage" },
					["<localleader>gr"] = { "git_revert_file", desc = "Revert" },
					["<localleader>gc"] = { "git_commit", desc = "Commit" },
					["<localleader>gp"] = { "git_push", desc = "Push" },
					["<localleader>gg"] = { "git_commit_and_push", desc = "Commit & push" },

					-- Ordering
					["<localleader>o"] = { function() end, desc = "Order by", nowait = false },
					["<localleader>oc"] = { "order_by_created", desc = "Created" },
					["<localleader>od"] = { "order_by_diagnostics", desc = "Diagnostics" },
					["<localleader>og"] = { "order_by_git_status", desc = "Git status" },
					["<localleader>om"] = { "order_by_modified", desc = "Modified" },
					["<localleader>on"] = { "order_by_name", desc = "Name" },
					["<localleader>os"] = { "order_by_size", desc = "Size" },
					["<localleader>ot"] = { "order_by_type", desc = "Type" },

					-- Node operations
					["<localleader>h"] = { "close_node", desc = "Close node" },
					["<localleader>l"] = { "toggle_node", desc = "Toggle node" },
					["<localleader>S"] = { "close_all_subnodes", desc = "Close sub-nodes" },
					["<localleader>C"] = { "close_all_nodes", desc = "Close all" },
					["<localleader>E"] = { "expand_all_nodes", desc = "Expand all" },
					["<localleader>i"] = { "show_file_details", desc = "Show details" },
				},
			},

			-- ===================================================================
			-- Filesystem source
			-- ===================================================================

			filesystem = {
				hijack_netrw_behavior = "open_default",
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
					hide_by_name = { "node_modules", ".git" },
					visible = false,
					hide_by_pattern = {},
					always_show = {},
					always_show_by_pattern = {},
					never_show = {},
					never_show_by_pattern = {},
				},
				follow_current_file = { enabled = false, leave_dirs_open = false },
				group_empty_dirs = false,
				use_libuv_file_watcher = true,  -- auto-refresh on file changes
				window = {
					mappings = {
						-- File operations
						["a"] = "add",
						["A"] = "add_directory",
						["d"] = "delete",
						["r"] = "rename",       -- was basename, now full rename
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						-- Git navigation
						["]g"] = "prev_git_modified",
						["[g"] = "next_git_modified",
						-- Navigation
						["<"] = "navigate_up",
						[">"] = "set_root",
						["H"] = "toggle_hidden",
						-- Fuzzy find
						["/"] = "fuzzy_sorter",
						["f"] = "fuzzy_finder",
						["F"] = "fuzzy_finder_directory",
						-- Custom <localleader> bindings
						["<localleader>d"] = { "delete", desc = "Delete" },
						["<localleader>r"] = { "rename_basename", desc = "Rename (no ext)" },
						["<localleader>R"] = { "rename", desc = "Rename (full)" },
						["<localleader>a"] = { "add", desc = "Add file" },
						["<localleader>A"] = { "add_directory", desc = "Add directory" },
						["<localleader>p"] = { "paste_from_clipboard", desc = "Paste" },
						["<localleader>x"] = { "cut_to_clipboard", desc = "Cut" },
						["<localleader>y"] = { "copy_to_clipboard", desc = "Copy" },
						["<localleader>gp"] = { "prev_git_modified", desc = "Prev git mod" },
						["<localleader>gn"] = { "next_git_modified", desc = "Next git mod" },
						["<localleader><"] = { "navigate_up", desc = "Navigate up" },
						["<localleader>>"] = { "set_root", desc = "Set root" },
						["<localleader>H"] = { "toggle_hidden", desc = "Toggle hidden" },
						["<localleader>/"] = { "fuzzy_sorter", desc = "Fuzzy find" },
						["<localleader>f"] = { "fuzzy_finder", desc = "File" },
						["<localleader>F"] = { "fuzzy_finder_directory", desc = "Directory" },
					},
					fuzzy_finder_mappings = {
						["<c-n>"] = "move_cursor_down",
						["<c-p>"] = "move_cursor_up",
						["<c-j>"] = "move_cursor_down",
						["<c-k>"] = "move_cursor_up",
					},
				},
			},

			-- ===================================================================
			-- Buffers source
			-- ===================================================================

			buffers = {
				follow_current_file = { enabled = true, leave_dirs_open = false },
				group_empty_dirs = true,
				show_unloaded = true,
				window = {
					mappings = {
						["d"] = "buffer_delete",
						["<"] = "navigate_up",
						[">"] = "set_root",
						["<localleader>d"] = { "buffer_delete", desc = "Buffer delete" },
					},
				},
			},

			-- ===================================================================
			-- Git status source
			-- ===================================================================

			git_status = {
				window = {
					mappings = {
						["<localleader>ga"] = { function() end, desc = "Add", nowait = false },
						["<localleader>gaa"] = { "git_add_all", desc = "All" },
						["<localleader>gac"] = { "git_add_file", desc = "Current" },
						["<localleader>gu"] = { "git_unstage_file", desc = "Unstage" },
						["<localleader>gr"] = { "git_revert_file", desc = "Revert" },
						["<localleader>gc"] = { "git_commit", desc = "Commit" },
						["<localleader>gp"] = { "git_push", desc = "Push" },
						["<localleader>gg"] = { "git_commit_and_push", desc = "Commit & push" },
					},
				},
			},

			-- ===================================================================
			-- Event handlers
			-- ===================================================================

			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						vim.opt_local.foldenable = false  -- disable folds in neo-tree
					end,
				},
			},
		}
	end,
}
