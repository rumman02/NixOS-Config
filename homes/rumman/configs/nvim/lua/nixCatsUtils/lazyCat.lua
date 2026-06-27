-- =============================================================================
-- lazyCat — lazy.nvim Config Wrapper for nixCats
-- =============================================================================
-- A convenience wrapper that lets you define plugin specs for lazy.nvim
-- while automatically handling nix vs. non-nix differences:
--   - Resets lazy's RTP reset (preserves nix-provided plugins)
--   - Configures the dev path to find locally-developed plugins in nix store paths
--   - Handles lazy.nvim download for non-nix environments
--
-- Usage:
--   require('nixCatsUtils.lazyCat').setup(nixLazyPath, { plugin specs }, { lazy opts })
--
-- NOTE: If you don't use lazy.nvim, you don't need this file.
-- =============================================================================

local M = {}

---Setup lazy.nvim with nix-aware configuration.
---@param nixLazyPath string|nil   -- path to lazy.nvim on nix (nil = download if needed)
---@param lazySpec table          -- plugin specs (same format as lazy.nvim)
---@param opts table              -- lazy.nvim configuration options
function M.setup(nixLazyPath, lazySpec, opts)
  local isNixCats = vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] ~= nil
  local lazypath

  -- =============================================================================
  -- Download lazy.nvim if it doesn't already exist
  -- =============================================================================

  local function regularLazyDownload()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',  -- latest stable release
        lazypath,
      }
    end
    return lazypath
  end

  -- =============================================================================
  -- Resolve lazy path (nix vs. non-nix)
  -- =============================================================================

  if not isNixCats then
    -- Not running under nix — download lazy and add to RTP normally
    lazypath = regularLazyDownload()
    vim.opt.rtp:prepend(lazypath)
  else
    -- Running under nix — use nix-provided path, download as fallback
    local nixCats = require('nixCats')
    lazypath = nixLazyPath
    if lazypath == nil then
      lazypath = regularLazyDownload()
    end

    -- =============================================================================
    -- Preserve user's existing dev.path config if present
    -- =============================================================================

    local oldPath
    local lazypatterns
    local fallback
    if type(opts) == "table" and type(opts.dev) == "table" then
      lazypatterns = opts.dev.patterns
      fallback = opts.dev.fallback
      oldPath = opts.dev.path
    end

    local myNeovimPackages = nixCats.vimPackDir .. "/pack/myNeovimPackages"

    -- =============================================================================
    -- Nix-aware dev.path resolver
    -- =============================================================================
    -- Priority:
    --  1. User's custom path function/directory
    --  2. nix-managed start/ opt/ directories
    --  3. Local development directory (~/projects/)
    -- =============================================================================

    local newLazyOpts = {
      performance = {
        rtp = {
          reset = false,    -- don't let lazy reset the RTP (nix manages it)
        },
      },
      dev = {
        path = function(plugin)
          local path = nil
          -- 1. User custom path
          if type(oldPath) == "string" and vim.fn.isdirectory(oldPath .. "/" .. plugin.name) == 1 then
            path = oldPath .. "/" .. plugin.name
          elseif type(oldPath) == "function" then
            path = oldPath(plugin)
            if type(path) ~= "string" then
              path = nil
            end
          end
          -- 2. Nix-managed directories
          if path == nil then
            if vim.fn.isdirectory(myNeovimPackages .. "/start/" .. plugin.name) == 1 then
              path = myNeovimPackages .. "/start/" .. plugin.name
            elseif vim.fn.isdirectory(myNeovimPackages .. "/opt/" .. plugin.name) == 1 then
              path = myNeovimPackages .. "/opt/" .. plugin.name
            else
              -- 3. Local dev fallback
              path = "~/projects/" .. plugin.name
            end
          end
          return path
        end,
        patterns = lazypatterns or { "" },
        fallback = fallback == nil and true or fallback,  -- default true
      }
    }
    opts = vim.tbl_deep_extend("force", opts or {}, newLazyOpts)

    -- =============================================================================
    -- Manual RTP rebuild (since we disabled reset above)
    -- =============================================================================

    local cfgdir = nixCats.configDir
    vim.opt.rtp = {
      cfgdir,
      nixCats.nixCatsPath,
      nixCats.pawsible.allPlugins.ts_grammar_path,
      vim.fn.stdpath("data") .. "/site",
      lazypath,
      vim.env.VIMRUNTIME,
      vim.fn.fnamemodify(vim.v.progpath, ":p:h:h") .. "/lib/nvim",
      cfgdir .. "/after",
    }
  end

  -- =============================================================================
  -- Call lazy.nvim setup
  -- =============================================================================

  if lazySpec then
    require('lazy').setup(lazySpec, opts)
  else
    require('lazy').setup(opts)
  end
end

return M
