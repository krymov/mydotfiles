# 🔧 Troubleshooting Guide

Common issues and their solutions for the dotfiles setup.

## 🚨 Quick Diagnostics

Run these commands to quickly identify issues:

```bash
# Check basic setup
echo $SHELL                    # Should show /bin/zsh or similar
which nvim                     # Should show nvim path
git --version                  # Should show Git version
stow --version                 # Should show Stow version

# Check dotfiles health
cd ~/.dotfiles
./ai-keys status              # Check AI setup
nvim-switch current           # Check Neovim config
ls -la ~/.zshrc               # Should be a symlink
```

## 🐛 Common Issues

### Setup & Installation

#### ❌ "Command not found: stow"
**Symptoms**: `stow: command not found` when running setup
**Solution**:
```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow

# Arch Linux
sudo pacman -S stow

# Fedora
sudo dnf install stow
```

#### ❌ Setup Script Fails with Permission Errors
**Symptoms**: "Permission denied" during setup
**Solution**:
```bash
# Make script executable
chmod +x setup.sh

# If still failing, check ownership
ls -la setup.sh
sudo chown $USER:$USER setup.sh
```

#### ❌ Stow Conflicts
**Symptoms**: "WARNING: in simulation mode; no changes made"
**Solution**:
```bash
# Backup existing files
mkdir -p ~/config-backup
mv ~/.zshrc ~/config-backup/  # backup conflicting files

# Then re-run stow
cd ~/.dotfiles/stow
stow -t "$HOME" zsh
```

### Shell Issues

#### ❌ Zsh Not Loading Correctly
**Symptoms**: Shell starts but aliases/functions don't work
**Solution**:
```bash
# Check if .zshrc is a symlink
ls -la ~/.zshrc

# If not, re-create symlink
rm ~/.zshrc
cd ~/.dotfiles/stow
stow -t "$HOME" zsh

# Reload shell
source ~/.zshrc
```

#### ❌ "command not found" for Custom Aliases
**Symptoms**: Custom git aliases like `gs` don't work
**Solution**:
```bash
# Check if git config is linked
ls -la ~/.gitconfig

# Re-stow git configuration
cd ~/.dotfiles/stow
stow -t "$HOME" git

# Check aliases are loaded
git config --get-regexp alias
```

#### ❌ PATH Not Updated
**Symptoms**: Can't find `nvim-switch` or other custom tools
**Solution**:
```bash
# Check PATH includes dotfiles
echo $PATH | grep dotfiles

# If missing, reload shell config
source ~/.zshrc

# Or add manually to .zshrc
echo 'export PATH="$HOME/.dotfiles:$PATH"' >> ~/.zshrc
```

### Neovim Issues

#### ❌ Neovim Won't Start
**Symptoms**: Error messages on nvim startup
**Solution**:
```bash
# Clean Neovim data
nvim-switch clean

# Switch to known good config
nvim-switch switch astronvim

# Check for plugin conflicts
nvim --clean  # Start without plugins

# View error details
nvim +checkhealth
```

#### ❌ "No configuration found"
**Symptoms**: `nvim-switch` shows no configurations
**Solution**:
```bash
# Verify configs exist
ls -la ~/.dotfiles/stow/nvim/.config/nvim
ls -la ~/.dotfiles/configs/

# Re-run setup
./setup.sh

# Manually create symlink if needed
ln -sf ~/.dotfiles/stow/nvim/.config/nvim ~/.config/nvim
```

#### ❌ Plugins Not Loading
**Symptoms**: Neovim starts but plugins missing
**Solution**:
```bash
# In Neovim, reinstall plugins
:Lazy clean
:Lazy sync

# Or from command line
nvim +Lazy sync +qa

# Check plugin directory
ls ~/.local/share/nvim/lazy/
```

