-- =============================================================================
-- nixCatsUtils — nixCats Compatibility Layer
-- =============================================================================
-- Provides a mock nixCats plugin when the config is loaded without nix.
-- This prevents indexing errors in all files that reference nixCats.
-- If the config is loaded via nix, this file is effectively a no-op.
-- =============================================================================

local M = {}

-- =============================================================================
-- Environment detection
-- =============================================================================

---True if the config was loaded via nixCats (RTP entry exists)
---@type boolean
M.isNixCats = vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] ~= nil

-- =============================================================================
-- Public API
-- =============================================================================

---@class nixCatsSetupOpts
---@field non_nix_value boolean|nil   -- default return value when not running under nix

---Setup a mock nixCats plugin for non-nix environments.
---Does nothing if the config was loaded via nix.
---@param v nixCatsSetupOpts
function M.setup(v)
  if not M.isNixCats then
    local nixCats_default_value
    if type(v) == "table" and type(v.non_nix_value) == "boolean" then
      nixCats_default_value = v.non_nix_value
    else
      nixCats_default_value = true
    end

    -- Metatable helper: allows dot-path lookup on tables, e.g. tbl("a.b.c")
    local mk_with_meta = function(tbl)
      return setmetatable(tbl, {
        __call = function(_, attrpath)
          local strtable = {}
          if type(attrpath) == "table" then
            strtable = attrpath
          elseif type(attrpath) == "string" then
            for key in attrpath:gmatch("([^%.]+)") do
              table.insert(strtable, key)
            end
          else
            print("function requires a table of strings or a dot separated string")
            return
          end
          return vim.tbl_get(tbl, unpack(strtable));
        end,
      })
    end

    -- Register a mock nixCats module so require('nixCats') works outside nix
    package.preload['nixCats'] = function()
      local ncsub = {
        get = function(_) return nixCats_default_value end,
        cats = mk_with_meta({
          nixCats_config_location = vim.fn.stdpath('config'),
          wrapRc = false,
        }),
        settings = mk_with_meta({
          nixCats_config_location = vim.fn.stdpath('config'),
          configDirName = os.getenv("NVIM_APPNAME") or "nvim",
          wrapRc = false,
        }),
        petShop = mk_with_meta({}),
        extra = mk_with_meta({}),
        pawsible = mk_with_meta({
          allPlugins = {
            start = {},
            opt = {},
          },
        }),
        configDir = vim.fn.stdpath('config'),
        packageBinPath = os.getenv('NVIM_WRAPPER_PATH_NIX') or vim.v.progpath
      }
      return setmetatable(ncsub, {
        __call = function(_, cat) return ncsub.get(cat) end
      })
    end

    _G.nixCats = require('nixCats')
  end
end

---Check if a nixCats category is enabled. Returns false if not running under nix
---(unless a non-nil default override is provided).
---@overload fun(v: string|string[]): boolean
---@overload fun(v: string|string[], default: boolean): boolean
function M.enableForCategory(v, default)
  if M.isNixCats or default == nil then
    if nixCats(v) then
      return true
    else
      return false
    end
  else
    return default
  end
end

---If running under nix, return nixCats(v); otherwise return the provided default.
---Useful for specifying a non-nix fallback value.
---@param v string|string[]
---@param default any
---@return any
function M.getCatOrDefault(v, default)
  if M.isNixCats then
    return nixCats(v)
  else
    return default
  end
end

---Conditionally include/exclude lazy.nvim plugin specs when running under nix.
---Under nix, build steps are handled by nix itself, so non-nix build specs (like
---build = "..." or cmd = ...") should be skipped. Returns `o` under nix, `v` otherwise.
---@overload fun(v: any): any|nil
---@overload fun(v: any, o: any): any
function M.lazyAdd(v, o)
  if M.isNixCats then
    return o
  else
    return v
  end
end

return M
