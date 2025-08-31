# AI-Powered Coding with CodeCompanion in AstroNvim

This setup integrates advanced AI capabilities into your AstroNvim configuration, providing VS Code-style AI agents with specialized roles for different coding tasks.

## Features

### 🤖 AI Agents (Custom Roles)
- **Refactor Agent** - Intelligent code refactoring while preserving behavior
- **TestGen Agent** - Comprehensive test generation with edge cases
- **Reviewer Agent** - Thorough code review focusing on correctness, security, and performance  
- **Docs Agent** - Documentation generation and improvement
- **Debug Agent** - Systematic debugging assistance
- **Architect Agent** - High-level architectural guidance and design review

### 🔌 Multiple AI Providers
- **OpenAI** - GPT-4o, GPT-4o-mini
- **Anthropic** - Claude 3.5 Sonnet, Claude 3.5 Haiku
- **Google Gemini** - Gemini 1.5 Pro
- **Ollama** - Local models (Llama 3.1, Codestral, etc.)

### 🛡️ Secure API Key Management
- Encrypted storage of API keys
- Environment-based configuration
- Easy key rotation and management
- Support for multiple providers

## Quick Start

### 1. Setup API Keys

```bash
# Run the setup script
./ai-keys setup

# Add your API keys (choose your preferred providers)
./ai-keys add openai      # For GPT-4o
./ai-keys add anthropic   # For Claude 3.5 (recommended)
./ai-keys add gemini      # For Gemini Pro

# Test connectivity
./ai-keys test
```

### 2. Install Ollama (Optional - for local models)

```bash
# Install Ollama
brew install ollama

# Start Ollama service
ollama serve

# Install recommended models
ollama pull llama3.1:latest
ollama pull codestral:latest
```

### 3. Launch Neovim

```bash
# Switch to AstroNvim configuration
nvim-switch switch astronvim

# Launch Neovim
nvim
```

### 4. Check AI Status

In Neovim, run:
```vim
:CodeCompanionStatus
```

Or use the keybinding: `<leader>as`

## Keybindings

### Core Actions
| Key | Mode | Action |
|-----|------|--------|
| `<leader>aa` | Normal/Visual | Show AI action palette |
| `<leader>ac` | Normal/Visual | Toggle AI chat |
| `<leader>ai` | Normal/Visual | Inline AI assistance |
| `<leader>as` | Normal | Show AI provider status |

### AI Agents
| Key | Mode | Agent | Purpose |
|-----|------|--------|---------|
| `<leader>ar` | Normal/Visual | Refactor | Code refactoring |
| `<leader>at` | Normal/Visual | TestGen | Generate tests |
| `<leader>av` | Normal/Visual | Reviewer | Code review |
| `<leader>ad` | Normal/Visual | Docs | Documentation |
| `<leader>aD` | Normal/Visual | Debug | Debug assistance |
| `<leader>aP` | Normal/Visual | Architect | Architecture review |

### Quick Actions (Visual Mode)
| Key | Action |
|-----|--------|
| `<leader>ae` | Explain selected code |
| `<leader>af` | Fix selected code |
| `<leader>ao` | Optimize selected code |

## Workflows

### 1. Code Refactoring
1. Select code in visual mode
2. Press `<leader>ar` (Refactor agent)
3. Review the refactoring suggestions
4. Apply changes selectively

### 2. Test Generation
1. Position cursor in function/class to test
2. Press `<leader>at` (TestGen agent)
3. Review generated tests
4. Copy to test files

### 3. Code Review
1. Stage your changes: `git add .`
2. Select code or use on whole buffer
3. Press `<leader>av` (Reviewer agent)
4. Address review feedback

### 4. Documentation
1. Select function/class or entire file
2. Press `<leader>ad` (Docs agent)
3. Review and integrate documentation

### 5. Debugging Help
1. Select problematic code
2. Press `<leader>aD` (Debug agent)
3. Follow debugging suggestions

### 6. Architecture Review
1. Select larger code sections
2. Press `<leader>aP` (Architect agent)
3. Review architectural recommendations

## API Key Management

### Adding Keys
```bash
# Add OpenAI key
./ai-keys add openai

# Add Anthropic key (recommended for best results)
./ai-keys add anthropic

# Add Gemini key
./ai-keys add gemini
```

