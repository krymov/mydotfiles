# Mark's Dotfiles# Dotfiles



A collection of configuration files and utilities for a productive development environment across macOS and Linux systems.A robust, cross-platform dotfiles configuration for macOS (with Nix) and NixOS. This setup provides a consistent development environment across platforms with enhanced shell completions, cloud CLI tools, and modern development workflows.



## 🚀 Features## 🚀 Enhanced Shell Experience



- **Multiple Neovim Configurations**: Easy switching between AstroNvim, LazyVim, and vanilla configs### Smart Completions & Auto-suggestions

- **Enhanced ZSH Setup**: Custom aliases, functions, and shell improvements with cross-platform compatibility

- **GNU Stow Management**: Organized dotfile management with symlinksYour zsh shell now includes intelligent completions and suggestions:

- **Nix Integration**: Flake-based development environments for different languages

- **One-Command Setup**: Automated installation and configuration**Auto-completion** (Press `Tab`):

- **Commands**: All installed commands with parameter suggestions

## 📦 Quick Setup- **File paths**: Smart file and directory completion with fuzzy matching

- **Git**: Branch names, tags, remotes, and git command options

1. **Clone this repository:**- **Cloud CLIs**: Complete kubectl, gcloud, aws, docker commands

   ```bash- **Custom aliases**: All your custom aliases work with tab completion

   git clone https://github.com/krymov/mydotfiles.git ~/.dotfiles

   cd ~/.dotfiles**Auto-suggestions** (Fuzzy gray text):

   ```- **History-based**: Suggests commands from your history as you type

- **Smart completion**: Context-aware suggestions

2. **Run the setup script:**- **Accept with**: `→` (right arrow) or `Ctrl+F`

   ```bash

   ./setup.sh**History Search**:

   ```- **Fuzzy search**: `Ctrl+R` for interactive fuzzy history search

- **Substring search**: `↑/↓` arrows for smart history navigation

3. **Restart your shell or reload configuration:**- **Pattern matching**: Search with partial commands or arguments

   ```bash

   source ~/.zshrc### 🌤️ Cloud CLI Tools Integration

   ```

#### Kubernetes (kubectl)

That's it! 🎉# Mark's Dotfiles



## 🛠️ DependenciesA collection of configuration files and utilities for a productive development environment across macOS and Linux systems.



The setup script will check for these and guide you through installation:## 🚀 Features



### Essential- **Multiple Neovim Configurations**: Easy switching between AstroNvim, LazyVim, and vanilla configs

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink management- **Enhanced ZSH Setup**: Custom aliases, functions, and shell improvements with cross-platform compatibility

