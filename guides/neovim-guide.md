# 🎛️ Neovim Configuration Management Guide

Master the art of switching between different Neovim configurations and managing your editing environment.

## 🔄 Understanding nvim-switch

The `nvim-switch` utility allows you to seamlessly switch between different Neovim configurations without losing your data or breaking your setup.

### Available Configurations

| Configuration | Description | Best For |
|---------------|-------------|----------|
| **astronvim** | Full-featured IDE experience | Daily development, AI coding |
| **lazyvim** | Fast, modern configuration | Quick edits, performance |
| **vanilla** | Minimal, clean setup | Learning Vim, minimal environments |

## 🚀 Basic Operations

### Listing Configurations
```bash
# See all available configurations
nvim-switch list

# Example output:
# Available configurations:
#   - astronvim (current)
#   - lazyvim
#   - vanilla
```

### Switching Configurations
```bash
# Switch to AstroNvim (recommended for AI coding)
nvim-switch switch astronvim

# Switch to LazyVim for fast startup
nvim-switch switch lazyvim

# Switch to vanilla for minimal setup
nvim-switch switch vanilla

# Check current configuration
nvim-switch current
```

### Data Management
```bash
# Backup current Neovim data before switching
nvim-switch backup

# Clean data and cache (useful when switching)
nvim-switch clean

# Show available backups
nvim-switch restore
```

## 🎨 Configuration Details

### AstroNvim Configuration
**Location**: `~/.dotfiles/stow/nvim/.config/nvim/`
**Features**:
- Full IDE experience with LSP, debugging, and Git integration
- AI-powered coding with CodeCompanion
- Beautiful UI with status line and file explorer
- Extensive plugin ecosystem
- Perfect for daily development work

**Key Plugins**:
- **CodeCompanion** - AI coding assistant
- **Telescope** - Fuzzy finder
- **Neo-tree** - File explorer
- **Which-key** - Keybinding helper
- **LSP** - Language server protocol
- **Treesitter** - Syntax highlighting

**Keybindings**:
```vim
<leader>ff     " Find files
<leader>fw     " Find word
<leader>aa     " AI action palette
<leader>e      " File explorer
<Space>        " Leader key
```

### LazyVim Configuration
**Location**: `~/.dotfiles/configs/nvim-lazyvim/`
**Features**:
- Fast startup time
- Modern Lua configuration
- Sensible defaults
- Easy customization
- Great for quick edits

**Setup**:
```bash
# Switch to LazyVim
nvim-switch switch lazyvim

# First launch will install plugins
nvim

# Check health
:checkhealth
```

### Vanilla Configuration
**Location**: `~/.dotfiles/configs/nvim-vanilla/`
**Features**:
- Minimal plugin count
- Fast and lightweight
- Great for learning Vim
- SSH-friendly

**Perfect for**:
- Remote servers
- Learning Vim fundamentals
- Quick configuration edits
- Low-resource environments

## 🛠️ Advanced Management

### Safe Switching Workflow
```bash
# 1. Backup current state
nvim-switch backup

# 2. Check what you're switching from
nvim-switch current

# 3. Switch to new configuration
nvim-switch switch lazyvim

# 4. Test the new configuration
nvim --version
nvim +checkhealth +qa

# 5. If issues, clean and retry
nvim-switch clean
nvim-switch switch lazyvim
```

### Managing Plugin Data
```bash
# View plugin installation status
nvim +Lazy +qa

# Clean old plugin data when switching
nvim-switch clean

# Reinstall all plugins
nvim +Lazy clean +qa
nvim +Lazy sync +qa
```

### Backup and Restore
```bash
# Create backup before major changes
nvim-switch backup

# List backups with timestamps
ls ~/.dotfiles/nvim-backups/
# Example: 20231201_143022/

# Manually restore from backup
cp -r ~/.dotfiles/nvim-backups/20231201_143022/share ~/.local/share/nvim
cp -r ~/.dotfiles/nvim-backups/20231201_143022/cache ~/.cache/nvim
```

## 🎯 Configuration-Specific Workflows

### AstroNvim Workflow (AI-Enhanced Development)
```bash
# Switch to AstroNvim
nvim-switch switch astronvim

# Launch with project
nvim my-project/

# Essential keybindings:
# <leader>aa  - AI actions
# <leader>ff  - Find files  
# <leader>fw  - Find word
# <leader>e   - File explorer
# <leader>gg  - Git status
```

### LazyVim Workflow (Fast Development)
```bash
# Switch to LazyVim
nvim-switch switch lazyvim

# Quick file editing
nvim file.py

# Essential keybindings:
# <leader>e   - File explorer
# <leader>ff  - Find files
# <leader>sg  - Live grep
# <leader>L   - Lazy plugin manager
```

