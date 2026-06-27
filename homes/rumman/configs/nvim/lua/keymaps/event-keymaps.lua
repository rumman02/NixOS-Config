-- =============================================================================
-- Event LSP Keymaps
-- =============================================================================
-- Keymaps registered via the LspAttach autocmd, so they are only available
-- in buffers that have at least one LSP server attached.
-- =============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
	group = "UserLspConfig",
	callback = function()
		local map = vim.keymap.set

		-- Helper: jump to next/prev diagnostic, then center the viewport.
		-- Accepts an optional severity filter ("ERROR", "WARN", "HINT", "INFO").
		local diagnostic_goto = function(next, severity)
			---@diagnostic disable-next-line: deprecated
			local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
			severity = severity and vim.diagnostic.severity[severity] or nil
			return function()
				go({ severity = severity })
				vim.cmd("normal! zz")
			end
		end

		-- Hover & Signature -----------------------------------------------

		map({ "n", "v" }, _G.lsp_key1.."i", function() vim.lsp.buf.hover({ border = "rounded" }) end, { desc = "Hover info" })
		map("n", _G.lsp_key1.."s", function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })

		-- Go to definition, declaration, etc. -----------------------------

		map("n", _G.lsp_key1.."gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
		map("n", _G.lsp_key1.."gD", function() vim.lsp.buf.declaration() end, { desc = "Go to declaration" })
		map("n", _G.lsp_key1.."gi", function() vim.lsp.buf.implementation() end, { desc = "Go to implementation" })
		map("n", _G.lsp_key1.."gr", function() vim.lsp.buf.references() end, { desc = "Find references" })
		map("n", _G.lsp_key1.."gt", function() vim.lsp.buf.type_definition() end, { desc = "Go to type definition" })

		-- Code actions & rename -----------------------------------------

		map({ "n", "v" }, _G.lsp_key1.."c", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
		map("n", _G.lsp_key1.."r", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })

		-- Workspace symbols & folders -----------------------------------

		map({ "n", "v" }, _G.lsp_key1.."ws", function() vim.lsp.buf.workspace_symbol() end, { desc = "Workspace symbols" })
		map("n", _G.lsp_key1.."wf", function() vim.lsp.buf.add_workspace_folder() end, { desc = "Add workspace folder" })
		map("n", _G.lsp_key1.."wr", function() vim.lsp.buf.remove_workspace_folder() end, { desc = "Remove workspace folder" })

		-- Diagnostics float & highlights --------------------------------

		map("n", _G.lsp_key1.."?", function() vim.diagnostic.open_float() end, { desc = "Show diagnostics float" })
		map("n", _G.lsp_key1.."h", function() vim.lsp.buf.document_highlight() end, { desc = "Highlight references" })
		map("n", _G.lsp_key1.."l", function() vim.lsp.buf.clear_references() end, { desc = "Clear highlights" })
		map("n", _G.lsp_key1.."R", function() vim.lsp.buf.selection_range(0) end, { desc = "Selection range" })

		-- Jump diagnostics (all, error, warn, hint) ---------------------

		map("n", _G.lsp_key1.."nd", function() diagnostic_goto(true) end, { desc = "Next diagnostic" })
		map("n", _G.lsp_key1.."pd", function() diagnostic_goto(false) end, { desc = "Prev diagnostic" })
		map("n", _G.lsp_key1.."ne", function() diagnostic_goto(true, "ERROR") end, { desc = "Next error" })
		map("n", _G.lsp_key1.."pe", function() diagnostic_goto(false, "ERROR") end, { desc = "Prev error" })
		map("n", _G.lsp_key1.."nw", function() diagnostic_goto(true, "WARN") end, { desc = "Next warning" })
		map("n", _G.lsp_key1.."pw", function() diagnostic_goto(false, "WARN") end, { desc = "Prev warning" })
		map("n", _G.lsp_key1.."nh", function() diagnostic_goto(true, "HINT") end, { desc = "Next hint" })
		map("n", _G.lsp_key1.."ph", function() diagnostic_goto(false, "HINT") end, { desc = "Prev hint" })
		map("n", _G.lsp_key1.."ni", function() diagnostic_goto(true, "INFO") end, { desc = "Next info" })
		map("n", _G.lsp_key1.."pi", function() diagnostic_goto(false, "INFO") end, { desc = "Prev info" })

		-- Formatting ----------------------------------------------------

		map({ "n", "v" }, _G.format_key1.."l", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format via LSP" })
	end,
})
