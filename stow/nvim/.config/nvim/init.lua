-- AstroNvim User Configuration
-- This is the main entry point for AstroNvim v4

-- Check if AstroNvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/AstroNvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- Clone AstroNvim
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/AstroNvim/AstroNvim",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up AstroNvim
require("astronvim")

-- Import user configuration
require("user")
