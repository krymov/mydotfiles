-- CodeCompanion: Advanced AI-powered coding assistant with agentic capabilities
-- Provides VS Code-style AI agents with custom roles, tools, and context awareness

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- For completion
    "nvim-telescope/telescope.nvim", -- For file/symbol search
    {
      "stevearc/dressing.nvim", -- Enhanced UI for input dialogs
      opts = {},
    },
  },
  config = function()
    local codecompanion = require("codecompanion")
    
    -- Helper function to safely get API keys from environment
    local function get_api_key(provider)
      local key_map = {
        openai = "OPENAI_API_KEY",
        anthropic = "ANTHROPIC_API_KEY",
        gemini = "GEMINI_API_KEY",
      }
      
      local env_var = key_map[provider]
      if not env_var then
        return nil
      end
      
      local key = vim.fn.getenv(env_var)
      if key == vim.NIL or key == "" then
        vim.notify(
          string.format("Warning: %s not found in environment. %s provider will not work.", env_var, provider),
          vim.log.levels.WARN
        )
        return nil
      end
      
      return key
    end

    -- Dynamic adapter configuration based on available API keys
    local function get_available_adapters()
      local adapters = {}
      
      -- OpenAI adapters
      if get_api_key("openai") then
        adapters.openai_gpt4o = {
          name = "openai",
          model = "gpt-4o",
          api_key = get_api_key("openai"),
        }
        adapters.openai_gpt4o_mini = {
          name = "openai", 
          model = "gpt-4o-mini",
          api_key = get_api_key("openai"),
        }
      end
      
      -- Anthropic adapters  
      if get_api_key("anthropic") then
        adapters.anthropic_sonnet = {
          name = "anthropic",
          model = "claude-3-5-sonnet-20241022",
          api_key = get_api_key("anthropic"),
        }
        adapters.anthropic_haiku = {
          name = "anthropic",
          model = "claude-3-5-haiku-20241022", 
          api_key = get_api_key("anthropic"),
        }
      end
      
      -- Gemini adapters
      if get_api_key("gemini") then
        adapters.gemini_pro = {
          name = "gemini",
          model = "gemini-1.5-pro-latest",
          api_key = get_api_key("gemini"),
        }
      end
      
      -- Ollama (local) - always available if ollama is running
      adapters.ollama_llama = {
        name = "ollama",
        model = "llama3.1:latest",
        url = "http://localhost:11434",
      }
      
      adapters.ollama_codestral = {
        name = "ollama", 
        model = "codestral:latest",
        url = "http://localhost:11434",
      }
      
      return adapters
    end

    -- Get default adapter (prefer Anthropic > OpenAI > Ollama)
    local function get_default_adapter()
      if get_api_key("anthropic") then
        return "anthropic_sonnet"
      elseif get_api_key("openai") then 
        return "openai_gpt4o"
      else
        return "ollama_llama"
      end
    end

    codecompanion.setup({
      adapters = get_available_adapters(),
      
      strategies = {
        chat = {
          adapter = get_default_adapter(),
        },
        inline = {
          adapter = get_default_adapter(),
        },
        agent = {
          adapter = "anthropic_sonnet", -- Use best model for agents
        },
      },
      
      -- Custom agent roles with specific capabilities
      prompts = {
        -- Code Refactoring Agent
        ["Refactor"] = {
          strategy = "chat",
          description = "Refactor code while preserving behavior",
          opts = {
            adapter = get_api_key("anthropic") and "anthropic_sonnet" or get_default_adapter(),
            auto_submit = false,
          },
          prompts = {
            {
              role = "system", 
              content = [[You are a precise refactoring assistant. Your goals:

1. **Preserve Behavior**: Never change what the code does, only how it does it
2. **Improve Readability**: Make code clearer and more maintainable
3. **Minimal Changes**: Make the smallest changes necessary
4. **Best Practices**: Apply language-specific conventions and patterns
5. **Performance**: Consider performance implications

Focus on:
- Extracting functions/methods when appropriate
- Improving naming conventions
- Reducing complexity and nesting
- Eliminating code duplication
- Adding appropriate error handling
- Optimizing imports and dependencies

Always explain your changes and reasoning.]],
            },
            {
              role = "user",
              content = function()
                return "Please refactor this code:\n\n```"
                  .. vim.bo.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
                  .. "\n```"
              end,
            },
          },
        },

        -- Test Generation Agent
        ["TestGen"] = {
          strategy = "chat",
          description = "Generate comprehensive unit tests",
          opts = {
            adapter = get_api_key("openai") and "openai_gpt4o" or get_default_adapter(),
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = [[You are a test generation specialist. Create comprehensive, maintainable tests that:

1. **Cover Edge Cases**: Test boundary conditions, null/empty inputs, error conditions
2. **Use Table-Driven Tests**: When appropriate for the language (Go, etc.)
3. **Clear Test Names**: Descriptive test function/method names
4. **Arrange-Act-Assert**: Structure tests clearly
5. **Mock Dependencies**: Use appropriate mocking for external dependencies
6. **Test Data**: Create realistic test data and fixtures

For each function/method:
- Test happy path scenarios
- Test error conditions and edge cases  
- Test with various input combinations
- Verify all expected outputs and side effects

Include setup/teardown when needed and explain testing strategy.]],
            },
            {
              role = "user", 
              content = function()
                return "Generate comprehensive tests for this code:\n\n```"
                  .. vim.bo.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
                  .. "\n```"
              end,
            },
          },
        },

        -- Code Review Agent
        ["Reviewer"] = {
          strategy = "chat",
          description = "Perform thorough code review",
          opts = {
            adapter = get_api_key("anthropic") and "anthropic_sonnet" or get_default_adapter(),
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = [[You are a senior code reviewer conducting a thorough review. Focus on:

**Correctness**:
- Logic errors and edge cases
- Potential race conditions or concurrency issues
- Error handling completeness

**Security**:
- Input validation and sanitization
- Authentication and authorization
- Sensitive data handling
- Injection vulnerabilities

**Performance**:
- Algorithm efficiency
- Memory usage
- Database query optimization
- Caching opportunities

**Maintainability**:
- Code organization and structure
- Naming conventions
- Documentation and comments
- Testability

**Style & Standards**:
- Language-specific best practices
- Team coding standards
- Consistent formatting

Provide specific, actionable feedback with examples where helpful.]],
            },
            {
              role = "user",
              content = function()
                return "Please review this code:\n\n```"
                  .. vim.bo.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
                  .. "\n```"
              end,
            },
          },
        },

        -- Documentation Agent
        ["Docs"] = {
          strategy = "chat", 
          description = "Generate comprehensive documentation",
          opts = {
            adapter = get_api_key("openai") and "openai_gpt4o_mini" or get_default_adapter(),
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = [[You are a technical documentation specialist. Create clear, comprehensive documentation that:

**Code Documentation**:
- Concise but complete function/method docstrings
- Parameter descriptions with types and constraints
- Return value descriptions
- Usage examples
- Exception/error documentation

**API Documentation**:
- Clear endpoint descriptions
- Request/response schemas
- Authentication requirements
- Rate limiting and usage notes

**README Content**:
- Project overview and purpose
- Installation and setup instructions
- Basic usage examples
- Configuration options
- Contributing guidelines

**Comments**:
- Explain complex logic and algorithms
- Document business rules and constraints
- Clarify non-obvious code sections

Focus on clarity, accuracy, and usefulness for other developers.]],
            },
            {
              role = "user",
              content = function()
                return "Generate documentation for this code:\n\n```"
                  .. vim.bo.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
                  .. "\n```"
              end,
            },
          },
        },

        -- Debugging Agent
        ["Debug"] = {
          strategy = "chat",
          description = "Help debug issues and analyze problems",
          opts = {
            adapter = get_default_adapter(),
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = [[You are a debugging specialist helping to identify and solve problems. Approach debugging systematically:

**Problem Analysis**:
- Understand the expected vs actual behavior
- Identify symptoms and error messages
- Consider recent changes that might have caused issues

**Root Cause Investigation**:
- Analyze code logic step by step
- Check for common error patterns
- Consider environmental factors

**Solution Strategy**:
- Suggest specific debugging techniques
- Recommend logging/instrumentation
- Propose test cases to isolate the issue
- Offer multiple potential solutions

**Prevention**:
- Suggest improvements to prevent similar issues
- Recommend better error handling
- Propose monitoring and alerting

Provide actionable debugging steps and potential fixes.]],
            },
            {
              role = "user",
              content = function()
                return "Help me debug this code:\n\n```"
                  .. vim.bo.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
                  .. "\n```"
              end,
            },
          },
        },

        -- Architecture Agent
        ["Architect"] = {
          strategy = "chat",
          description = "Provide architectural guidance and design review",
          opts = {
            adapter = get_api_key("anthropic") and "anthropic_sonnet" or get_default_adapter(),
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = [[You are a senior software architect providing design guidance. Focus on:

**System Design**:
- Overall architecture patterns and principles
- Component separation and boundaries
- Data flow and system interactions
- Scalability and performance considerations

**Design Patterns**:
- Appropriate pattern selection for the problem
- Implementation best practices
- Trade-offs and alternatives

**Technology Choices**:
- Framework and library recommendations
- Database and storage decisions
- Integration and communication patterns

**Quality Attributes**:
- Maintainability and extensibility
- Reliability and fault tolerance
- Security and compliance
- Performance and scalability

Provide high-level guidance with practical implementation advice.]],
            },
            {
              role = "user",
              content = function()
                return "Please review the architecture of this code:\n\n```"
                  .. vim.bo.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
                  .. "\n```"
              end,
            },
          },
        },
      },

      -- Display options
      display = {
        action_palette = {
          width = 95,
          height = 10,
        },
        chat = {
          window = {
            layout = "vertical", -- vertical|horizontal|buffer
            width = 0.45,
            height = 0.8,
            relative = "editor",
            border = "rounded",
            title = "CodeCompanion",
          },
          show_settings = true,
        },
      },

      -- General options
      opts = {
        log_level = "INFO", -- TRACE|DEBUG|INFO|WARN|ERROR
        send_code = true,
        use_default_actions = true,
        use_default_prompts = true,
      },
    })

    -- Helper function to check if we're in visual mode
    local function get_visual_selection()
      local mode = vim.fn.mode()
      if mode == "v" or mode == "V" or mode == "\22" then -- \22 is <C-v>
        return true
      end
      return false
    end

    -- Keybindings
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- AI Agent keybindings
    map("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI: Show action palette" })
    map("v", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI: Show action palette" })
    
    -- Chat
    map("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: Toggle chat" })
    map("v", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: Toggle chat" })
    map("n", "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", { desc = "AI: Add to chat" })
    map("v", "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", { desc = "AI: Add to chat" })

    -- Inline assistance
    map("n", "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI: Inline assist" })
    map("v", "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI: Inline assist" })

    -- Agent roles
    map("n", "<leader>ar", function()
      codecompanion.prompt("Refactor")
    end, { desc = "AI: Refactor code" })
    map("v", "<leader>ar", function()
      codecompanion.prompt("Refactor")
    end, { desc = "AI: Refactor code" })

    map("n", "<leader>at", function()
      codecompanion.prompt("TestGen")
    end, { desc = "AI: Generate tests" })
    map("v", "<leader>at", function()
      codecompanion.prompt("TestGen")
    end, { desc = "AI: Generate tests" })

    map("n", "<leader>av", function()
      codecompanion.prompt("Reviewer")
    end, { desc = "AI: Code review" })
    map("v", "<leader>av", function()
      codecompanion.prompt("Reviewer")
    end, { desc = "AI: Code review" })

    map("n", "<leader>ad", function()
      codecompanion.prompt("Docs")
    end, { desc = "AI: Generate docs" })
    map("v", "<leader>ad", function()
      codecompanion.prompt("Docs")
    end, { desc = "AI: Generate docs" })

    map("n", "<leader>aD", function()
      codecompanion.prompt("Debug")
    end, { desc = "AI: Debug help" })
    map("v", "<leader>aD", function()
      codecompanion.prompt("Debug")
    end, { desc = "AI: Debug help" })

    map("n", "<leader>aP", function()
      codecompanion.prompt("Architect")
    end, { desc = "AI: Architecture review" })
    map("v", "<leader>aP", function()
      codecompanion.prompt("Architect")
    end, { desc = "AI: Architecture review" })

    -- Quick actions
    map("v", "<leader>ae", "<cmd>CodeCompanionChat<cr>", { desc = "AI: Explain code" })
    map("v", "<leader>af", "<cmd>CodeCompanionChat<cr>", { desc = "AI: Fix code" })
    map("v", "<leader>ao", "<cmd>CodeCompanionChat<cr>", { desc = "AI: Optimize code" })
    
    -- Show available adapters and current config
    map("n", "<leader>as", function()
      local adapters = get_available_adapters()
      local adapter_list = {}
      for name, _ in pairs(adapters) do
        table.insert(adapter_list, name)
      end
      
      vim.notify(
        "Available AI providers: " .. table.concat(adapter_list, ", ") .. "\nDefault: " .. get_default_adapter(),
        vim.log.levels.INFO
      )
    end, { desc = "AI: Show available providers" })

    -- Create user command for easy API key status check
    vim.api.nvim_create_user_command("CodeCompanionStatus", function()
      local status = {}
      local providers = { "openai", "anthropic", "gemini" }
      
      for _, provider in ipairs(providers) do
        local key = get_api_key(provider)
        table.insert(status, provider .. ": " .. (key and "✓" or "✗"))
      end
      
      -- Check if ollama is running
      local ollama_status = "✗"
      local handle = io.popen("curl -s http://localhost:11434/api/tags 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        if result and result ~= "" then
          ollama_status = "✓"
        end
      end
      table.insert(status, "ollama: " .. ollama_status)
      
      vim.notify("AI Provider Status:\n" .. table.concat(status, "\n"), vim.log.levels.INFO)
    end, { desc = "Check AI provider status" })

    -- Notification about setup
    local available_providers = {}
    if get_api_key("openai") then table.insert(available_providers, "OpenAI") end
    if get_api_key("anthropic") then table.insert(available_providers, "Anthropic") end
    if get_api_key("gemini") then table.insert(available_providers, "Gemini") end
    table.insert(available_providers, "Ollama")
    
    vim.notify(
      "CodeCompanion loaded with providers: " .. table.concat(available_providers, ", ") .. 
      "\nUse <leader>aa to access AI actions, <leader>as to check status",
      vim.log.levels.INFO
    )
  end,
}