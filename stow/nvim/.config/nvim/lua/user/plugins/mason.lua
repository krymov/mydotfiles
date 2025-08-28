-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        "pyright",
        "tsserver",
        "gopls",
        "rust_analyzer",
        "clangd",
        "nil_ls", -- Nix LSP
        "jsonls",
        "yamlls",
        "bashls",
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "black", -- python formatter
        "isort", -- python import sorter
        "flake8", -- python linter
        "eslint_d", -- js linter
        "shfmt", -- shell formatter
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "python", -- python debugger
        "node2", -- node debugger
        "go", -- go debugger
        "codelldb", -- rust/c++ debugger
      })
    end,
  },
}
