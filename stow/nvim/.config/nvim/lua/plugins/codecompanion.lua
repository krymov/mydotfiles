-- -- CodeCompanion: Advanced AI-powered coding assistant with agentic capabilities
-- -- Provides VS Code-style AI agents with custom roles, tools, and context awareness

-- return {
--   "olimorris/codecompanion.nvim",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-treesitter/nvim-treesitter",
--     "hrsh7th/nvim-cmp", -- For completion
--     "nvim-telescope/telescope.nvim", -- For file/symbol search
--     {
--       "stevearc/dressing.nvim", -- Enhanced UI for input dialogs
--       opts = {},
--     },
--   },
--   config = function()
--     local codecompanion = require("codecompanion")

--     -- Helper function to safely get Anthropic API key from environment
--     local function get_anthropic_key()
--       local key = vim.fn.getenv("ANTHROPIC_API_KEY")
--       if key == vim.NIL or key == "" then
--         vim.notify(
--           "Warning: ANTHROPIC_API_KEY not found in environment. CodeCompanion will not work.",
--           vim.log.levels.WARN
--         )
--         return nil
--       end

--       return key
--     end

--     -- Anthropic-only adapter configuration
--     local function get_available_adapters()
--       local anthropic_key = get_anthropic_key()
--       if not anthropic_key then
--         return {}
--       end

--       return {
--         -- Claude 3.5 Sonnet - Best for complex tasks, reasoning, and coding
--         anthropic_sonnet = {
--           name = "anthropic",
--           model = "claude-3-5-sonnet-20241022",
--           api_key = anthropic_key,
--         },
--         -- Claude 3.5 Haiku - Faster and cheaper for simpler tasks
--         anthropic_haiku = {
--           name = "anthropic",
--           model = "claude-3-5-haiku-20241022",
--           api_key = anthropic_key,
--         },
--       }
--     end

--     -- Get default adapter - always use Sonnet for primary tasks
--     local function get_default_adapter()
--       local anthropic_key = get_anthropic_key()
--       if anthropic_key then
--         return "anthropic_sonnet"
--       else
--         return nil
--       end
--     end

--     -- Get efficient adapter for simple tasks
--     local function get_efficient_adapter()
--       local anthropic_key = get_anthropic_key()
--       if anthropic_key then
--         return "anthropic_haiku"
--       else
--         return nil
--       end
--     end