- [Neovim](https://neovim.io/) - Text editor- **GNU Stow Management**: Organized dotfile management with symlinks

- [Git](https://git-scm.com/) - Version control- **Nix Integration**: Flake-based development environments for different languages

- **One-Command Setup**: Automated installation and configuration

### Optional but Recommended

- [Nix](https://nixos.org/) - Package management and development environments## 📦 Quick Setup

- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder

- [eza](https://github.com/eza-community/eza) - Modern ls replacement1. **Clone this repository:**

- [bat](https://github.com/sharkdp/bat) - Better cat with syntax highlighting   ```bash

   git clone https://github.com/krymov/mydotfiles.git ~/.dotfiles

## 🎯 Neovim Configuration Switcher   cd ~/.dotfiles

   ```

Easily switch between different Neovim configurations:

2. **Run the setup script:**

```bash   ```bash

# List available configurations   ./setup.sh

nvim-switch list   ```



# Switch configurations3. **Restart your shell or reload configuration:**

nvim-switch switch astronvim    # Full-featured AstroNvim   ```bash

nvim-switch switch vanilla      # Minimal configuration     source ~/.zshrc

nvim-switch switch lazyvim      # LazyVim-based setup   ```



# Shortcuts (if aliases are loaded)That's it! 🎉

nvs-astro                       # Quick switch to AstroNvim

nvs-vanilla                     # Quick switch to vanilla## 🛠️ Dependencies

nvs-lazy                        # Quick switch to LazyVim

The setup script will check for these and guide you through installation:

# Maintenance

nvim-switch backup              # Backup current plugin state### Essential

nvim-switch clean               # Clean plugin data/cache- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink management

nvim-switch current             # Show current configuration- [Neovim](https://neovim.io/) - Text editor

```- [Git](https://git-scm.com/) - Version control



## 📁 Directory Structure### Optional but Recommended

- [Nix](https://nixos.org/) - Package management and development environments

```- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder

~/.dotfiles/- [eza](https://github.com/eza-community/eza) - Modern ls replacement

├── setup.sh                   # One-command setup script- [bat](https://github.com/sharkdp/bat) - Better cat with syntax highlighting

├── nvim-switch                 # Neovim configuration switcher

├── README.md                   # This file## 🎯 Neovim Configuration Switcher

│

├── stow/                       # Configurations managed by GNU StowEasily switch between different Neovim configurations:

│   ├── nvim/                   # AstroNvim configuration (default)

│   │   └── .config/nvim/```bash

│   ├── zsh/                    # ZSH configuration# List available configurations

│   │   ├── .zshrcnvim-switch list

│   │   └── .zsh/

│   ├── git/                    # Git configuration# Switch configurations

│   ├── tmux/                   # Tmux configurationnvim-switch switch astronvim    # Full-featured AstroNvim

│   └── ssh/                    # SSH configurationnvim-switch switch vanilla      # Minimal configuration

│nvim-switch switch lazyvim      # LazyVim-based setup

├── configs/                    # Alternative configurations

│   ├── nvim-astronvim/         # AstroNvim configuration# Shortcuts (if aliases are loaded)

│   ├── nvim-vanilla/           # Minimal Neovim setupnvs-astro                       # Quick switch to AstroNvim

│   ├── nvim-lazyvim/           # LazyVim configurationnvs-vanilla                     # Quick switch to vanilla

│   └── README.md               # Configuration docsnvs-lazy                        # Quick switch to LazyVim

│

├── flakes/                     # Nix development environments# Maintenance

│   ├── go/                     # Go development environmentnvim-switch backup              # Backup current plugin state

│   ├── python/                 # Python development environmentnvim-switch clean               # Clean plugin data/cache

│   ├── nodejs/                 # Node.js development environmentnvim-switch current             # Show current configuration

│   └── rust/                   # Rust development environment```

│

└── nvim-backups/              # Automatic backups (auto-created)## 📁 Directory Structure

```

```

## 🔧 Development Environments~/.dotfiles/

├── setup.sh                   # One-command setup script

This dotfiles setup includes Nix flakes for isolated development environments:├── nvim-switch                 # Neovim configuration switcher

├── README.md                   # This file

```bash│

# Enter development environment├── stow/                       # Configurations managed by GNU Stow

dev-go          # Go development│   ├── nvim/                   # AstroNvim configuration (default)

dev-python      # Python development  │   │   └── .config/nvim/

dev-nodejs      # Node.js development│   ├── zsh/                    # ZSH configuration

dev-rust        # Rust development│   │   ├── .zshrc

│   │   └── .zsh/

# Or manually│   ├── git/                    # Git configuration

cd ~/.dotfiles/flakes/go && nix develop│   ├── tmux/                   # Tmux configuration

```│   └── ssh/                    # SSH configuration

│

## 🎨 Customization├── configs/                    # Alternative configurations

│   ├── nvim-astronvim/         # AstroNvim configuration

### Adding New Neovim Configurations│   ├── nvim-vanilla/           # Minimal Neovim setup

│   ├── nvim-lazyvim/           # LazyVim configuration

1. Create a new directory in `configs/`:│   └── README.md               # Configuration docs

   ```bash│

   mkdir ~/.dotfiles/configs/nvim-custom├── flakes/                     # Nix development environments

   ```│   ├── go/                     # Go development environment

│   ├── python/                 # Python development environment

2. Add your `init.lua` and configuration files│   ├── nodejs/                 # Node.js development environment

│   └── rust/                   # Rust development environment

3. Update the `nvim-switch` script to include your new config:│

   ```bash└── nvim-backups/              # Automatic backups (auto-created)

   # Edit the CONFIGS array in nvim-switch```

   "custom:$DOTFILES_DIR/configs/nvim-custom"

   ```## 🔧 Development Environments



### Customizing ZSHThis dotfiles setup includes Nix flakes for isolated development environments:



- **Aliases**: Edit `stow/zsh/.zsh/aliases.zsh````bash

- **Functions**: Edit `stow/zsh/.zsh/functions.zsh`# Enter development environment

- **Environment**: Edit `stow/zsh/.zsh/env.zsh`dev-go          # Go development

- **Plugins**: Edit `stow/zsh/.zsh/plugins.zsh`dev-python      # Python development

dev-nodejs      # Node.js development

### Adding New Stow Packagesdev-rust        # Rust development



1. Create a new directory in `stow/`:# Or manually

   ```bashcd ~/.dotfiles/flakes/go && nix develop

   mkdir ~/.dotfiles/stow/newapp```

   ```

## 🎨 Customization

2. Mirror the home directory structure:

   ```bash### Adding New Neovim Configurations

   mkdir -p ~/.dotfiles/stow/newapp/.config/newapp

   ```1. Create a new directory in `configs/`:

   ```bash

3. Add your configuration files   mkdir ~/.dotfiles/configs/nvim-custom

   ```

4. Stow the package:

   ```bash2. Add your `init.lua` and configuration files

   cd ~/.dotfiles && stow -t ~ stow/newapp

   ```3. Update the `nvim-switch` script to include your new config:

   ```bash

## 🖥️ Platform Support   # Edit the CONFIGS array in nvim-switch

   "custom:$DOTFILES_DIR/configs/nvim-custom"

This dotfiles setup is designed to work across:   ```



- **macOS** (with Homebrew)### Customizing ZSH

- **Linux** (Ubuntu, Debian, Arch, Fedora)

- **NixOS**- **Aliases**: Edit `stow/zsh/.zsh/aliases.zsh`

- **Functions**: Edit `stow/zsh/.zsh/functions.zsh`

Platform-specific configurations are handled automatically in the ZSH setup.- **Environment**: Edit `stow/zsh/.zsh/env.zsh`

- **Plugins**: Edit `stow/zsh/.zsh/plugins.zsh`

## 🔄 Keeping Updated

### Adding New Stow Packages

```bash

# Update dotfiles repository1. Create a new directory in `stow/`:

cd ~/.dotfiles && git pull   ```bash

   mkdir ~/.dotfiles/stow/newapp

# Update Nix packages (if using Nix)   ```

dotup-pkg

2. Mirror the home directory structure:

# Update all (dotfiles + packages)   ```bash

dotup-all   mkdir -p ~/.dotfiles/stow/newapp/.config/newapp

```   ```



## 🆘 Troubleshooting3. Add your configuration files



### Neovim Issues4. Stow the package:

   ```bash

```bash   cd ~/.dotfiles && stow -t ~ stow/newapp

# Check current configuration   ```

nvim-switch current

## 🖥️ Platform Support

# Clean plugin data if switching between configs

nvim-switch cleanThis dotfiles setup is designed to work across:



# Backup before making changes- **macOS** (with Homebrew)

nvim-switch backup- **Linux** (Ubuntu, Debian, Arch, Fedora)

```- **NixOS**



### Stow IssuesPlatform-specific configurations are handled automatically in the ZSH setup.



```bash## 🔄 Keeping Updated

# Check for conflicts

stow -t ~ -n stow/zsh  # Dry run```bash

# Update dotfiles repository

# Force restow if neededcd ~/.dotfiles && git pull

stow -t ~ -R stow/zsh  # Restow (delete and recreate)

```# Update Nix packages (if using Nix)

dotup-pkg

### Shell Issues

# Update all (dotfiles + packages)

```bashdotup-all

# Reload configuration```

source ~/.zshrc

## 🆘 Troubleshooting

# Check if dotfiles are in PATH

echo $PATH | grep dotfiles### Neovim Issues

```

```bash

## 🤝 Contributing# Check current configuration

nvim-switch current

Feel free to:

- Fork this repository# Clean plugin data if switching between configs

- Adapt configurations for your needsnvim-switch clean

- Submit improvements via pull requests

- Report issues or suggestions# Backup before making changes

nvim-switch backup

## 📄 License```



This project is open source and available under the [MIT License](LICENSE).### Stow Issues



---```bash

# Check for conflicts

**Happy coding!** 🎉stow -t ~ -n stow/zsh  # Dry run



> These dotfiles are designed to create a consistent, productive development environment across different machines and platforms. The modular structure makes it easy to pick and choose components that work for your workflow.# Force restow if needed
stow -t ~ -R stow/zsh  # Restow (delete and recreate)
```

### Shell Issues

```bash
# Reload configuration
source ~/.zshrc

# Check if dotfiles are in PATH
echo $PATH | grep dotfiles
```

## 🤝 Contributing

Feel free to:
- Fork this repository
- Adapt configurations for your needs
- Submit improvements via pull requests
- Report issues or suggestions

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy coding!** 🎉

> These dotfiles are designed to create a consistent, productive development environment across different machines and platforms. The modular structure makes it easy to pick and choose components that work for your workflow.

#### Google Cloud Platform (gcloud)
```bash
# Quick aliases
gc projects list             # gcloud projects list
gcp my-project-id           # gcloud config set project my-project-id
gce instances list          # gcloud compute instances list
gcei                        # gcloud compute instances (shortcut)

# Fuzzy-finder functions
gcproj                      # Fuzzy find and switch GCP projects

# Tab completion for all gcloud commands
gc compute instances <TAB>   # Shows available gcloud compute instance commands
gcp <TAB>                   # Shows available project IDs
```

#### AWS CLI
```bash
# Quick aliases (when AWS CLI installed)
awsp                        # Export AWS_PROFILE
awspl                       # List AWS profiles
awssl                       # AWS S3 list

# Fuzzy-finder functions
awsprof                     # Fuzzy find and switch AWS profiles

# Tab completion for AWS commands
aws s3 <TAB>                # Shows S3 command options
aws ec2 <TAB>               # Shows EC2 command options
```

#### Docker
```bash
# Quick aliases
d ps                        # docker ps
dps                         # docker ps
di                          # docker images
dlog container-name         # docker logs container-name

# Fuzzy-finder functions
dsh                         # Fuzzy find and shell into containers
dlogs                       # Fuzzy find containers and view logs

# Tab completion
d exec <TAB>                # Shows running containers
docker run <TAB>            # Shows available images
```

### 📁 File & Directory Operations

**Enhanced file listing**:
```bash
ll                          # Detailed list with git status (using eza)
la                          # List all files including hidden
lt                          # Tree view of directory structure
```

**Smart navigation**:
```bash
cd <TAB>                    # Shows directories only
..                          # Go up one directory
...                         # Go up two directories
-                          # Go to previous directory (cd -)
```

**File operations**:
```bash
extract file.tar.gz         # Smart extraction (auto-detects format)
mkcd new-project            # Create and enter directory
ff pattern                  # Find files by name
fif "search text"           # Find in files (ripgrep)
```

### 🔍 Fuzzy Finding (FZF Integration)

**File search**:
```bash
Ctrl+T                      # Fuzzy find files in current directory
Alt+C                       # Fuzzy find and cd to directory
```

**Command history**:
```bash
Ctrl+R                      # Interactive fuzzy history search
```

**Cloud resource selection**:
```bash
kctx                        # Kubernetes contexts
knsf                        # Kubernetes namespaces
klogs                       # Pod logs
kexec                       # Exec into pods
gcproj                      # GCP projects
awsprof                     # AWS profiles
dsh                         # Docker containers
dlogs                       # Docker logs
```

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

## 💡 Usage Examples & Workflows

### Daily Development Workflow

**Starting a new project**:
```bash
# Create and setup Go project
dev-go my-api-server
cd my-api-server
# direnv automatically activates Go environment
go mod init my-api-server
nvim main.go              # Neovim with Go LSP ready

# Start tmux session for project
tn my-api-server          # Creates/attaches tmux session
```

**Working with Kubernetes**:
```bash
# Switch context with fuzzy finder
kctx                      # Select from list of contexts
knsf                      # Select namespace

# Quick pod operations
kgp                       # List pods
klogs                     # Fuzzy select pod and view logs
kexec                     # Fuzzy select pod and shell into it

# Traditional commands work too
k get deployment -o yaml | bat    # Syntax highlighted output
k describe pod webapp-<TAB>       # Tab completion for pod names
```

**Cloud operations**:
```bash
# Switch GCP project
gcproj                    # Fuzzy find projects
gc compute instances list # List VMs with tab completion

# AWS operations (when AWS CLI installed)
awsprof                   # Switch profiles
aws s3 ls                 # With full tab completion

# Docker workflow
d ps                      # List containers
dsh                       # Fuzzy select and shell into container
dlogs                     # Fuzzy select and view logs
```

**File and search operations**:
```bash
# Enhanced file operations
ll                        # Beautiful file listing with git status
cat config.yaml           # Syntax highlighted with bat
extract archive.tar.gz    # Smart extraction

# Powerful search
ff "*.go"                 # Find Go files
fif "TODO"                # Find "TODO" in all files
Ctrl+R                    # Search command history
Ctrl+T                    # Find files interactively
```

### Git Workflow

**Enhanced git aliases**:
```bash
g st                      # git status
ga .                      # git add .
gc "fix: update config"   # git commit
gp                        # git push
gl                        # git pull
gd                        # git diff
glog                      # Pretty git log with graph

# Git operations with completion
g checkout <TAB>          # Shows branch names
g merge <TAB>             # Shows available branches
```

**Using lazygit**:
```bash
lg                        # Opens lazygit for visual git operations
```

### Terminal Management

**tmux sessions**:
```bash
tn work                   # Create/attach to "work" session
tn                        # Create session named after current directory
t                         # Start tmux
ta                        # Attach to last session
tl                        # List sessions
```

**Multiple terminals**:
```bash
# In tmux:
C-b |                     # Split vertically
C-b -                     # Split horizontally
C-b h/j/k/l              # Navigate panes vim-style
```

### Development Environment Examples

**Python project**:
```bash
dev-python my-web-app
cd my-web-app
# Poetry and Python LSP available
poetry init
poetry add fastapi
nvim app.py               # Python LSP ready
```

**Node.js project**:
```bash
dev-nodejs my-frontend
cd my-frontend
# Node.js, npm, TypeScript ready
npm init
npm install react
nvim src/App.tsx          # TypeScript LSP ready
```

**Rust project**:
```bash
dev-rust my-cli-tool
cd my-cli-tool
# Rust toolchain and rust-analyzer ready
cargo init
nvim src/main.rs          # Rust LSP ready
```

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

## Useful Aliases & Functions

### Core System Aliases
- `ll`, `la`, `lt` - Enhanced ls with eza (detailed, all files, tree view)
- `cat` - bat with syntax highlighting
- `..`, `...`, `....` - Quick directory navigation
- `o` - open (macOS) / xdg-open (Linux)

### Git Aliases
- `g` - git shortcut
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gl` - git pull
- `gd` - git diff
- `gco` - git checkout
- `gb` - git branch
- `glog` - git log with graph
- `lg` - lazygit

### Development Environment Aliases
- `dev-go`, `dev-python`, `dev-nodejs`, `dev-rust` - Quick development environment setup

### Kubernetes Aliases
- `k` - kubectl
- `kgp` - kubectl get pods
- `kgs` - kubectl get services
- `kgd` - kubectl get deployments
- `kgn` - kubectl get nodes
- `kga` - kubectl get all
- `kdp` - kubectl describe pod
- `kds` - kubectl describe service
- `kdd` - kubectl describe deployment
- `kaf` - kubectl apply -f
- `kdf` - kubectl delete -f
- `keti` - kubectl exec -ti
- `kccc` - kubectl config current-context
- `kcuc` - kubectl config use-context
- `kns` - kubectl config set-context --current --namespace

### Google Cloud Aliases
- `gc` - gcloud
- `gce` - gcloud compute
- `gcei` - gcloud compute instances
- `gcel` - gcloud compute instances list
- `gces` - gcloud compute instances start
- `gcest` - gcloud compute instances stop
- `gcp` - gcloud config set project
- `gcpl` - gcloud projects list
- `gcsl` - gcloud config list

### AWS Aliases (when AWS CLI installed)
- `awsp` - export AWS_PROFILE
- `awspl` - aws configure list-profiles
- `awssl` - aws s3 ls
- `awsec2` - aws ec2 describe-instances

### Docker Aliases
- `d` - docker
- `dc` - docker-compose
- `dps` - docker ps
- `dpa` - docker ps -a
- `di` - docker images
- `drmf` - docker system prune -f
- `dlog` - docker logs
- `dexec` - docker exec -it
- `drun` - docker run
- `dstop` - docker stop
- `dstart` - docker start

### tmux Aliases
- `t` - tmux
- `ta` - tmux attach
- `tl` - tmux list-sessions

## Functions

### Core Functions
- `mkcd <dir>` - Create and enter directory
- `extract <file>` - Extract various archive formats
- `ff <pattern>` - Find files by name
- `fif <pattern>` - Find in files
- `cdgit` - Change to git root
- `tn [name]` - Create/attach tmux session
- `weather [location]` - Get weather info
- `backup <file>` - Create timestamped backup
- `serve [port]` - Quick HTTP server

### Cloud & DevOps Functions
- `kctx` - Fuzzy find and switch kubectl contexts
- `knsf` - Fuzzy find and switch kubernetes namespaces
- `klogs` - Fuzzy find pods and view logs
- `kexec` - Fuzzy find pods and exec into them
- `gcproj` - Fuzzy find and switch GCP projects
- `awsprof` - Fuzzy find and switch AWS profiles
- `dsh` - Fuzzy find and shell into docker containers
- `dlogs` - Fuzzy find containers and view logs

### Usage Examples
```bash
# Kubernetes workflow
kctx                        # Select context interactively
knsf                        # Select namespace interactively
klogs                       # Select pod and view logs
kexec                       # Select pod and shell into it

# Cloud project switching
gcproj                      # Switch GCP projects with fuzzy finder
awsprof                     # Switch AWS profiles with fuzzy finder

# Docker operations
dsh                         # Shell into container with fuzzy finder
dlogs                       # View container logs with fuzzy finder

# File operations
mkcd new-project            # Create and enter directory
extract archive.tar.gz     # Smart archive extraction
ff "*.py"                   # Find Python files
fif "TODO"                  # Find "TODO" in all files

# tmux session management
tn myproject                # Create/attach to "myproject" session
tn                          # Create session named after current dir
```

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

### Shell & Completions

**zsh not loading correctly**:
```bash
# Check if zsh is default shell
echo $SHELL

# Source configuration manually
source ~/.zshrc

# Check if completions are loaded
autoload -U compinit && compinit
```

**Completions not working**:
```bash
# Rebuild completion cache
rm ~/.zcompdump* && compinit

# Check if cloud CLI tools are installed
which kubectl gcloud aws docker

# Test specific completions
kubectl completion zsh | head -5
gcloud completion zsh | head -5
```

**Auto-suggestions not appearing**:
```bash
# Check if plugin is loaded
echo $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE

# Reload plugins
source ~/.zsh/plugins.zsh

# Check plugin installation
ls ~/.zsh/plugins/
```

**FZF not working**:
```bash
# Check if fzf is installed
which fzf

# Test fzf directly
fzf --version

# Check if keybindings are loaded
bind | grep fzf  # or: bindkey | grep fzf
```

### Cloud CLI Issues

**kubectl completions not working**:
```bash
# Ensure kubectl is in PATH
which kubectl

# Test kubectl completion
kubectl completion zsh > /tmp/kubectl_completion
source /tmp/kubectl_completion

# Check if alias completion is working
compdef k=kubectl
```

**gcloud completions not working**:
```bash
# Check gcloud installation
gcloud version

# Find gcloud completion file
find /opt/homebrew /usr/local /nix -name "completion.zsh.inc" 2>/dev/null | grep gcloud

# Source manually if found
source "/path/to/gcloud/completion.zsh.inc"
```

**Cloud functions not working**:
```bash
# Check if fzf is available for cloud functions
kctx  # Should show error message if fzf not found

# Install missing tools
# macOS: brew install fzf
# NixOS: Add fzf to packages.nix
```

### Stow conflicts
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
