-- =============================================================================
-- Neovim Entry Point
-- =============================================================================
-- Bootstrap order matters: options first, then plugin manager, then the rest.
-- Global key variables are loaded before keymaps so they can reference _G.* vars.
-- =============================================================================

-- Global key variables (_G.*_key1, _G.*_key2 — must load before keymaps)
require('keymaps.global-keymaps')

-- Editor options
require('core.options')

-- Plugin manager (lazy.nvim via nixCats)
require('core.lazycat')

-- LSP configuration
require('core.lsp')

-- General keymaps
require('keymaps.general-keymaps')

-- Autocommands
require('core.autocmds')

-- LSP event keymaps (LspAttach)
require('keymaps.event-keymaps')