### Vanilla Workflow (Learning/Minimal)
```bash
# Switch to vanilla
nvim-switch switch vanilla

# Pure Vim experience
nvim file.txt

# Focus on Vim fundamentals:
# :e filename  - Edit file
# :w           - Save
# :q           - Quit
# /pattern     - Search
```

## 🔧 Customization

### Adding Your Own Configuration
```bash
# 1. Create configuration directory
mkdir -p ~/.dotfiles/configs/nvim-custom

# 2. Add init.lua
cat > ~/.dotfiles/configs/nvim-custom/init.lua << 'EOF'
-- Your custom Neovim configuration
vim.opt.number = true
vim.opt.relativenumber = true
-- Add your settings here
EOF

# 3. Update nvim-switch to include your config
# Edit ~/.dotfiles/nvim-switch and add to CONFIGS array:
# "custom:$DOTFILES_DIR/configs/nvim-custom"
```

### Per-Project Configurations
```bash
# Create project-specific settings
mkdir -p my-project/.nvim
cat > my-project/.nvim/init.lua << 'EOF'
-- Project-specific settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
EOF

# Launch with project config
cd my-project
nvim -u .nvim/init.lua
```

### Sharing Configurations
```bash
# Export configuration
tar -czf my-nvim-config.tar.gz ~/.dotfiles/configs/nvim-custom/

# Import on another machine
cd ~/.dotfiles/configs/
tar -xzf my-nvim-config.tar.gz

# Update nvim-switch and use
nvim-switch switch custom
```

## 🚨 Troubleshooting

### Configuration Won't Switch
```bash
# Check if target configuration exists
ls -la ~/.dotfiles/configs/nvim-lazyvim/

# Verify nvim-switch is executable
chmod +x ~/.dotfiles/nvim-switch

# Check for permission issues
ls -la ~/.config/nvim
```

### Plugins Not Loading After Switch
```bash
# Clean plugin cache
nvim-switch clean

# Reinstall plugins
nvim +Lazy clean +qa
nvim +Lazy sync +qa

# Check for conflicts
nvim +checkhealth +qa
```

### Lost Configuration
```bash
# Check available backups
nvim-switch restore

# Restore from Git
cd ~/.dotfiles
git status
git checkout HEAD -- stow/nvim/.config/nvim/

# Reset to known good state
nvim-switch switch astronvim
```

## 📊 Performance Comparison

### Startup Times (approximate)
| Configuration | Cold Start | Warm Start | Plugin Count |
|---------------|------------|------------|--------------|
| Vanilla | 50ms | 30ms | ~5 |
| LazyVim | 200ms | 100ms | ~30 |
| AstroNvim | 400ms | 200ms | ~50 |

### Memory Usage
| Configuration | RAM Usage | Best For |
|---------------|-----------|----------|
| Vanilla | ~20MB | SSH, learning |
| LazyVim | ~80MB | Daily coding |
| AstroNvim | ~150MB | Full IDE experience |

## 🎯 Best Practices

### Daily Development
- **Use AstroNvim** for main development with AI assistance
- **Switch to LazyVim** for quick edits or when you need speed
- **Use vanilla** for remote servers or when learning Vim

### Configuration Management
- **Always backup** before major changes
- **Test configurations** in isolated environments first
- **Keep custom changes** in separate files for easy migration
- **Document your modifications** for future reference

### Plugin Management
- **Update regularly**: `nvim +Lazy sync +qa`
- **Clean unused plugins**: `nvim +Lazy clean +qa`
- **Monitor startup time**: `:Lazy profile`
- **Check health**: `:checkhealth`

## 💡 Tips & Tricks

### Quick Switching
```bash
# Add aliases to your shell for quick switching
alias nva="nvim-switch switch astronvim && echo 'Switched to AstroNvim'"
alias nvl="nvim-switch switch lazyvim && echo 'Switched to LazyVim'"
alias nvv="nvim-switch switch vanilla && echo 'Switched to Vanilla'"
```

### Configuration Testing
```bash
# Test configuration without switching
nvim -u ~/.dotfiles/configs/nvim-lazyvim/init.lua

# Start with minimal config for debugging
nvim --clean
nvim --noplugin
```

### Automated Workflows
```bash
# Script to switch and launch project
#!/bin/bash
nvim-switch switch astronvim
cd ~/projects/my-project
nvim .
```

---

**Master Tip**: The key to effective Neovim configuration management is understanding when to use each configuration. AstroNvim for heavy development, LazyVim for speed, and vanilla for simplicity. Switch confidently knowing your data is safe! 🎯