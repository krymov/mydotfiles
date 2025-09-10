

if vim.g.vscode then
  vim.o.showtabline = 0
  vim.o.winbar = ""
  vim.o.laststatus = 0          -- or 3; 0 ensures no statusline in VS Code
  vim.o.statusline = ""         -- some plugins force a custom statusline

  -- Safety: link highlights to Normal so themes don’t paint black
  vim.cmd([[
    hi! link TabLineFill Normal
    hi! link WinBar     Normal
    hi! link WinBarNC   Normal
  ]])
end


local opt = vim.opt
opt.relativenumber = true
opt.number = true
opt.signcolumn = "yes"
opt.scrolloff = 4
