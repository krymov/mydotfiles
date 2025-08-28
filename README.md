# Dotfiles

A robust, cross-platform dotfiles configuration for macOS (with Nix) and NixOS. This setup provides a consistent development environment across platforms using standard tools and vanilla configurations.

## Features

- **Cross-platform compatibility**: Works on macOS with Nix and NixOS
- **Standard configurations**: Uses vanilla setups without heavy customizations
- **Symlink management**: Uses GNU Stow for clean dotfile management
- **Modern tools**: Includes fzf, ripgrep, bat, eza, and other CLI enhancements
- **tmux everywhere**: Consistent terminal multiplexing across platforms
- **AstroNvim**: Powerful Neovim configuration with LSP support
- **Development environments**: Language-specific Nix flakes with direnv integration
- **Declarative packages**: Nix-based package management for reproducible setups

## Included Configurations

- **zsh**: Enhanced shell with modular configuration
- **tmux**: Terminal multiplexer with vim-like bindings
- **git**: Comprehensive git configuration with useful aliases
- **nvim**: AstroNvim setup with language servers and formatters
- **kitty**: Modern terminal emulator (Linux/NixOS)
- **Development environments**: Go, Python, Node.js, and Rust flakes with direnv

## Quick Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the bootstrap script**:
   ```bash
   ./bootstrap.sh
   ```

3. **Start a new shell and enjoy**:
   ```bash
   # Open a new terminal or source the config
   exec zsh
   
   # Start tmux
   tmux
   
   # Open neovim (AstroNvim will auto-install plugins)
   nvim
   ```

## Development Environments

This dotfiles setup includes comprehensive development environments using Nix flakes and direnv:

### Quick Start with Development Environments

```bash
# Set up a Go project
dev-go myapp

# Set up a Python project  
dev-python my-web-app

# Set up a Node.js project
dev-nodejs my-frontend

# Set up a Rust project
dev-rust my-rust-app
```

### Available Environments

- **Go**: Go toolchain, gopls LSP, golangci-lint, delve debugger, database tools
- **Python**: Python 3.11, poetry, python-lsp-server, black, pytest, common packages
- **Node.js**: Node.js 20, npm/yarn/pnpm, TypeScript, ESLint, Prettier, Jest
- **Rust**: Latest stable Rust, rust-analyzer LSP, cargo tools

Each environment automatically activates when you enter the project directory and provides:
- Complete language toolchain
- Language servers for IDE integration  
- Linting and formatting tools
- Testing frameworks
- Common development dependencies

For detailed documentation, see `flakes/README.md`.

## What the Bootstrap Script Does

1. **Installs packages via Nix**:
   - Core tools: git, tmux, zsh, neovim
   - CLI enhancements: fzf, ripgrep, fd, eza, bat
   - Development tools: direnv, lazygit

2. **Sets up zsh as default shell**

3. **Creates symlinks** using GNU Stow for:
   - Shell configuration (zsh)
   - Terminal multiplexer (tmux)
   - Git configuration
   - Neovim configuration
   - Kitty configuration (Linux only)

4. **Installs AstroNvim** if not present

5. **Backs up existing configurations** with `.backup` extension

## Manual Configuration

After running the bootstrap script, you may want to configure:

