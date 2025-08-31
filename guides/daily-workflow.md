# ⚡ Daily Workflow Guide

Essential commands, shortcuts, and workflows for maximum productivity with your dotfiles setup.

## 🌅 Starting Your Day

### 1. Launch Your Environment
```bash
# Start in your project directory
cd ~/projects/my-project

# Launch Neovim with AI assistance
nvim

# Or start with tmux for multiple sessions
tmux new-session -s work
```

### 2. Quick Environment Check
```bash
# Check AI providers are working
./ai-keys test

# Verify current Neovim config
nvim-switch current

# Check Git status
gs  # alias for 'git status'
```

## 🎯 Essential Aliases & Commands

### Git Shortcuts (from `stow/git/`)
```bash
# Status and basic operations
gs          # git status
ga          # git add
gaa         # git add --all
gc          # git commit
gca         # git commit --amend
gp          # git push
gl          # git pull

# Branching
gb          # git branch
gco         # git checkout
gcb         # git checkout -b <branch>
gm          # git merge

# Viewing changes
gd          # git diff
gds         # git diff --staged
glog        # git log --oneline --graph

# Advanced
gstash      # git stash
gpop        # git stash pop
greset      # git reset --hard HEAD
```

### Shell Productivity (from `stow/zsh/`)
```bash
# Navigation
..          # cd ..
...         # cd ../..
....        # cd ../../..

# Directory listing
ll          # ls -alF
la          # ls -A
l           # ls -CF

# Quick edits
zshrc       # edit ~/.zshrc
nvimrc      # edit nvim config
aliases     # edit aliases file

# System info
ports       # netstat -tuln
psgrep      # ps aux | grep
```

### Neovim Management
```bash
# Switch configurations
nvim-switch list                    # Show available configs
nvim-switch switch astronvim        # Switch to AstroNvim
nvim-switch switch lazyvim          # Switch to LazyVim
nvim-switch current                 # Show current config

# Maintenance
nvim-switch backup                  # Backup current data
nvim-switch clean                   # Clean data/cache
nvim-switch restore                 # Show restore options
```

### AI Assistance
```bash
# Key management
./ai-keys setup                     # Initial setup
./ai-keys add anthropic             # Add provider
./ai-keys list                      # Show configured
./ai-keys test                      # Test all providers
./ai-keys status                    # Show Neovim info
```

## 🚀 Neovim Workflows

### AI-Powered Coding
```vim
" Core AI actions
<leader>aa     " AI action palette (start here!)
<leader>ac     " Toggle AI chat
<leader>ai     " Inline AI assistance

" Specialized agents
<leader>ar     " Refactor selected code
<leader>at     " Generate tests
<leader>av     " Code review
<leader>ad     " Generate documentation
<leader>aD     " Debug assistance
<leader>aP     " Architecture review

" Quick actions (visual mode)
<leader>ae     " Explain code
<leader>af     " Fix code
<leader>ao     " Optimize code
```

### AstroNvim Essentials
```vim
" File navigation
<leader>ff     " Find files
<leader>fw     " Find word
<leader>fb     " File browser
<leader>fo     " Recent files

" Code navigation
gd             " Go to definition
gr             " Go to references
K              " Show documentation
<leader>ca     " Code actions

" Buffer management
<leader>c      " Close buffer
<leader>C      " Force close
]b             " Next buffer
[b             " Previous buffer

" Terminal
<leader>t      " Toggle terminal
<C-\>          " Terminal escape
```

## 📊 Project Workflows

### Starting a New Project
```bash
# 1. Create and navigate to project
mkdir my-new-project && cd my-new-project

# 2. Initialize Git
git init
git add .
git commit -m "Initial commit"

# 3. Set up development environment (choose one)
nix develop ~/.dotfiles/flakes/python    # Python
nix develop ~/.dotfiles/flakes/go        # Go
nix develop ~/.dotfiles/flakes/nodejs    # Node.js
nix develop ~/.dotfiles/flakes/rust      # Rust

# 4. Open in Neovim with AI
nvim .
```

### Daily Development Cycle
```bash
# 1. Update and sync
gl                              # Pull latest changes
nvim +Lazy sync +qa            # Update Neovim plugins

# 2. Work on features
nvim src/main.py               # Edit files
# Use <leader>ar to refactor code
# Use <leader>at to generate tests
# Use <leader>av for code review

# 3. Commit and push
gaa                            # Stage all changes
gc "Add new feature"           # Commit with message
gp                             # Push to remote

# 4. Test and verify
./ai-keys test                 # Ensure AI is working
```

