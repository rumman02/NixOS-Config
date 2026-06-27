return {
	"mg979/vim-visual-multi",
	enabled = true,
	-- event = "VeryLazy",
	branch = "master",
	init = function()
		vim.g.VM_verbose = 1
		vim.g.VM_show_warnings = 1
		vim.g.VM_silent_exit = 1    -- Silent exit
		vim.g.VM_default_mappings = 0
		vim.g.VM_add_cursor_at_pos_no_mappings = 1
		vim.g.VM_theme = "purplegray" -- "iceblue"
		vim.g.VM_highlight_matches = "underline"
		vim.g.VM_leader = "<leader>m"
		vim.g.VM_maps = {
			-- ["Find Under"]           = "<C-n>",
			-- ["Find Subword Under"]   = "<C-n>",
			-- ["Select All"]           = "\\A",
			-- ["Start Regex Search"]   = "\\/",
			-- ["Add Cursor Down"]      = "<C-Down>",
			-- ["Add Cursor Up"]        = "<C-Up>",
			-- ["Add Cursor At Pos"]    = "\\'",
			-- ["Visual Regex"]         = "\\/",
			-- ["Visual All"]           = "\\A",
			-- ["Visual Add"]           = "\\a",
			-- ["Visual Find"]          = "\\f",
			-- ["Visual Cursors"]       = "\\c",
			-- ["Select Cursor Down"]   = "<M-C-Down>",
			-- ["Select Cursor Up"]     = "<M-C-Up>",
			-- ["Erase Regions"]        = "\\gr",
			-- ["Mouse Cursor"]         = "<C-LeftMouse>",
			-- ["Mouse Word"]           = "<C-RightMouse>",
			-- ["Mouse Column"]         = "<M-C-RightMouse>",
			-- ["Switch Mode"]          = "<Tab>",
			-- ["Find Next"]            = "n",
			-- ["Find Prev"]            = "N",
			-- ["Goto Next"]            = "}",
			-- ["Goto Prev"]            = "{",
			["Goto Next"]            = "j",
			["Goto Prev"]            = "k",
			-- ['Seek Next']            = "<C-f>",
			-- ['Seek Prev']            = "<C-b>",
			-- ["Skip Region"]          = "q",
			-- ["Remove Region"]        = "Q",
			-- ["Invert Direction"]     = "o",
			-- ["Find Operator"]        = "m",
			-- ["Surround"]             = "S",
			-- ["Replace Pattern"]      = "R",
			-- ["Tools Menu"]           = "\\`",
			-- ["Show Registers"]       = '\\"',
			-- ["Case Setting"]         = "\\c",
			-- ["Toggle Whole Word"]    = "\\w",
			-- ["Transpose"]            = "\\t",
			-- ["Align"]                = "\\a",
			-- ["Duplicate"]            = "\\d",
			-- ["Rewrite Last Search"]  = "\\r",
			-- ["Merge Regions"]        = "\\m",
			-- ["Split Regions"]        = "\\s",
			-- ["Remove Last Region"]   = "\\q",
			-- ["Visual Subtract"]      = "\\s",
			-- ["Case Conversion Menu"] = "\\C",
			-- ["Search Menu"]          = "\\S",
			-- ["Run Normal"]           = "\\z",
			-- ["Run Last Normal"]      = "\\Z",
			-- ["Run Visual"]           = "\\v",
			-- ["Run Last Visual"]      = "\\V",
			-- ["Run Ex"]               = "\\x",
			-- ["Run Last Ex"]          = "\\X",
			-- ["Run Macro"]            = "\\@",
			-- ["Align Char"]           = "\\<",
			-- ["Align Regex"]          = "\\>",
			-- ["Numbers"]              = "\\n",
			-- ["Numbers Append"]       = "\\N",
			-- ["Zero Numbers"]         = "\\0n",
			-- ["Zero Numbers Append"]  = "\\0N",
			-- ["Shrink"]               = "\\-",
			-- ["Enlarge"]              = "\\+",
			-- ["Toggle Block"]         = "\\<BS>",
			-- ["Toggle Single Region"] = "\\<CR>",
			-- ["Toggle Multiline"]     = "\\M",
			["Toggle Mappings"]      = "<m-space>",
			["Select Operator"]      = "<m-s>",
		}
	end,
	keys = function ()
		local count = 0

		local function toggle_mappings(plug, mode)
			mode = mode or "n"
			if count == 0 then
				count = 1
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(plug..'<Plug>(VM-Toggle-Mappings)', true, false, true), mode, false)
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(plug, true, false, true), mode, false)
			end
		end

		-- Reset count when exiting VM mode
		vim.api.nvim_create_autocmd('User', {
			pattern = 'visual_multi_exit',
			callback = function()
				count = 0
			end,
		})

		return {
			{ "<a-a>", "<Plug>(VM-Select-All)", desc =  "Select all" },
			{ "<a-a>", "<Plug>(VM-Visual-All)", desc =  "Select all", mode = { "v", "x" } },

			-- { "<a-j>", function() toggle_mappings("<Plug>(VM-Add-Cursor-Down)") end, desc = "Add cursor down" },
			-- { "<a-k>", function() toggle_mappings("<Plug>(VM-Add-Cursor-Up)") end, desc = "Add cursor up" },
			{ "<a-j>", "<Plug>(VM-Add-Cursor-Down)", desc = "Add cursor down" },
			{ "<a-k>", "<Plug>(VM-Add-Cursor-Up)", desc = "Add cursor up" },

			{ "<a-d>", "<Plug>(VM-Remove-Region)", desc = "Remove region" },

			-- { "<a-s-j>", function() toggle_mappings("<Plug>(VM-Select-Cursor-Down)") end, desc = "Add cursor selection down" },
			-- { "<a-s-k>", function() toggle_mappings("<Plug>(VM-Select-Cursor-Up)") end, desc = "Add cursor selection up" },
			{ "<a-s-j>", "<Plug>(VM-Select-Cursor-Down)", desc = "Add cursor selection down" },
			{ "<a-s-k>", "<Plug>(VM-Select-Cursor-Up)", desc = "Add cursor selection up" },

			-- { "<a-n>", function() toggle_mappings("<Plug>(VM-Find-Under)") end, desc = "Find under" },
			-- { "<a-n>", function() toggle_mappings("<Plug>(VM-Find-Subword-Under)") end, desc = "Find under", mode = "x" },
			{ "<a-n>", "<Plug>(VM-Find-Under)", desc = "Find under" },
			{ "<a-n>", "<Plug>(VM-Find-Subword-Under)", desc = "Find under", mode = "x" },

			{ "<a-cr>", "<Plug>(VM-Add-Cursor-At-Pos)", desc = "Add cursor at pos" },
			{ "<a-space>", "<Plug>(VM-Add-Cursor-At-Pos)", desc = "Toggle Mappings" },
			{ "<a-tab>", "<Plug>(VM-Switch-Mode)", desc = "Switch mode" },
		}
	end
}

