# 🚀 Dotfiles Setup Guide

A comprehensive walkthrough for setting up your development environment from scratch.

## 📋 Prerequisites

### Required Tools
Before starting, ensure these tools are installed:

```bash
# macOS (using Homebrew)
brew install stow neovim git

# Ubuntu/Debian
sudo apt update && sudo apt install stow neovim git

# Arch Linux
sudo pacman -S stow neovim git

# Fedora
sudo dnf install stow neovim git
```

### System Requirements
- **OS**: macOS, Linux (any distribution)
- **Shell**: Zsh (recommended) or Bash
- **Terminal**: Any terminal emulator (Kitty recommended)
- **Git**: Version 2.0 or higher

## 🛠️ Installation Process

### Step 1: Clone the Repository
```bash
# Clone to your home directory
git clone https://github.com/your-username/mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Step 2: Run the Setup Script
```bash
# Make the setup script executable and run it
chmod +x setup.sh
./setup.sh
```

The setup script will:
- ✅ Check for required dependencies
- 🔄 Backup existing configurations
- 🔗 Create symlinks using GNU Stow
- ⚡ Configure the Neovim switcher
- 🎨 Set up shell integration

### Step 3: Configure Git (if needed)
```bash
# Set your Git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 4: Restart Your Shell
```bash
# Reload your shell configuration
source ~/.zshrc
# or restart your terminal
```

## 🎯 Post-Installation Setup

### Configure Neovim
```bash
# See available configurations
nvim-switch list

# Switch to AstroNvim (recommended)
nvim-switch switch astronvim

# Clean old data when switching
nvim-switch clean
```

### Set Up AI Coding (Optional but Recommended)
```bash
# Initialize AI key management
./ai-keys setup

# Add your preferred AI provider
./ai-keys add anthropic    # Claude 3.5 (recommended)
./ai-keys add openai       # GPT-4o
./ai-keys add gemini       # Google Gemini

# Test the connection
./ai-keys test

# Install local AI (optional)
brew install ollama
ollama serve
ollama pull llama3.1:latest
```

### Configure Development Environments
```bash
# For Python projects
cd your-python-project
nix develop ../path/to/dotfiles/flakes/python

# For Go projects  
cd your-go-project
nix develop ../path/to/dotfiles/flakes/go

# For Node.js projects
cd your-nodejs-project
nix develop ../path/to/dotfiles/flakes/nodejs
```

## 📁 What Gets Installed

### Configurations Managed by Stow
- **Git** (`~/.gitconfig`) - Aliases and settings
- **Zsh** (`~/.zshrc`, `~/.zsh/`) - Shell configuration
- **Kitty** (`~/.config/kitty/`) - Terminal emulator
- **Tmux** (`~/.tmux.conf`) - Terminal multiplexer
- **SSH** (`~/.ssh/config`) - SSH client configuration

### Neovim Configurations
- **AstroNvim** - Full-featured IDE experience
- **LazyVim** - Fast, modern configuration
- **Vanilla** - Minimal setup

### AI Integration
- **CodeCompanion** - AI-powered coding assistant
- **API Key Management** - Secure key storage
- **Multiple Providers** - OpenAI, Anthropic, Gemini, Ollama

## 🎨 Customization

### Directory Structure
```
~/.dotfiles/
├── setup.sh           # Main setup script
├── ai-keys            # AI key management
├── nvim-switch        # Neovim configuration switcher
├── guides/            # Documentation
├── stow/              # Stow-managed configs
│   ├── git/
│   ├── kitty/
│   ├── nvim/
│   ├── ssh/
│   ├── tmux/
│   └── zsh/
├── configs/           # Alternative configs
│   ├── nvim-lazyvim/
│   └── nvim-vanilla/
└── flakes/            # Nix development environments
    ├── go/
    ├── nodejs/
    ├── python/
    └── rust/
```

### Adding Your Own Configurations
1. **Create a new stow package**:
   ```bash
   mkdir -p stow/myapp/.config/myapp
   # Add your config files
   ```

2. **Stow the package**:
   ```bash
   cd stow
   stow -t "$HOME" myapp
   ```

3. **Add to setup script** (optional):
   Edit `setup.sh` to include your new package.

## 🔧 Essential Commands

### Daily Usage
```bash
# Switch Neovim configs
nvim-switch switch astronvim
nvim-switch current

# Manage AI keys
./ai-keys list
./ai-keys test anthropic

# Update configurations
git pull
stow -R -t "$HOME" -d stow zsh git kitty

# Backup before changes
nvim-switch backup
```

### Maintenance
```bash
# Update Neovim plugins
nvim +Lazy sync +qa

# Clean Neovim data
nvim-switch clean

# Check system health
nvim +checkhealth +qa

# Test AI connectivity
./ai-keys test
```

## 🚨 Common Issues & Solutions

### Stow Conflicts
**Problem**: "WARNING: in simulation mode; no changes made"
```bash
# Solution: Remove conflicting files first
rm ~/.zshrc  # or back it up
stow -t "$HOME" -d stow zsh
```

### Neovim Won't Start
**Problem**: Neovim shows errors on startup
```bash
# Solution: Clean data and reinstall
nvim-switch clean
nvim-switch switch astronvim
```

### AI Keys Not Working
**Problem**: "No API key found"
```bash
# Solution: Verify environment loading
echo $ANTHROPIC_API_KEY
source ~/.config/ai-keys.env
```

### Git Configuration Missing
**Problem**: Git asks for user info
```bash
# Solution: Set global Git config
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## ✅ Verification Checklist

After setup, verify everything works:

- [ ] Shell loads without errors: `echo $SHELL`
- [ ] Neovim starts successfully: `nvim --version`
- [ ] Git is configured: `git config --list`
- [ ] Stow links are created: `ls -la ~/.zshrc`
- [ ] AI providers work: `./ai-keys test`
- [ ] Neovim switching works: `nvim-switch list`

## 🎯 Next Steps

1. **Read the [Daily Workflow Guide](daily-workflow.md)** for essential shortcuts
2. **Explore [AI Coding Features](AI_CODING_GUIDE.md)** for enhanced productivity
3. **Check out [Nix Development Environments](nix-guide.md)** for project isolation
4. **Customize to your preferences** using the configuration guides

## 🆘 Getting Help

- **Check the [Troubleshooting Guide](troubleshooting.md)** for common issues
- **Review logs**: Most tools provide helpful error messages
- **Test individual components**: Use the verification checklist above
- **Start fresh**: The setup script can be run multiple times safely

---

**Congratulations!** 🎉 You now have a powerful, AI-enhanced development environment. Enjoy coding with your new superpowers!