1. **Git user information**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```

2. **SSH Key for GitHub** (if not already set up):
   ```bash
   # Generate SSH key
   ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_ed25519
   
   # Add to SSH agent
   ssh-add ~/.ssh/id_ed25519
   
   # Add to GitHub (requires GitHub CLI)
   gh ssh-key add ~/.ssh/id_ed25519.pub --title "YourMachine-$(date +%Y%m%d)"
   
   # Test connection
   ssh -T git@github.com
   ```

3. **Create local configurations** (not tracked by git):
   - `~/.zshrc.local` - Local zsh configuration
   - `~/.gitconfig.local` - Local git configuration
   - `~/.zsh/functions.local.zsh` - Local functions

## Directory Structure

```
.dotfiles/
├── bootstrap.sh              # Main setup script
├── update.sh                 # Granular update system
├── dev-env.sh                # Development environment setup
├── packages.nix              # Declarative package definitions
├── shell.nix                 # Development shell environment
├── flakes/                   # Language-specific development environments
│   ├── README.md             # Development environment documentation
│   ├── go/                   # Go development environment
│   ├── python/               # Python development environment
│   ├── nodejs/               # Node.js development environment
│   └── rust/                 # Rust development environment
├── stow/                     # Stow packages
│   ├── git/                  # Git configuration
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── kitty/                # Kitty terminal config (Linux)
│   │   └── .config/kitty/kitty.conf
│   ├── nvim/                 # Neovim configuration
│   │   └── .config/nvim/
│   ├── tmux/                 # tmux configuration
│   │   └── .tmux.conf
│   └── zsh/                  # zsh configuration
│       ├── .zshrc
│       ├── .ripgreprc
│       └── .zsh/
│           ├── aliases.zsh
│           ├── env.zsh
│           ├── functions.zsh
│           ├── plugins.zsh
│           └── completions.zsh
└── README.md                 # This file
```

## Platform-Specific Features

### macOS
- Uses pbcopy/pbpaste for clipboard integration
- Homebrew integration (if available)
- macOS-specific aliases and functions

### NixOS/Linux
- xclip for clipboard integration
- Kitty terminal configuration
- NixOS-specific commands and aliases

## Key Bindings (Default/Standard)

### tmux (keeping C-b prefix)
- `C-b |` - Split vertically
- `C-b -` - Split horizontally
- `C-b h/j/k/l` - Navigate panes (vim-like)
- `C-b r` - Reload config

### zsh
- `Ctrl+R` - History search with fzf
- `Ctrl+T` - File search with fzf
- `Alt+C` - Directory search with fzf

### Neovim (AstroNvim)
- Uses standard AstroNvim keybindings
- See [AstroNvim documentation](https://docs.astronvim.com/) for details

## Useful Aliases

- `ll`, `la` - Enhanced ls with eza
- `cat` - bat with syntax highlighting
- `g` - git shortcut
- `lg` - lazygit
- `t` - tmux
- `o` - open (macOS) / xdg-open (Linux)
- `dev-go`, `dev-python`, `dev-nodejs`, `dev-rust` - Quick development environment setup

## Functions

- `mkcd <dir>` - Create and enter directory
- `extract <file>` - Extract various archive formats
- `ff <pattern>` - Find files by name
- `fif <pattern>` - Find in files
- `cdgit` - Change to git root
- `tn [name]` - Create/attach tmux session
- `weather [location]` - Get weather info
- `backup <file>` - Create timestamped backup
- `serve [port]` - Quick HTTP server

## Updating

You have several options for updating your dotfiles and packages:

### Quick Updates

```bash
# Update everything (recommended)
./update.sh --all

# Update only packages
./update.sh --packages

# Update only dotfiles from git
./update.sh --dotfiles

# Update only Neovim/AstroNvim
./update.sh --nvim

# Interactive mode (prompts you to choose)
./update.sh
```

### When to Use Each Update Method

**Use `./update.sh --packages`** when you want to:
- Update Nix packages to latest versions
- Update Homebrew packages (macOS)
- Quick package updates without touching configs

**Use `./update.sh --dotfiles`** when you want to:
- Pull latest dotfiles changes from git
- Re-apply stow configurations
- Update your dotfiles without changing packages

**Use `./update.sh --nvim`** when you want to:
- Update AstroNvim core
- Update your custom nvim configuration
- Force plugin updates

**Use `./update.sh --all`** when you want to:
- Complete system update
- After major changes to the dotfiles repo
- Monthly maintenance

### Full Reinstall

Only use the bootstrap script for:
- **Initial setup** on a new machine
- **Complete reinstall** when something is broken
- **Major configuration changes** that require re-symlinking

```bash
# Full reinstall (backs up existing configs)
./bootstrap.sh
```

### Package-Specific Updates

```bash
# Nix packages only
nix-env -u

# Homebrew (macOS) only
brew update && brew upgrade && brew cleanup

# AstroNvim plugins only
nvim +AstroUpdate

# NixOS system (NixOS only)
sudo nixos-rebuild switch --upgrade
```

## Quick Reference

### Daily Usage
```bash
# Update packages
./update.sh -p

# Update dotfiles from git
./update.sh -d

# Update everything
./update.sh -a
```

### Key Files
```bash
# Edit shell config
$EDITOR ~/.zshrc
$EDITOR ~/.zsh/aliases.zsh

# Edit tmux config
$EDITOR ~/.tmux.conf

# Edit git config
$EDITOR ~/.gitconfig

# Edit nvim config
$EDITOR ~/.config/nvim/lua/user/init.lua
```

### Useful Commands
```bash
# Reload shell
exec zsh

# Reload tmux config
tmux source-file ~/.tmux.conf

# Update nvim plugins
nvim +AstroUpdate

# Create new tmux session
tn project-name

# Quick git status
g st

# Enhanced file listing
ll
```

## Customization

### Adding new configurations
1. Create a new directory in `stow/`
2. Add your configuration files
3. Update `bootstrap.sh` to include the new module

### Local customizations
Create these files for local, non-tracked configurations:
- `~/.zshrc.local`
- `~/.gitconfig.local`
- `~/.zsh/functions.local.zsh`

## Troubleshooting

### zsh not loading correctly
```bash
# Check if zsh is default shell
echo $SHELL

# Source configuration manually
source ~/.zshrc
```

### Stow conflicts
```bash
# Remove existing files/symlinks before stowing
rm ~/.zshrc ~/.tmux.conf ~/.gitconfig

# Re-run bootstrap
./bootstrap.sh
```

### AstroNvim issues
```bash
# Clean AstroNvim installation
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# Re-run bootstrap
./bootstrap.sh
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on both macOS and Linux if possible
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.