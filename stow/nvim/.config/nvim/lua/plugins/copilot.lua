-- GitHub Copilot: AI-powered code completion and chat
-- Provides intelligent code suggestions and conversational AI assistance

return {
  -- Main Copilot plugin for code completion
  {
    "github/copilot.vim",
    event = "VimEnter",
    config = function()
      -- Disable default tab mapping (we'll use custom ones)
      vim.g.copilot_no_tab_map = true

      -- Accept suggestion with Ctrl+j
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion"
      })

      -- Navigate suggestions
      vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
      vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })

      -- Dismiss suggestion
      vim.keymap.set("i", "<C-e>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })
    end,
  },

  -- Copilot Chat for conversational AI assistance
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" }, -- or github/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging

      -- Chat window configuration
      window = {
        layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.4, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.8, -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = "Copilot Chat", -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },

      -- Chat behavior
      question_header = "## User ", -- Header to use for user questions
      answer_header = "## Copilot ", -- Header to use for AI answers
      error_header = "## Error ", -- Header to use for errors
      separator = "───", -- Separator to use in chat

      -- Prompts
      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Review the selected code.",
          callback = function(response, source)
            -- see config.lua for implementation
          end,
        },
        Fix = {
          prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Please generate tests for my code.",
        },
        FixDiagnostic = {
          prompt = "Please assist with the following diagnostic issue in file:",
          selection = function(source)
            return require("CopilotChat.select").diagnostics(source)
          end,
        },
        Commit = {
          prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source)
          end,
        },
        CommitStaged = {
          prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source, true)
          end,
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      -- Use unnamed register for the selection
      opts.selection = select.unnamed

      -- Override the git prompts message
      opts.prompts.Commit = {
        prompt = "Write commit message for the change with commitizen convention",
        selection = select.gitdiff,
      }
      opts.prompts.CommitStaged = {
        prompt = "Write commit message for the change with commitizen convention",
        selection = function(source)
          return select.gitdiff(source, true)
        end,
      }

      chat.setup(opts)

      -- Keybindings
      local function map(mode, lhs, rhs, opts_map)
        opts_map = opts_map or {}
        opts_map.silent = opts_map.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts_map)
      end

      -- Chat commands
      map("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Copilot Chat" })
      map("v", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Copilot Chat" })
      map("n", "<leader>ct", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat Toggle" })
      map("v", "<leader>ct", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat Toggle" })

      -- Quick actions
      map("v", "<leader>ce", function()
        chat.ask("Explain this code", { selection = select.visual })
      end, { desc = "Copilot Explain" })

      map("v", "<leader>cr", function()
        chat.ask("Review this code", { selection = select.visual })
      end, { desc = "Copilot Review" })

      map("v", "<leader>cf", function()
        chat.ask("Fix this code", { selection = select.visual })
      end, { desc = "Copilot Fix" })

      map("v", "<leader>co", function()
        chat.ask("Optimize this code", { selection = select.visual })
      end, { desc = "Copilot Optimize" })

      map("v", "<leader>cd", function()
        chat.ask("Add documentation for this code", { selection = select.visual })
      end, { desc = "Copilot Docs" })

      map("v", "<leader>cT", function()
        chat.ask("Generate tests for this code", { selection = select.visual })
      end, { desc = "Copilot Tests" })

      -- Git integration
      map("n", "<leader>cm", function()
        chat.ask("Write commit message for the changes", { selection = select.gitdiff })
      end, { desc = "Copilot Commit Message" })

      map("n", "<leader>cs", function()
        chat.ask("Write commit message for staged changes", {
          selection = function(source)
            return select.gitdiff(source, true)
          end
        })
      end, { desc = "Copilot Commit Staged" })

      -- Diagnostic help
      map("n", "<leader>cx", function()
        chat.ask("Help with diagnostic", { selection = select.diagnostics })
      end, { desc = "Copilot Fix Diagnostic" })

      -- Show available prompts
      map("n", "<leader>cp", "<cmd>CopilotChatPromptActions<cr>", { desc = "Copilot Prompt Actions" })
      map("v", "<leader>cp", "<cmd>CopilotChatPromptActions<cr>", { desc = "Copilot Prompt Actions" })
    end,
  },
}
