-- Polish configuration
-- This file is for custom configurations that don't fit elsewhere

return function()
  -- Set up custom filetypes
  vim.filetype.add {
    extension = {
      -- Add custom file extensions here
      -- foo = "fooscript",
    },
    filename = {
      -- Add custom filenames here
      -- ["Foofile"] = "fooscript",
    },
    pattern = {
      -- Add custom patterns here
      -- ["~/%.config/foo/.*"] = "fooscript",
    },
  }
  
  -- Custom autocmds
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      -- Remove trailing whitespace on save
      local save_cursor = vim.fn.getpos(".")
      pcall(function() vim.cmd("%s/\\s\\+$//e") end)
      vim.fn.setpos(".", save_cursor)
    end,
  })
  
  -- Set up custom keymaps
  local map = vim.keymap.set
  
  -- Better window navigation
  map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
  map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
  map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
  map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
  
  -- Better indenting
  map("v", "<", "<gv", { desc = "Indent left" })
  map("v", ">", ">gv", { desc = "Indent right" })
  
  -- Move text up and down
  map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
  map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })
end