#### ❌ LSP Not Working
**Symptoms**: No autocompletion, diagnostics, or goto definition
**Solution**:
```bash
# In Neovim, check LSP status
:checkhealth lsp

# Install language servers
:Mason

# Restart LSP
:LspRestart

# Check if LSP is attached
:LspInfo
```

### AI Coding Issues

#### ❌ "No API key found"
**Symptoms**: AI features don't work, key errors
**Solution**:
```bash
# Check if keys are set
echo $OPENAI_API_KEY
echo $ANTHROPIC_API_KEY

# Re-source environment
source ~/.config/ai-keys.env

# Verify key file exists and has correct permissions
ls -la ~/.config/ai-keys.env
chmod 600 ~/.config/ai-keys.env

# Re-add keys if needed
./ai-keys add anthropic
```

#### ❌ AI Providers Not Connecting
**Symptoms**: API errors, timeout messages
**Solution**:
```bash
# Test connectivity
./ai-keys test anthropic
./ai-keys test openai

# Check internet connection
ping api.openai.com
ping api.anthropic.com

# Verify API key format
./ai-keys list
```

#### ❌ CodeCompanion Plugin Not Loading
**Symptoms**: AI keybindings don't work
**Solution**:
```bash
# In Neovim, check plugin status
:Lazy

# Reinstall CodeCompanion
:Lazy clean codecompanion.nvim
:Lazy sync

# Check for config errors
:messages

# Verify plugin file exists
ls ~/.dotfiles/stow/nvim/.config/nvim/lua/plugins/codecompanion.lua
```

#### ❌ Ollama Not Working
**Symptoms**: Local AI models not accessible
**Solution**:
```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Start Ollama service
ollama serve

# Install models
ollama pull llama3.1:latest
ollama pull codestral:latest

# Check installed models
ollama list
```

### Git Issues

#### ❌ Git User Not Set
**Symptoms**: "Please tell me who you are" error
**Solution**:
```bash
# Set global Git configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify settings
git config --list | grep user
```

#### ❌ Git Aliases Not Working
**Symptoms**: Commands like `gs`, `gaa` not found
**Solution**:
```bash
# Check if git config is stowed
ls -la ~/.gitconfig

# Re-stow git configuration
cd ~/.dotfiles/stow
stow -t "$HOME" git

# Verify aliases are loaded
git config --get-regexp alias
```

### Nix Development Issues

#### ❌ "nix: command not found"
**Symptoms**: Nix flakes don't work
**Solution**:
```bash
# Install Nix (if not installed)
curl -L https://nixos.org/nix/install | sh

# Enable flakes
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Source Nix profile
source ~/.nix-profile/etc/profile.d/nix.sh
```

#### ❌ Flake Development Environment Not Starting
**Symptoms**: `nix develop` fails
**Solution**:
```bash
# Check flake syntax
cd ~/.dotfiles/flakes/python
nix flake check

# Update flake inputs
nix flake update

# Try with verbose output
nix develop --verbose
```

## 🔍 Advanced Debugging

### Enable Verbose Logging
```bash
# Neovim with debug info
nvim --cmd "set verbose=15" --cmd "set verbosefile=/tmp/nvim.log"

# Zsh with debug
zsh -x

# Git with verbose output
git --verbose status
```

### Check File Permissions
```bash
# Verify dotfiles permissions
find ~/.dotfiles -type f -name "*.sh" -exec ls -la {} \;

# Check sensitive files
ls -la ~/.config/ai-keys.env  # Should be 600
ls -la ~/.ssh/config          # Should be 600
```

### Inspect Symlinks
```bash
# Check all stow-managed symlinks
find ~ -maxdepth 2 -type l -exec ls -la {} \; | grep dotfiles

# Verify specific symlinks
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim
```

## 🧪 Testing Components

### Test Individual Components
```bash
# Test shell configuration
zsh -c "source ~/.zshrc && echo 'Shell OK'"

# Test Neovim minimal
nvim --clean --cmd "quit"

# Test git configuration
git config --list | head -10

# Test AI without full setup
ANTHROPIC_API_KEY="your-key" nvim -c "lua print('AI test')" -c "quit"
```

