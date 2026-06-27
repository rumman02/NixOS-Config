-- =============================================================================
-- LSP Configuration
-- =============================================================================

-- Enable LSP servers
vim.lsp.enable("lua_ls")   -- Lua language server
vim.lsp.enable("nil")      -- Nix language server
vim.lsp.enable("ts_ls")    -- TypeScript language server

-- Global capabilities applied to all LSP servers
vim.lsp.config("*", {
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,     -- simple line-based folds only
			},
			semanticTokens = {
				multilineTokenSupport = true,  -- handle multiline token highlights
			},
		},
	},
})

local icons = require("lib.icons")

-- Diagnostic display settings
vim.diagnostic.config({
	virtual_lines = false,        -- don't show diagnostics as virtual lines
	virtual_text = false,         -- don't show inline virtual text (use sign column instead)
	-- virtual_text = {
	-- 	spacing = 1,
	-- 	prefix = "󱓻",
	-- 	suffix = "",
	-- 	format = function(diagnostic)
	-- 		return string.format("%s [%s]", diagnostic.message, diagnostic.source or "")
	-- 	end,
	-- 	virt_text_pos = "eol", -- overlay on the diagnostic position
	-- },
	underline = true,             -- underline diagnostic ranges
	update_in_insert = false,     -- only recompute diagnostics when leaving insert mode
	severity_sort = true,         -- sort sign column by severity (error first)
	float = {
		border = "rounded",
		source = true,            -- show which LSP server reported the diagnostic
		header = "",
		prefix = "",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostic.error,
			[vim.diagnostic.severity.WARN]  = icons.diagnostic.warn,
			[vim.diagnostic.severity.INFO]  = icons.diagnostic.info,
			[vim.diagnostic.severity.HINT]  = icons.diagnostic.hint,
		},
		-- Color the sign number using highlight groups instead of text icons
		-- numhl = {
		-- 	[vim.diagnostic.severity.ERROR] = "ErrorMsg",
		-- 	[vim.diagnostic.severity.WARN]  = "WarningMsg",
		-- 	[vim.diagnostic.severity.INFO]  = "InfoMsg",
		-- 	[vim.diagnostic.severity.HINT]  = "HintMsg",
		-- }
	},
})

-- Force undercurl for diagnostic underlines (modern + legacy highlight groups)
vim.cmd([[
	highlight DiagnosticUnderlineError gui=undercurl
	highlight DiagnosticUnderlineWarn  gui=undercurl
	highlight DiagnosticUnderlineInfo  gui=undercurl
	highlight DiagnosticUnderlineHint  gui=undercurl
	highlight LspDiagnosticUnderlineError gui=undercurl
	highlight LspDiagnosticUnderlineWarn  gui=undercurl
	highlight LspDiagnosticUnderlineInfo  gui=undercurl
	highlight LspDiagnosticUnderlineHint  gui=undercurl
]])

-- LspAttach hook — runs each time an LSP server attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function()
		local color = nixCats.extra.stylix_color  -- theme color from stylix (future use)
	end,
})