--     codecompanion.setup({
--       adapters = get_available_adapters(),

--       strategies = {
--         chat = {
--           adapter = get_default_adapter(), -- Claude Sonnet for conversations
--         },
--         inline = {
--           adapter = get_efficient_adapter(), -- Claude Haiku for quick inline assistance
--         },
--         agent = {
--           adapter = get_default_adapter(), -- Claude Sonnet for complex agent tasks
--         },
--       },

--       -- Custom agent roles with specific capabilities
--       prompts = {
--         -- Code Refactoring Agent
--         ["Refactor"] = {
--           strategy = "chat",
--           description = "Refactor code while preserving behavior",
--           opts = {
--             adapter = get_default_adapter(), -- Use Sonnet for complex refactoring
--             auto_submit = false,
--           },
--           prompts = {
--             {
--               role = "system",
--               content = [[You are a precise refactoring assistant. Your goals:

-- 1. **Preserve Behavior**: Never change what the code does, only how it does it
-- 2. **Improve Readability**: Make code clearer and more maintainable
-- 3. **Minimal Changes**: Make the smallest changes necessary
-- 4. **Best Practices**: Apply language-specific conventions and patterns
-- 5. **Performance**: Consider performance implications

-- Focus on:
-- - Extracting functions/methods when appropriate
-- - Improving naming conventions
-- - Reducing complexity and nesting
-- - Eliminating code duplication
-- - Adding appropriate error handling
-- - Optimizing imports and dependencies

-- Always explain your changes and reasoning.]],
--             },
--             {
--               role = "user",
--               content = function()
--                 return "Please refactor this code:\n\n```"
--                   .. vim.bo.filetype
--                   .. "\n"
--                   .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
--                   .. "\n```"
--               end,
--             },
--           },
--         },

--         -- Test Generation Agent
--         ["TestGen"] = {
--           strategy = "chat",
--           description = "Generate comprehensive unit tests",
--           opts = {
--             adapter = get_default_adapter(), -- Use Sonnet for test generation
--             auto_submit = false,
--           },
--           prompts = {
--             {
--               role = "system",
--               content = [[You are a test generation specialist. Create comprehensive, maintainable tests that:

-- 1. **Cover Edge Cases**: Test boundary conditions, null/empty inputs, error conditions
-- 2. **Use Table-Driven Tests**: When appropriate for the language (Go, etc.)
-- 3. **Clear Test Names**: Descriptive test function/method names
-- 4. **Arrange-Act-Assert**: Structure tests clearly
-- 5. **Mock Dependencies**: Use appropriate mocking for external dependencies
-- 6. **Test Data**: Create realistic test data and fixtures

-- For each function/method:
-- - Test happy path scenarios
-- - Test error conditions and edge cases
-- - Test with various input combinations
-- - Verify all expected outputs and side effects

-- Include setup/teardown when needed and explain testing strategy.]],
--             },
--             {
--               role = "user",
--               content = function()
--                 return "Generate comprehensive tests for this code:\n\n```"
--                   .. vim.bo.filetype
--                   .. "\n"
--                   .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
--                   .. "\n```"
--               end,
--             },
--           },
--         },

--         -- Code Review Agent
--         ["Reviewer"] = {
--           strategy = "chat",
--           description = "Perform thorough code review",
--           opts = {
--             adapter = get_default_adapter(), -- Use Sonnet for detailed reviews
--             auto_submit = false,
--           },
--           prompts = {
--             {
--               role = "system",
--               content = [[You are a senior code reviewer conducting a thorough review. Focus on:

-- **Correctness**:
-- - Logic errors and edge cases
-- - Potential race conditions or concurrency issues
-- - Error handling completeness

-- **Security**:
-- - Input validation and sanitization
-- - Authentication and authorization
-- - Sensitive data handling
-- - Injection vulnerabilities

-- **Performance**:
-- - Algorithm efficiency
-- - Memory usage
-- - Database query optimization
-- - Caching opportunities

-- **Maintainability**:
-- - Code organization and structure
-- - Naming conventions
-- - Documentation and comments
-- - Testability

-- **Style & Standards**:
-- - Language-specific best practices
-- - Team coding standards
-- - Consistent formatting

-- Provide specific, actionable feedback with examples where helpful.]],
--             },
--             {
--               role = "user",
--               content = function()
--                 return "Please review this code:\n\n```"
--                   .. vim.bo.filetype
--                   .. "\n"
--                   .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
--                   .. "\n```"
--               end,
--             },
--           },
--         },

--         -- Documentation Agent
--         ["Docs"] = {
--           strategy = "chat",
--           description = "Generate comprehensive documentation",
--           opts = {
--             adapter = get_efficient_adapter(), -- Use Haiku for documentation (faster/cheaper)
--             auto_submit = false,
--           },
--           prompts = {
--             {
--               role = "system",
--               content = [[You are a technical documentation specialist. Create clear, comprehensive documentation that:

-- **Code Documentation**:
-- - Concise but complete function/method docstrings
-- - Parameter descriptions with types and constraints
-- - Return value descriptions
-- - Usage examples
-- - Exception/error documentation

-- **API Documentation**:
-- - Clear endpoint descriptions
-- - Request/response schemas
-- - Authentication requirements
-- - Rate limiting and usage notes

-- **README Content**:
-- - Project overview and purpose
-- - Installation and setup instructions
-- - Basic usage examples
-- - Configuration options
-- - Contributing guidelines

-- **Comments**:
-- - Explain complex logic and algorithms
-- - Document business rules and constraints
-- - Clarify non-obvious code sections

-- Focus on clarity, accuracy, and usefulness for other developers.]],
--             },
--             {
--               role = "user",
--               content = function()
--                 return "Generate documentation for this code:\n\n```"
--                   .. vim.bo.filetype
--                   .. "\n"
--                   .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
--                   .. "\n```"
--               end,
--             },
--           },
--         },

--         -- Debugging Agent
--         ["Debug"] = {
--           strategy = "chat",
--           description = "Help debug issues and analyze problems",
--           opts = {
--             adapter = get_default_adapter(), -- Use Sonnet for complex debugging
--             auto_submit = false,
--           },
--           prompts = {
--             {
--               role = "system",
--               content = [[You are a debugging specialist helping to identify and solve problems. Approach debugging systematically:

-- **Problem Analysis**:
-- - Understand the expected vs actual behavior
-- - Identify symptoms and error messages
-- - Consider recent changes that might have caused issues

-- **Root Cause Investigation**:
-- - Analyze code logic step by step
-- - Check for common error patterns
-- - Consider environmental factors

-- **Solution Strategy**:
-- - Suggest specific debugging techniques
-- - Recommend logging/instrumentation
-- - Propose test cases to isolate the issue
-- - Offer multiple potential solutions

-- **Prevention**:
-- - Suggest improvements to prevent similar issues
-- - Recommend better error handling
-- - Propose monitoring and alerting

-- Provide actionable debugging steps and potential fixes.]],
--             },
--             {
--               role = "user",
--               content = function()
--                 return "Help me debug this code:\n\n```"
--                   .. vim.bo.filetype
--                   .. "\n"
--                   .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
--                   .. "\n```"
--               end,
--             },
--           },
--         },

--         -- Architecture Agent
--         ["Architect"] = {
--           strategy = "chat",
--           description = "Provide architectural guidance and design review",
--           opts = {
--             adapter = get_default_adapter(), -- Use Sonnet for architectural analysis
--             auto_submit = false,
--           },
--           prompts = {
--             {
--               role = "system",
--               content = [[You are a senior software architect providing design guidance. Focus on:

-- **System Design**:
-- - Overall architecture patterns and principles
-- - Component separation and boundaries
-- - Data flow and system interactions
-- - Scalability and performance considerations

-- **Design Patterns**:
-- - Appropriate pattern selection for the problem
-- - Implementation best practices
-- - Trade-offs and alternatives

-- **Technology Choices**:
-- - Framework and library recommendations
-- - Database and storage decisions
-- - Integration and communication patterns

-- **Quality Attributes**:
-- - Maintainability and extensibility
-- - Reliability and fault tolerance
-- - Security and compliance
-- - Performance and scalability

-- Provide high-level guidance with practical implementation advice.]],
--             },
--             {
--               role = "user",
--               content = function()
--                 return "Please review the architecture of this code:\n\n```"
--                   .. vim.bo.filetype
--                   .. "\n"
--                   .. require("codecompanion.helpers.actions").get_code(vim.fn.line("'<"), vim.fn.line("'>"))
--                   .. "\n```"
--               end,
--             },
--           },
--         },
--       },

--       -- Display options
--       display = {
--         action_palette = {
--           width = 95,
--           height = 10,
--         },
--         chat = {
--           window = {
--             layout = "vertical", -- vertical|horizontal|buffer
--             width = 0.45,
--             height = 0.8,
--             relative = "editor",
--             border = "rounded",
--             title = "CodeCompanion",
--           },
--           show_settings = true,
--         },
--       },

--       -- General options
--       opts = {
--         log_level = "INFO", -- TRACE|DEBUG|INFO|WARN|ERROR
--         send_code = true,
--         use_default_actions = true,
--         use_default_prompts = true,
--       },
--     })