### Validate Setup State
```bash
# Create a comprehensive health check
cat > /tmp/health-check.sh << 'EOF'
#!/bin/bash
echo "=== Dotfiles Health Check ==="
echo "Shell: $SHELL"
echo "Neovim: $(nvim --version | head -1)"
echo "Git: $(git --version)"
echo "Stow: $(stow --version | head -1)"
echo "Current config: $(~/.dotfiles/nvim-switch current)"
echo "AI keys: $(ls ~/.config/ai-keys.env 2>/dev/null && echo 'Found' || echo 'Missing')"
echo "Dotfiles dir: $(ls -d ~/.dotfiles 2>/dev/null && echo 'Found' || echo 'Missing')"
EOF

chmod +x /tmp/health-check.sh
/tmp/health-check.sh
```

## 🆘 Recovery Procedures

### Soft Reset (Preserve Custom Changes)
```bash
# Backup custom configurations
mkdir -p ~/dotfiles-backup
cp -r ~/.dotfiles/custom-configs ~/dotfiles-backup/ 2>/dev/null || true

# Re-run setup
cd ~/.dotfiles
git stash  # Save any local changes
git pull origin main
./setup.sh

# Restore custom configs
cp -r ~/dotfiles-backup/custom-configs ~/.dotfiles/ 2>/dev/null || true
```

### Hard Reset (Nuclear Option)
```bash
# DANGER: This removes everything!
# Make sure you've backed up important work

# Remove all symlinks
find ~ -maxdepth 2 -type l -exec rm {} \; 2>/dev/null || true

# Remove dotfiles
rm -rf ~/.dotfiles

# Fresh clone and setup
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

### Rollback to Previous State
```bash
# If you have backups from nvim-switch
ls ~/.dotfiles/nvim-backups/

# Restore specific backup
cp -r ~/.dotfiles/nvim-backups/20231201_120000/share ~/.local/share/nvim

# Or use git to rollback dotfiles
cd ~/.dotfiles
git log --oneline -10  # Find good commit
git reset --hard <commit-hash>
./setup.sh
```

## 📞 Getting More Help

### Gather Debug Information
```bash
# Create a debug report
cat > /tmp/debug-report.txt << EOF
=== System Information ===
OS: $(uname -a)
Shell: $SHELL
User: $USER
Home: $HOME

=== Tool Versions ===
Neovim: $(nvim --version | head -1)
Git: $(git --version)
Stow: $(stow --version | head -1)

=== Dotfiles Status ===
Directory: $(ls -ld ~/.dotfiles)
Current config: $(~/.dotfiles/nvim-switch current 2>&1)
AI status: $(~/.dotfiles/ai-keys status 2>&1)

=== Environment ===
PATH: $PATH
OPENAI_API_KEY: $(echo ${OPENAI_API_KEY:+SET} ${OPENAI_API_KEY:-UNSET})
ANTHROPIC_API_KEY: $(echo ${ANTHROPIC_API_KEY:+SET} ${ANTHROPIC_API_KEY:-UNSET})

=== Recent Errors ===
$(tail -20 /tmp/nvim.log 2>/dev/null || echo "No nvim log found")
EOF

cat /tmp/debug-report.txt
```

### Check Online Resources
- **AstroNvim Docs**: https://docs.astronvim.com/
- **Neovim Troubleshooting**: `:help nvim`
- **Stow Manual**: `man stow`
- **Git Documentation**: `git help <command>`

### Community Support
- Search existing issues in the repository
- Check plugin documentation for specific errors
- Use `:checkhealth` in Neovim for detailed diagnostics

---

**Remember**: Most issues can be resolved by carefully reading error messages and following the suggested solutions step by step. When in doubt, start with the basics and work your way up! 🔧