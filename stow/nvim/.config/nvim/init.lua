-- AstroNvim Configuration
-- This configuration works with AstroNvim v4+

-- Check if AstroNvim is installed
local astronvim_path = vim.fn.stdpath("data") .. "/lazy/AstroNvim"
if not vim.loop.fs_stat(astronvim_path) then
  -- AstroNvim not installed, use minimal config
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","
  
  -- Basic settings
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.wrap = false
  vim.opt.cursorline = true
  vim.opt.termguicolors = true
  
  -- Install AstroNvim automatically
  print("AstroNvim not found. Please run the bootstrap script to install it.")
  return
end

-- Bootstrap AstroNvim
require("astronvim.bootstrap")

-- User configuration
require("astronvim.options")
require("astronvim.lazy")
require("astronvim.autocmds")
require("astronvim.mappings")
