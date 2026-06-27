-- =============================================================================
-- blink.cmp — Autocompletion
-- =============================================================================
-- Rust-powered completion plugin with fuzzy search, snippet support,
-- cmdline completion, signature help, and custom menu rendering.
-- =============================================================================

return {
	"saghen/blink.cmp",
	enabled = true,
	event = {
		"InsertEnter",    -- activate on entering insert mode
		"CmdlineEnter",   -- activate in command-line mode too
	},
	build = "cargo build --release",  -- requires Rust toolchain
	dependencies = {
		"rafamadriz/friendly-snippets",  -- snippet collection
	},

	-- Ensure completion menu plays nice with existing completeopt
	init = function()
		vim.opt.completeopt = "menu,menuone,noinsert"
	end,

	opts = function()
		local utils = require("lib.utils")

		return {
			-- Fuzzy matching implementation (Lua is lighter, Rust is faster)
			fuzzy = { implementation = "lua" },
			-- fuzzy = { implementation = "prefer_rust_with_warning" },

			-- ===================================================================
			-- Completion menu settings
			-- ===================================================================

			completion = {
				-- Auto-add brackets for function calls
				accept = {
					auto_brackets = { enabled = true },
				},

				-- List behavior: preselect first item, cycle from top/bottom
				list = {
					selection = { preselect = true },
					cycle = { from_top = false },
				},

				-- Menu window appearance and layout
				menu = {
					border = utils.ui.float.border,
					min_width = 1,
					max_height = 12,  -- max visible items before scrolling
					draw = {
						treesitter = { "lsp" },  -- syntax-highlight LSP labels
						columns = {
							{ "item_idx" },           -- numbered items (1-9, 0)
							{ "kind_icon" },          -- completion kind icon
							{ "label", "label_description" },
							-- { "source_name" },     -- show which source (lsp, path, etc.)
						},
						components = {
							-- Custom numbered index: show "0" for item 10, blank for >10
							item_idx = {
								text = function(ctx)
									return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
								end,
								highlight = "BlinkCmpItemIdx",
							},
							-- Source name displayed as [source]
							source_name = {
								width = { max = 30 },
								text = function(ctx) return "[" .. ctx.source_name .. "]" end,
								highlight = 'BlinkCmpSource',
							},
							-- -- Use dev icons instead of default kind icons
							-- kind_icon = {
							-- 	text = function(ctx) ... end,
							-- 	highlight = function(ctx) ... end,
							-- }
						},
					},
				},

				-- Auto-show documentation for selected item
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 50,
					update_delay_ms = 50,
					window = { border = utils.ui.float.border },
				},

				-- Ghost text: inline preview of top completion item
				ghost_text = { enabled = false },
			},

			-- ===================================================================
			-- Command-line completion (for : and / modes)
			-- ===================================================================

			cmdline = {
				keymap = {
					preset = "inherit",
					["<c-cr>"] = { "select_and_accept", "fallback" },
				},
				completion = {
					menu = { auto_show = true },
					ghost_text = { enabled = true },
				},
			},

			-- ===================================================================
			-- Signature help (function parameter hints)
			-- ===================================================================

			signature = {
				enabled = true,
				window = { border = utils.ui.float.border },
			},

			-- ===================================================================
			-- Custom keymap (no preset — full control)
			-- ===================================================================

			keymap = {
				preset = "none",  -- disables all default keymaps

				-- Numbered accept keys (match menu item numbers)
				["<c-1>"] = { function(cmp) cmp.accept({ index = 1 }) end },
				["<c-2>"] = { function(cmp) cmp.accept({ index = 2 }) end },
				["<c-3>"] = { function(cmp) cmp.accept({ index = 3 }) end },
				["<c-4>"] = { function(cmp) cmp.accept({ index = 4 }) end },
				["<c-5>"] = { function(cmp) cmp.accept({ index = 5 }) end },
				["<c-6>"] = { function(cmp) cmp.accept({ index = 6 }) end },
				["<c-7>"] = { function(cmp) cmp.accept({ index = 7 }) end },
				["<c-8>"] = { function(cmp) cmp.accept({ index = 8 }) end },
				["<c-9>"] = { function(cmp) cmp.accept({ index = 9 }) end },
				["<c-0>"] = { function(cmp) cmp.accept({ index = 10 }) end },

				-- Navigation: hide, select next/prev, accept
				["<c-h>"] = { "hide", "fallback" },
				["<c-j>"] = { function(cmp)
					if cmp.is_visible() then cmp.select_next({ auto_insert = false }) return true end
					return false
				end, 'fallback' },
				["<c-k>"] = { function(cmp)
					if cmp.is_visible() then cmp.select_prev({ auto_insert = false }) return true end
					return false
				end, 'fallback' },
				["<c-l>"] = { "accept", "fallback" },

				-- Documentation: show/hide
				["<c-;>"] = { "show_documentation", "hide_documentation", "fallback" },

				-- Select with auto-insert (preview as you navigate)
				["<c-p>"] = { function(cmp)
					if cmp.is_visible() then cmp.select_prev({ auto_insert = true }) return true end
					return false
				end, 'fallback' },
				["<c-n>"] = { function(cmp)
					if cmp.is_visible() then cmp.select_next({ auto_insert = true }) return true end
					return false
				end, 'fallback' },

				-- Scroll documentation
				["<c-u>"] = { "scroll_documentation_up", "fallback" },
				["<c-d>"] = { "scroll_documentation_down", "fallback" },

				-- Signature help toggle
				["<c-i>"] = { "show_signature", "hide_signature", "fallback" },

				-- Toggle completion menu
				["<c-space>"] = { "show", "hide", "fallback" },
				["<c-cr>"] = { "select_and_accept", "fallback" },

				-- Snippet navigation
				["<tab>"] = { "snippet_forward", "fallback" },
				["<s-tab>"] = { "snippet_backward", "fallback" },
			},

			-- ===================================================================
			-- Completion sources
			-- ===================================================================

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					lsp = {
						fallbacks = {},  -- no fallbacks for LSP
					},
					buffer = {
						opts = {
							get_bufnrs = vim.api.nvim_list_bufs  -- search all buffers
						},
					},
					path = {
						opts = {
							get_cwd = function(_) return vim.fn.getcwd() end,
						},
					},
				},
			},
		}
	end,
}
