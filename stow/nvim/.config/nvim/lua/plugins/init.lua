-- Plugin configurations
-- This file should return a table of plugin configurations

return {
  -- Import AI-powered coding assistant
  -- Provides VS Code-style AI agents with custom roles
  require("plugins.codecompanion"),
  
  -- Add other custom plugins here
  -- Example:
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     require("telescope").setup()
  --   end,
  -- },
}
