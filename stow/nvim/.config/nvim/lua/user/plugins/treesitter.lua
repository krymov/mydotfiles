-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
      "lua", "vim",
      -- Programming languages
      "python", "javascript", "typescript", "go", "rust", "c", "cpp",
      -- Configuration languages
      "json", "yaml", "toml", "nix",
      -- Markup languages
      "markdown", "markdown_inline", "html", "css",
      -- Shell scripting
      "bash", "zsh",
      -- Git
      "gitcommit", "gitignore",
    })
  end,
}