--     -- Helper function to check if we're in visual mode
--     local function get_visual_selection()
--       local mode = vim.fn.mode()
--       if mode == "v" or mode == "V" or mode == "\22" then -- \22 is <C-v>
--         return true
--       end
--       return false
--     end

--     -- Keybindings
--     local function map(mode, lhs, rhs, opts)
--       opts = opts or {}
--       opts.silent = opts.silent ~= false
--       vim.keymap.set(mode, lhs, rhs, opts)
--     end

--     -- AI Agent keybindings
--     map("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI: Show action palette" })
--     map("v", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI: Show action palette" })

--     -- Chat
--     map("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: Toggle chat" })
--     map("v", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: Toggle chat" })
--     map("n", "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", { desc = "AI: Add to chat" })
--     map("v", "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", { desc = "AI: Add to chat" })

--     -- Inline assistance
--     map("n", "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI: Inline assist" })
--     map("v", "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI: Inline assist" })

--     -- Agent roles
--     map("n", "<leader>ar", function()
--       codecompanion.prompt("Refactor")
--     end, { desc = "AI: Refactor code" })
--     map("v", "<leader>ar", function()
--       codecompanion.prompt("Refactor")
--     end, { desc = "AI: Refactor code" })

--     map("n", "<leader>at", function()
--       codecompanion.prompt("TestGen")
--     end, { desc = "AI: Generate tests" })
--     map("v", "<leader>at", function()
--       codecompanion.prompt("TestGen")
--     end, { desc = "AI: Generate tests" })