### Code Review Workflow
```bash
# 1. Stage your changes
gaa

# 2. Open in Neovim and review
nvim src/modified-file.py

# 3. Select code and use AI review
# Visual select code → <leader>av

# 4. Address feedback and commit
gc "Address review feedback"
gp
```

## 🔧 Maintenance Routines

### Weekly Maintenance
```bash
# Update system packages
brew update && brew upgrade    # macOS
apt update && apt upgrade      # Ubuntu

# Update dotfiles
cd ~/.dotfiles
gl                            # Pull latest changes
./setup.sh                    # Re-run setup if needed

# Update Neovim plugins
nvim +Lazy sync +qa

# Clean up
nvim-switch clean             # Clean Neovim cache
docker system prune -f        # Clean Docker (if used)
```

### Monthly Deep Clean
```bash
# Backup current state
nvim-switch backup

# Update all AI providers
./ai-keys test                # Verify all working

# Update Nix (if using)
nix flake update ~/.dotfiles/flakes/python
nix flake update ~/.dotfiles/flakes/go
# ... update other flakes

# Review and clean old branches
git branch -d $(git branch --merged | grep -v main)
```

## 🎨 Customization Tips

### Adding Your Own Aliases
```bash
# Edit your aliases file
nvim ~/.dotfiles/stow/zsh/.zsh/aliases.zsh

# Add custom aliases
alias myproject="cd ~/projects/my-main-project"
alias serve="python -m http.server 8000"
alias logs="tail -f /var/log/app.log"

# Reload shell
source ~/.zshrc
```

### Custom AI Prompts
```vim
" In Neovim, create custom prompts in:
" ~/.dotfiles/stow/nvim/.config/nvim/lua/plugins/codecompanion.lua

" Example: Add a "Security" agent
["Security"] = {
  strategy = "chat",
  description = "Security code review",
  -- ... (see AI guide for full example)
}
```

### Project-Specific Configurations
```bash
# Create .nvmrc for Node.js version
echo "18.17.0" > .nvmrc

# Create .python-version for Python
echo "3.11.0" > .python-version

# Create local Git hooks
mkdir .git/hooks
cp ~/.dotfiles/templates/pre-commit .git/hooks/
```

## ⚡ Power User Tips

### Tmux + Neovim + AI Workflow
```bash
# 1. Start tmux session
tmux new-session -s project

# 2. Split panes
Ctrl+b %        # Vertical split
Ctrl+b "        # Horizontal split

# 3. Navigate panes
Ctrl+b ←→↑↓     # Move between panes

# 4. In one pane: Neovim with AI
nvim .
# Use AI agents as needed

# 5. In another pane: Terminal tasks
git status
npm test
./ai-keys test
```

### Keyboard Shortcuts Chain
```bash
# Example: Quick commit with AI review
1. gaa                    # Stage changes
2. nvim -c "Git"         # Open Git in Neovim
3. Select diff → <leader>av   # AI review
4. :wq                   # Close review
5. gc "Reviewed changes" # Commit
6. gp                    # Push
```

### Multi-Project Management
```bash
# Use tmux sessions for different projects
tmux new-session -s frontend -d
tmux new-session -s backend -d
tmux new-session -s devops -d

# Quick switch between projects
tmux attach-session -t frontend
tmux attach-session -t backend

# List all sessions
tmux list-sessions
```

## 📱 Mobile/Remote Development

### SSH Configuration (from `stow/ssh/`)
```bash
# Connect to remote server
ssh myserver

# Use local Neovim config remotely
rsync -av ~/.dotfiles/ user@server:~/.dotfiles/
ssh user@server "cd ~/.dotfiles && ./setup.sh"
```

### Sync Settings Across Machines
```bash
# On machine 1: Commit changes
cd ~/.dotfiles
gaa && gc "Update configs" && gp

# On machine 2: Pull changes
cd ~/.dotfiles
gl && ./setup.sh
```

## 🚨 Emergency Recovery

### Quick Fixes
```bash
# Neovim won't start
nvim-switch clean
nvim-switch switch astronvim

# Shell broken
/bin/zsh
source ~/.zshrc

# Git issues
git status --porcelain
git reset --hard HEAD

# AI not working
./ai-keys test
source ~/.config/ai-keys.env
```

### Nuclear Option (Full Reset)
```bash
# Backup important work first!
cp -r ~/.dotfiles/custom-configs ~/backup/

# Fresh start
rm -rf ~/.dotfiles
git clone <your-repo> ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

---

**Pro Tip**: Keep this guide bookmarked and refer to it until these commands become muscle memory. The key to productivity is building consistent daily habits with these tools! 🚀