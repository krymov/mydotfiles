-- AstroNvim User Configuration
-- https://docs.astronvim.com/

-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file

-- Set up configuration table
local config = {

  -- Set the colorscheme
  colorscheme = "astrodark",

  -- Configure AstroNvim
  astronvim = {
    -- Configure AstroNvim updates
    updater = {
      remote = "origin", -- remote to use
      channel = "stable", -- "stable" or "nightly"
      version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
      branch = "nightly", -- branch name (NIGHTLY ONLY)
      commit = nil, -- commit hash (NIGHTLY ONLY)
      pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
      skip_prompts = false, -- skip prompts about breaking changes
      show_changelog = true, -- show the changelog after performing an update
      auto_quit = false, -- automatically quit the current session after a successful update
    },
  },

  -- Configure plugins
  plugins = {
    -- Add plugins here
  },

  -- LSP configuration
  lsp = {
    -- configure language server formatting
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
    },
  },
}

-- bootstrap lazy and all of the plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  os.exit(1)
end

-- Set up lazy with AstroNvim plugins
require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    version = "^4", -- Remove version tracking to elect for nightly AstroNvim
    import = "astronvim.plugins",
    opts = config.astronvim,
  },
  { import = "community" },
  { import = "plugins" },
}, {
  -- Configure Lazy.nvim
  install = { colorscheme = { config.colorscheme, "habamax" } },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
