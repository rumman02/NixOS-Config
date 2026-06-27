-- =============================================================================
-- nvim-ufo — Advanced folding
-- =============================================================================
-- Better fold display with custom virtual text that shows:
--  - Folded line count
--  - Git change counts (added/modified/removed) within the fold
--  - Diagnostic counts (error/warn/info/hint) within the fold
-- =============================================================================

return {
	"kevinhwang91/nvim-ufo",
	event = "BufReadPost",
	dependencies = "kevinhwang91/promise-async",

	-- Basic fold settings
	init = function()
		vim.opt.foldcolumn = "1"         -- always show fold column
		vim.opt.foldlevel = 99           -- don't auto-fold by default
		vim.opt.foldlevelstart = 99      -- open all folds on startup
		vim.opt.foldenable = true
	end,

	-- ===================================================================
	-- Fold keymaps: <leader>zz
	-- ===================================================================

	keys = {
		{ _G.fold_key1 .. "zO", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
		{ _G.fold_key1 .. "zX", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
		{ _G.fold_key1 .. "zK", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold" },
	},

	opts = function()
		local icons = require("lib.icons")

		return {
			-- Custom virtual text handler for rich fold display
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local foldedLines = endLnum - lnum
				local foldIcon = ""

				local buf = vim.api.nvim_get_current_buf()

				-- ===================================================================
				-- Count diagnostics inside the fold range
				-- ===================================================================

				local errorLines = {}
				local warnLines = {}
				local infoLines = {}
				local hintLines = {}

				local ok, diagnostics = pcall(vim.diagnostic.get, buf)
				if ok and diagnostics then
					for _, diag in ipairs(diagnostics) do
						local diagLine = diag.lnum + 1  -- convert to 1-based
						if diagLine > lnum and diagLine <= endLnum then
							if diag.severity == vim.diagnostic.severity.ERROR then
								errorLines[diagLine] = true
							elseif diag.severity == vim.diagnostic.severity.WARN then
								warnLines[diagLine] = true
							elseif diag.severity == vim.diagnostic.severity.INFO then
								infoLines[diagLine] = true
							elseif diag.severity == vim.diagnostic.severity.HINT then
								hintLines[diagLine] = true
							end
						end
					end
				end

				local errorLineCount = 0
				for _ in pairs(errorLines) do errorLineCount = errorLineCount + 1 end
				local warnLineCount = 0
				for _ in pairs(warnLines) do warnLineCount = warnLineCount + 1 end
				local infoLineCount = 0
				for _ in pairs(infoLines) do infoLineCount = infoLineCount + 1 end
				local hintLineCount = 0
				for _ in pairs(hintLines) do hintLineCount = hintLineCount + 1 end

				-- ===================================================================
				-- Count git changes inside the fold range
				-- ===================================================================

				local addedLines = 0
				local removedLines = 0
				local changedLines = 0

				local hasGitsigns, gitsigns = pcall(require, "gitsigns")
				if hasGitsigns and gitsigns then
					local ok_hunks, hunks = pcall(gitsigns.get_hunks, buf)
					if ok_hunks and hunks and type(hunks) == "table" then
						for _, h in pairs(hunks) do
							if h and h.type and h.added and h.removed then
								if h.type == "delete" then
									local deletionLine = h.added.start
									local isInFold = deletionLine >= lnum and deletionLine <= endLnum
									if isInFold and h.removed.count then
										removedLines = removedLines + h.removed.count
									end
								else
									if h.added.start and h.added.count then
										local hunkStart = h.added.start
										local hunkEnd = hunkStart - 1 + h.added.count
										local overlapStart = math.max(lnum + 1, hunkStart)
										local overlapEnd = math.min(endLnum, hunkEnd)
										local overlap = overlapEnd - overlapStart + 1
										if overlap > 0 then
											if h.type == "add" then
												addedLines = addedLines + overlap
											elseif h.type == "change" then
												changedLines = changedLines + overlap
											end
										end
									end
								end
							end
						end
					end
				end

				-- ===================================================================
				-- Build the fold text suffix
				-- ===================================================================

				local suffixText = "  " .. foldIcon .. "  " .. foldedLines .. " lines"

				-- Append git change counts
				if addedLines > 0 then suffixText = suffixText .. " " .. icons.git.added .. " " .. addedLines end
				if changedLines > 0 then suffixText = suffixText .. " " .. icons.git.modified .. " " .. changedLines end
				if removedLines > 0 then suffixText = suffixText .. " " .. icons.git.removed .. " " .. removedLines end

				-- Append diagnostic counts
				if errorLineCount > 0 or warnLineCount > 0 or infoLineCount > 0 or hintLineCount > 0 then
					suffixText = suffixText .. "  "
				end

				if errorLineCount > 0 then suffixText = suffixText .. icons.diagnostic.error .. " " .. errorLineCount .. " " end
				if warnLineCount > 0 then suffixText = suffixText .. icons.diagnostic.warn .. " " .. warnLineCount .. " " end
				if infoLineCount > 0 then suffixText = suffixText .. icons.diagnostic.info .. " " .. infoLineCount .. " " end
				if hintLineCount > 0 then suffixText = suffixText .. icons.diagnostic.hint .. " " .. hintLineCount .. " " end

				-- ===================================================================
				-- Truncate original text to fit suffix
				-- ===================================================================

				local sufWidth = vim.fn.strdisplaywidth(suffixText)
				local targetWidth = width - sufWidth
				local curWidth = 0

				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						break
					end
					curWidth = curWidth + chunkWidth
				end

				-- ===================================================================
				-- Append colorful suffix parts with highlight groups
				-- ===================================================================

				table.insert(newVirtText, { "  " .. foldIcon .. " " .. foldedLines .. " lines ", "Comment" })

				-- Git info
				if addedLines > 0 then table.insert(newVirtText, { " " .. icons.git.added .. "" .. addedLines, "GitSignsAdd" }) end
				if changedLines > 0 then table.insert(newVirtText, { " " .. icons.git.modified .. "" .. changedLines, "GitSignsChange" }) end
				if removedLines > 0 then table.insert(newVirtText, { " " .. icons.git.removed .. "" .. removedLines, "GitSignsDelete" }) end

				-- Diagnostics
				if errorLineCount > 0 or warnLineCount > 0 or infoLineCount > 0 or hintLineCount > 0 then
					table.insert(newVirtText, { "  ", "Comment" })
				end
				if errorLineCount > 0 then table.insert(newVirtText, { icons.diagnostic.error .. "" .. errorLineCount .. " ", "DiagnosticError" }) end
				if warnLineCount > 0 then table.insert(newVirtText, { icons.diagnostic.warn .. "" .. warnLineCount .. " ", "DiagnosticWarn" }) end
				if infoLineCount > 0 then table.insert(newVirtText, { icons.diagnostic.info .. "" .. infoLineCount .. " ", "DiagnosticInfo" }) end
				if hintLineCount > 0 then table.insert(newVirtText, { icons.diagnostic.hint .. "" .. hintLineCount .. " ", "DiagnosticHint" }) end

				return newVirtText
			end,
		}
	end,
}
