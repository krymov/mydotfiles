# CodeCompanion AI Quick Reference

## Setup
```bash
./ai-keys setup                    # Initial setup
./ai-keys add anthropic           # Add Claude (recommended)
./ai-keys add openai              # Add GPT-4o
./ai-keys test                    # Test all providers
```

## Core Keybindings
| Key | Action |
|-----|--------|
| `<leader>aa` | AI action palette |
| `<leader>ac` | Toggle AI chat |
| `<leader>ai` | Inline assistance |
| `<leader>as` | Provider status |

## AI Agents
| Key | Agent | Purpose |
|-----|-------|---------|
| `<leader>ar` | Refactor | Improve code structure |
| `<leader>at` | TestGen | Generate unit tests |
| `<leader>av` | Reviewer | Code review |
| `<leader>ad` | Docs | Documentation |
| `<leader>aD` | Debug | Debug assistance |
| `<leader>aP` | Architect | Design review |

## Quick Visual Actions
| Key | Action |
|-----|--------|
| `<leader>ae` | Explain code |
| `<leader>af` | Fix code |
| `<leader>ao` | Optimize code |

## Commands
```vim
:CodeCompanionStatus              " Check provider status
:CodeCompanionChat Toggle         " Toggle chat window
:CodeCompanionActions             " Show action palette
```

## Workflow Tips
1. **Select code** in visual mode before using agents
2. **Use specific agents** for focused assistance
3. **Chain agents**: Refactor → Test → Review → Document
4. **Chat mode** for exploratory discussions
5. **Inline mode** for quick code generation

## Providers (Auto-selected)
- **Claude 3.5 Sonnet** - Best for complex analysis
- **GPT-4o** - Great for code generation  
- **GPT-4o-mini** - Fast for simple tasks
- **Ollama** - Local/private processing

## Troubleshooting
```bash
./ai-keys status                  # Check setup
echo $ANTHROPIC_API_KEY          # Verify key loaded
:checkhealth                     # Neovim health check
```

💡 **Pro Tip**: Start with Claude 3.5 Sonnet for best results!