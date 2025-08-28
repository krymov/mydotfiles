-- Keep minimal; rely on defaults
local map = vim.keymap.set
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })
