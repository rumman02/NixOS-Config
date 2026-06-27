return {
	cmd = {
		"lua-language-server"
	},
	filetypes = {
		"lua"
	},
	root_markers = {
		".git",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT"
			},
			hint = { enable = true },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true)
			},
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" },
				disable = {
					-- "missing-parameters",
					-- "missing-fields"
				}
			}
		}
	}
}

