-- =============================================================================
-- fzf-lua — Fuzzy finder
-- =============================================================================
-- Fast fuzzy search for files, buffers, git, LSP symbols, and more.
-- Uses fzf backend with floating window UI.
-- =============================================================================

return {
	"ibhagwan/fzf-lua",
	enabled = true,
	cmd = "FzfLua",

	-- ===================================================================
	-- Keymaps: <leader>f for primary searches, <leader>f<leader> for advanced
	-- ===================================================================

	keys = function()
		return {
			-- Primary search
			{ _G.find_key1 .. "a", "<cmd>FzfLua<cr>", desc = "[A]ll" },
			{ _G.find_key1 .. "b", "<cmd>FzfLua buffers<cr>", desc = "[B]uffers" },
			{ _G.find_key1 .. "c", "<cmd>FzfLua commands<cr>", desc = "[C]ommands" },
			{ _G.find_key1 .. "C", "<cmd>FzfLua colorschemes<cr>", desc = "[C]olorscheme" },
			{ _G.find_key1 .. "d", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "[D]iagnostics" },
			{ _G.find_key1 .. "f", "<cmd>FzfLua files<cr>", desc = "[F]iles" },
			{ _G.find_key1 .. "gb", "<cmd>FzfLua git_branches<cr>", desc = "Git [B]ranches" },
			{ _G.find_key1 .. "gf", "<cmd>FzfLua git_files<cr>", desc = "Git [F]iles" },
			{ _G.find_key1 .. "gl", "<cmd>FzfLua git_commits<cr>", desc = "Git [L]og" },
			{ _G.find_key1 .. "gs", "<cmd>FzfLua git_status<cr>", desc = "Git [S]tatus" },
			{ _G.find_key1 .. "gS", "<cmd>FzfLua git_stash<cr>", desc = "Git [S]tash" },
			{ _G.find_key1 .. "gw", "<cmd>FzfLua live_grep<cr>", desc = "Grep [W]ord" },
			{ _G.find_key1 .. "h", "<cmd>FzfLua help_tags<cr>", desc = "[H]elp" },
			{ _G.find_key1 .. "H", "<cmd>FzfLua highlights<cr>", desc = "[H]ighlights" },
			{ _G.find_key1 .. "j", "<cmd>FzfLua jumps<cr>", desc = "[J]umps" },
			{ _G.find_key1 .. "k", "<cmd>FzfLua keymaps<cr>", desc = "[K]eymaps" },
			{ _G.find_key1 .. "l", "<cmd>FzfLua loclist<cr>", desc = "[L]ocation list" },
			{ _G.find_key1 .. "m", "<cmd>FzfLua marks<cr>", desc = "[M]arks" },
			{ _G.find_key1 .. "p", "<cmd>FzfLua files<cr>", desc = "[P]rojects" },
			{ _G.find_key1 .. "q", "<cmd>FzfLua quickfix<cr>", desc = "[Q]uickfix" },
			{ _G.find_key1 .. "r", "<cmd>FzfLua registers<cr>", desc = "[R]egisters" },
			{ _G.find_key1 .. "R", "<cmd>FzfLua resume<cr>", desc = "[R]esume" },
			{ _G.find_key1 .. "s", "<cmd>FzfLua spell_suggest<cr>", desc = "[S]pell" },
			{ _G.find_key1 .. "w", "<cmd>FzfLua live_grep<cr>", desc = "[W]ords" },

			-- Advanced search (<leader>f<leader>)
			{ _G.find_key2 .. "ch", "<cmd>FzfLua command_history<cr>", desc = "Command [H]istory" },
			{ _G.find_key2 .. "fc", "<cmd>FzfLua files cwd=~/.config<cr>", desc = "[C]onfig files" },
			{ _G.find_key2 .. "fr", "<cmd>FzfLua oldfiles<cr>", desc = "[R]ecent files" },
			{ _G.find_key2 .. "glf", "<cmd>FzfLua git_bcommits<cr>", desc = "Git [F]ile commits" },
			{ _G.find_key2 .. "gll", "<cmd>FzfLua git_commits<cr>", desc = "Git [L]ine log" },
			{ _G.find_key2 .. "ldc", "<cmd>FzfLua lsp_document_diagnostics<cr>", desc = "LSP diags [C]urrent" },
			{ _G.find_key2 .. "lDd", "<cmd>FzfLua lsp_definitions<cr>", desc = "LSP [D]efinitions" },
			{ _G.find_key2 .. "lDt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "LSP [T]ype defs" },
			{ _G.find_key2 .. "le", "<cmd>FzfLua lsp_declarations<cr>", desc = "LSP d[E]clarations" },
			{ _G.find_key2 .. "li", "<cmd>FzfLua lsp_implementations<cr>", desc = "LSP [I]mplementations" },
			{ _G.find_key2 .. "lr", "<cmd>FzfLua lsp_references<cr>", desc = "LSP [R]eferences" },
			{ _G.find_key2 .. "lsd", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "LSP [D]ocument symbols" },
			{ _G.find_key2 .. "lsw", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "LSP [W]orkspace symbols" },
			{ _G.find_key2 .. "j", "<cmd>FzfLua jumps<cr>", desc = "[J]umps" },
			{ _G.find_key2 .. "wc", "<cmd>FzfLua grep_curbuf<cr>", desc = "Grep [C]urrent buffer" },
			{ _G.find_key2 .. "wC", "<cmd>FzfLua grep_cword<cr>", desc = "Grep [C]ursor word" },
			{ _G.find_key2 .. "r", "<cmd>FzfLua registers<cr>", desc = "[R]egisters" },
			{ _G.find_key2 .. "R", "<cmd>FzfLua resume<cr>", desc = "[R]esume" },
			{ _G.find_key2 .. "s", "<cmd>FzfLua spell_suggest<cr>", desc = "[S]pell" },
			{ _G.find_key2 .. "Sh", "<cmd>FzfLua search_history<cr>", desc = "Search [H]istory" },
		}
	end,

	opts = function()
		local utils = require("lib.utils")
		local icons = require("lib.icons")

		return {
			winopts = {
				height = utils.ui.float.height,
				width = utils.ui.float.width,
				row = 0.50,
				col = 0.50,
				border = utils.ui.float.border,
				backdrop = utils.ui.backdrop,
				title_pos = utils.ui.title_position,
				preview = {
					border = utils.ui.float.border,
					wrap = utils.options.wrap,
					title_pos = utils.ui.title_position,
				},
				-- Navigation keys inside fzf prompt
				on_create = function()
					vim.keymap.set("t", "<c-h>", "<left>", { buffer = true })
					vim.keymap.set("t", "<c-j>", "<down>", { buffer = true })
					vim.keymap.set("t", "<c-k>", "<up>", { buffer = true })
					vim.keymap.set("t", "<c-l>", "<right>", { buffer = true })
				end,
				on_close = function()
				end,
			},

			-- ===================================================================
			-- Keymap bindings
			-- ===================================================================

			keymap = {
				fzf = {
					["ctrl-a"] = "toggle-all",
					["ctrl-q"] = "select-all+accept",
				},
				builtin = {
					["<localleader><M-Esc>"] = "hide",        -- hide and resume later
					["<localleader><F1>"] = "toggle-help",
					["<localleader><F2>"] = "toggle-fullscreen",
					["<localleader><F3>"] = "toggle-preview-wrap",
					["<localleader><F4>"] = "toggle-preview",
					["<localleader><F5>"] = "toggle-preview-ccw",   -- rotate counter-clockwise
					["<localleader><F6>"] = "toggle-preview-cw",    -- rotate clockwise
					["<localleader><F7>"] = "toggle-preview-ts-ctx",
					["<localleader><F8>"] = "preview-ts-ctx-dec",
					["<localleader><F9>"] = "preview-ts-ctx-inc",
					["<localleader><S-Left>"] = "preview-reset",
					["<localleader><S-down>"] = "preview-page-down",
					["<localleader><S-up>"] = "preview-page-up",
					["<localleader><M-S-down>"] = "preview-down",
					["<localleader><M-S-up>"] = "preview-up",
				},
			},
		}
	end,

	-- -- Post-close hook to reset cursor shape (currently disabled)
	-- config = function(_, opts)
	-- 	require("fzf-lua").setup(opts)
	-- 	vim.api.nvim_create_autocmd('User', {
	-- 		pattern = 'FzfLuaClose',
	-- 		callback = function()
	-- 			vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20'
	-- 		end,
	-- 	})
	-- end
}