### Managing Keys
```bash
# List configured providers
./ai-keys list

# Test connectivity
./ai-keys test openai
./ai-keys test        # Test all

# Remove a key
./ai-keys remove openai
```

### Security
- API keys stored in `~/.config/ai-keys.env` with 600 permissions
- Keys loaded via environment variables
- Never committed to version control
- Easy rotation and removal

## Provider Recommendations

### Best Overall: Anthropic Claude 3.5 Sonnet
- Excellent at code analysis and refactoring
- Strong architectural understanding
- Great for code review and documentation
- More cost-effective than GPT-4

### For Speed: OpenAI GPT-4o-mini
- Fast responses
- Good for quick explanations and documentation
- Cost-effective for high-volume usage

### For Privacy: Ollama (Local)
- Completely local processing
- No API costs
- Good for sensitive codebases
- Requires local GPU/CPU resources

### Model Selection Strategy
The configuration automatically selects the best available model:
1. **Agent roles**: Use Claude 3.5 Sonnet (if available)
2. **Quick tasks**: Use GPT-4o-mini or Gemini
3. **Fallback**: Local Ollama models

## Customization

### Adding Custom Agents
Edit `/Users/mark/.dotfiles/stow/nvim/.config/nvim/lua/plugins/codecompanion.lua`:

```lua
prompts = {
  ["MyAgent"] = {
    strategy = "chat",
    description = "My custom agent",
    opts = {
      adapter = "anthropic_sonnet",
      auto_submit = false,
    },
    prompts = {
      {
        role = "system",
        content = "Your custom system prompt here...",
      },
      {
        role = "user", 
        content = function()
          return "Your dynamic user prompt..."
        end,
      },
    },
  },
}
```

### Changing Default Models
Modify the adapter configuration in the same file:
```lua
strategies = {
  chat = {
    adapter = "anthropic_sonnet", -- Change default here
  },
}
```

## Troubleshooting

### API Keys Not Working
1. Check key format: `./ai-keys test <provider>`
2. Verify environment loading: `echo $OPENAI_API_KEY`
3. Restart terminal after adding keys
4. Check provider status: `:CodeCompanionStatus` in Neovim

### Ollama Not Connecting
1. Start Ollama: `ollama serve`
2. Check models: `ollama list`
3. Test connection: `curl http://localhost:11434/api/tags`

### Plugin Not Loading
1. Check AstroNvim logs: `:checkhealth`
2. Verify plugin installation: `:Lazy`
3. Check for conflicts: `:messages`

## Advanced Usage

### Workspace Context
CodeCompanion automatically includes:
- Current file content
- Visual selections
- Git diff information
- Diagnostic information
- Project structure context

### Chaining Agents
1. Use Refactor agent to improve code
2. Use TestGen agent to create tests
3. Use Reviewer agent to validate both
4. Use Docs agent to document final result

### Integration with AstroNvim
- Works with AstroNvim's LSP configuration
- Integrates with existing keybinding patterns
- Respects AstroNvim's UI conventions
- Compatible with all AstroNvim plugins

## Cost Management

### Estimated Usage Costs
- **Development session**: $0.10-0.50/day
- **Code review**: $0.05-0.15 per review
- **Documentation**: $0.02-0.10 per file

### Cost Optimization
1. Use GPT-4o-mini for simple tasks
2. Use Claude Haiku for speed/cost balance
3. Use Ollama for extensive testing
4. Set up usage monitoring via provider dashboards

## Getting Help

### In Neovim
- `:CodeCompanionStatus` - Check provider status
- `<leader>aa` - Open action palette
- `:help codecompanion` - Plugin documentation

### Command Line
- `./ai-keys help` - API key management help
- `./ai-keys status` - Show Neovim status info

### Common Issues
1. **"No API key found"** - Run `./ai-keys add <provider>`
2. **"Connection failed"** - Check internet and API key validity
3. **"Model not available"** - Verify provider account and billing
4. **"Slow responses"** - Try switching to faster models (GPT-4o-mini, Haiku)

## What's Next?

This setup provides a solid foundation for AI-assisted development. Consider:

1. **Experimenting with different agents** for your specific workflow
2. **Creating custom prompts** for your domain/tech stack
3. **Setting up team-shared configurations** for consistent AI assistance
4. **Exploring local models** for privacy-sensitive projects

The AI coding revolution is here - this setup puts enterprise-grade AI assistance directly into your Neovim workflow! 🚀