--     map("n", "<leader>av", function()
--       codecompanion.prompt("Reviewer")
--     end, { desc = "AI: Code review" })
--     map("v", "<leader>av", function()
--       codecompanion.prompt("Reviewer")
--     end, { desc = "AI: Code review" })

--     map("n", "<leader>ad", function()
--       codecompanion.prompt("Docs")
--     end, { desc = "AI: Generate docs" })
--     map("v", "<leader>ad", function()
--       codecompanion.prompt("Docs")
--     end, { desc = "AI: Generate docs" })

--     map("n", "<leader>aD", function()
--       codecompanion.prompt("Debug")
--     end, { desc = "AI: Debug help" })
--     map("v", "<leader>aD", function()
--       codecompanion.prompt("Debug")
--     end, { desc = "AI: Debug help" })

--     map("n", "<leader>aP", function()
--       codecompanion.prompt("Architect")
--     end, { desc = "AI: Architecture review" })
--     map("v", "<leader>aP", function()
--       codecompanion.prompt("Architect")
--     end, { desc = "AI: Architecture review" })

--     -- Quick actions
--     map("v", "<leader>ae", "<cmd>CodeCompanionChat<cr>", { desc = "AI: Explain code" })
--     map("v", "<leader>af", "<cmd>CodeCompanionChat<cr>", { desc = "AI: Fix code" })
--     map("v", "<leader>ao", "<cmd>CodeCompanionChat<cr>", { desc = "AI: Optimize code" })

--     -- Show available adapters and current config (Anthropic only)
--     map("n", "<leader>as", function()
--       local adapters = get_available_adapters()
--       local adapter_list = {}
--       for name, _ in pairs(adapters) do
--         table.insert(adapter_list, name)
--       end

--       local default_adapter = get_default_adapter()
--       local efficient_adapter = get_efficient_adapter()

--       vim.notify(
--         "Available Claude models: " .. table.concat(adapter_list, ", ") ..
--         "\nDefault (complex tasks): " .. (default_adapter or "none") ..
--         "\nEfficient (simple tasks): " .. (efficient_adapter or "none"),
--         vim.log.levels.INFO
--       )
--     end, { desc = "AI: Show available Claude models" })

--     -- Create user command for Anthropic API key status check
--     vim.api.nvim_create_user_command("CodeCompanionStatus", function()
--       local anthropic_key = get_anthropic_key()
--       local status = "Anthropic Claude: " .. (anthropic_key and "✓" or "✗")

--       if anthropic_key then
--         vim.notify(
--           "CodeCompanion Status:\n" .. status ..
--           "\n\nAvailable models:\n  • Claude 3.5 Sonnet (complex tasks)\n  • Claude 3.5 Haiku (simple tasks)",
--           vim.log.levels.INFO
--         )
--       else
--         vim.notify(
--           "CodeCompanion Status:\n" .. status ..
--           "\n\nTo set up Anthropic API key:\n  ./ai-keys add anthropic",
--           vim.log.levels.WARN
--         )
--       end
--     end, { desc = "Check Anthropic Claude status" })

--     -- Notification about setup
--     local anthropic_key = get_anthropic_key()
--     if anthropic_key then
--       vim.notify(
--         "CodeCompanion loaded with Anthropic Claude models" ..
--         "\nUse <leader>aa for AI actions, <leader>as to check status",
--         vim.log.levels.INFO
--       )
--     else
--       vim.notify(
--         "CodeCompanion: No Anthropic API key found" ..
--         "\nRun './ai-keys add anthropic' to set up Claude access",
--         vim.log.levels.WARN
--       )
--     end
--   end,
-- }
