# 🚀 Mark's Dotfiles

> Modern, declarative development environment with Home Manager and Nix

A streamlined dotfiles setup that provides a consistent, productive development environment across macOS and Linux using Home Manager for declarative package management.

## ✨ What Makes This Special

🏗️ **Declarative Configuration** - All packages managed via Home Manager and Nix
⚡ **One-Command Setup** - Automated installation with `./bootstrap.sh`
🛠️ **Development Environments** - Isolated Nix flakes for Go, Python, Node.js, Rust
🎯 **Multiple Neovim Configs** - Easy switching between different editor setups
🔄 **Cross-Platform** - Works seamlessly on macOS and Linux
🧹 **Clean & Minimal** - No bloat, just essential productivity tools

## 🚀 Quick Setup

1. **Install Nix** (if not already installed):
   ```bash
   curl -L https://nixos.org/nix/install | sh
   source ~/.nix-profile/etc/profile.d/nix.sh
   ```

2. **Clone and setup**:
   ```bash
   git clone https://github.com/krymov/mydotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ./bootstrap.sh
   ```

3. **Restart your shell**:
   ```bash
   exec zsh
   ```

That's it! 🎉

# Select code → <leader>ar (refactor)- **Git**: Branch names, tags, remotes, and git command options

# Select code → <leader>at (generate tests)

# Select code → <leader>av (code review)1. **Clone this repository:**- **Cloud CLIs**: Complete kubectl, gcloud, aws, docker commands

```

   ```bash- **Custom aliases**: All your custom aliases work with tab completion

## 📦 What You Get

   git clone https://github.com/krymov/mydotfiles.git ~/.dotfiles

### 🤖 AI Coding Agents

Six specialized AI assistants for different coding tasks:   cd ~/.dotfiles**Auto-suggestions** (Fuzzy gray text):



| Agent | Keybinding | Purpose |   ```- **History-based**: Suggests commands from your history as you type

|-------|------------|---------|

| **Refactor** | `<leader>ar` | Improve code structure while preserving behavior |- **Smart completion**: Context-aware suggestions

| **TestGen** | `<leader>at` | Generate comprehensive unit tests |

| **Reviewer** | `<leader>av` | Thorough code review and security analysis |2. **Run the setup script:**- **Accept with**: `→` (right arrow) or `Ctrl+F`

| **Docs** | `<leader>ad` | Generate documentation and comments |

| **Debug** | `<leader>aD` | Systematic debugging assistance |   ```bash

| **Architect** | `<leader>aP` | High-level design and architecture review |

   ./setup.sh**History Search**:

### 🎯 Neovim Configurations

Switch between different setups based on your needs:   ```- **Fuzzy search**: `Ctrl+R` for interactive fuzzy history search



```bash- **Substring search**: `↑/↓` arrows for smart history navigation

nvim-switch switch astronvim    # Full IDE with AI (recommended)

nvim-switch switch lazyvim      # Fast, modern configuration  3. **Restart your shell or reload configuration:**- **Pattern matching**: Search with partial commands or arguments

nvim-switch switch vanilla      # Minimal, learning-friendly

```   ```bash



### ⚡ Enhanced Shell Experience   source ~/.zshrc### 🌤️ Cloud CLI Tools Integration

Your Zsh shell becomes a productivity powerhouse:

   ```

```bash

# Smart Git workflow#### Kubernetes (kubectl)

gs          # git status

gaa         # git add --all  That's it! 🎉# Mark's Dotfiles

gc          # git commit

gp          # git push

glog        # beautiful git log

## 🛠️ DependenciesA collection of configuration files and utilities for a productive development environment across macOS and Linux systems.

# Enhanced file operations

ll          # detailed listing with git status

..          # cd ..

...         # cd ../..The setup script will check for these and guide you through installation:## 🚀 Features

mkcd name   # create and enter directory



# Fuzzy finding everything

Ctrl+R      # search command history### Essential- **Multiple Neovim Configurations**: Easy switching between AstroNvim, LazyVim, and vanilla configs

Ctrl+T      # find files

ff pattern  # find files by name- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink management- **Enhanced ZSH Setup**: Custom aliases, functions, and shell improvements with cross-platform compatibility

fif text    # find text in files

```- [Neovim](https://neovim.io/) - Text editor- **GNU Stow Management**: Organized dotfile management with symlinks



### 🛠️ Development Environments- [Git](https://git-scm.com/) - Version control- **Nix Integration**: Flake-based development environments for different languages

Isolated, reproducible environments using Nix:

- **One-Command Setup**: Automated installation and configuration

```bash

# Quick project setup### Optional but Recommended

dev-go myapi        # Go environment with LSP

dev-python webapp   # Python with poetry and linting- [Nix](https://nixos.org/) - Package management and development environments

dev-nodejs frontend # Node.js with TypeScript- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder

dev-rust cli-tool   # Rust with analyzer- [eza](https://github.com/eza-community/eza) - Modern ls replacement

```- [bat](https://github.com/sharkdp/bat) - Better cat with syntax highlighting



## 🚀 Quick Start Guide## 📦 Quick Setup



### 1. Prerequisites1. **Clone this repository:**

Most tools will be installed automatically, but you need:   ```bash

- **Git** (usually pre-installed)   git clone https://github.com/krymov/mydotfiles.git ~/.dotfiles

- **Curl** (usually pre-installed)   cd ~/.dotfiles

   ```

```bash

# macOS: Install Homebrew if not present2. **Configure git (first time only):**

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"   ```bash

   git config --global user.name "Your Name"

# Linux: Your package manager should work   git config --global user.email "your.email@example.com"

# Ubuntu: sudo apt update   ```

# Arch: sudo pacman -Syu

```3. **Run the setup script:**

   ```bash

### 2. Install   ./setup.sh

```bash   ```

# Clone dotfiles

git clone https://github.com/krymov/mydotfiles.git ~/.dotfiles## 🎯 Neovim Configuration Switcher

cd ~/.dotfiles

Easily switch between different Neovim configurations:

# Configure Git (if first time)

git config --global user.name "Your Name"```bash

git config --global user.email "your.email@example.com"# List available configurations

nvim-switch list

# Run setup (handles everything!)

./setup.sh

```

# Switch configurations3. **Restart your shell or reload configuration:**

### 3. AI Setup (Optional but Recommended)

```bashnvim-switch switch astronvim    # Full-featured AstroNvim   ```bash

# Initialize AI key management

./ai-keys setupnvim-switch switch vanilla      # Minimal configuration     source ~/.zshrc



# Add your preferred AI provider (choose one or more)nvim-switch switch lazyvim      # LazyVim-based setup   ```

./ai-keys add anthropic    # Claude 3.5 Sonnet (recommended)

./ai-keys add openai       # GPT-4o

./ai-keys add gemini       # Google Gemini

# Shortcuts (if aliases are loaded)That's it! 🎉

# Test connectivity

./ai-keys testnvs-astro                       # Quick switch to AstroNvim



# Optional: Install local AInvs-vanilla                     # Quick switch to vanilla## 🛠️ Dependencies

brew install ollama

ollama servenvs-lazy                        # Quick switch to LazyVim

ollama pull llama3.1:latest

```The setup script will check for these and guide you through installation:



### 4. Start Coding# Maintenance

```bash

# Restart shellnvim-switch backup              # Backup current plugin state### Essential

source ~/.zshrc

nvim-switch clean               # Clean plugin data/cache- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink management

# Switch to AstroNvim (full IDE experience)

nvim-switch switch astronvimnvim-switch current             # Show current configuration- [Neovim](https://neovim.io/) - Text editor



# Launch Neovim and enjoy!```- [Git](https://git-scm.com/) - Version control

nvim

```



## 🎯 Essential Workflows## 📁 Directory Structure### Optional but Recommended



### Daily Development- [Nix](https://nixos.org/) - Package management and development environments

```bash

# Start your day```- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder

cd ~/projects/my-project

nvim .                     # Launch with AI assistance~/.dotfiles/- [eza](https://github.com/eza-community/eza) - Modern ls replacement



# Use AI agents while coding├── setup.sh                   # One-command setup script- [bat](https://github.com/sharkdp/bat) - Better cat with syntax highlighting

# Visual select code → <leader>aa (action palette)

# Visual select code → <leader>ar (refactor)├── nvim-switch                 # Neovim configuration switcher

# Visual select code → <leader>at (generate tests)

├── README.md                   # This file## 🎯 Neovim Configuration Switcher

# Git workflow with smart aliases

gs                         # Check status│

gaa                        # Stage all changes

gc "Add new feature"       # Commit with message├── stow/                       # Configurations managed by GNU StowEasily switch between different Neovim configurations:

gp                         # Push to remote

```│   ├── nvim/                   # AstroNvim configuration (default)



### Project Setup│   │   └── .config/nvim/```bash

```bash

# Create a new Go project│   ├── zsh/                    # ZSH configuration# List available configurations

dev-go my-api-server

cd my-api-server│   │   ├── .zshrcnvim-switch list

# Now you have: Go toolchain, LSP, linting, debugging

│   │   └── .zsh/

# Open with full IDE

nvim .│   ├── git/                    # Git configuration# Switch configurations

# AI assistance available immediately

```│   ├── tmux/                   # Tmux configurationnvim-switch switch astronvim    # Full-featured AstroNvim



### Code Review Workflow│   └── ssh/                    # SSH configurationnvim-switch switch vanilla      # Minimal configuration

```bash

# Stage your changes│nvim-switch switch lazyvim      # LazyVim-based setup

gaa

├── configs/                    # Alternative configurations

# Review with AI

nvim src/modified-file.py│   ├── nvim-astronvim/         # AstroNvim configuration# Shortcuts (if aliases are loaded)

# Select code → <leader>av (AI code review)

│   ├── nvim-vanilla/           # Minimal Neovim setupnvs-astro                       # Quick switch to AstroNvim

# Address feedback and commit

gc "Address review feedback"│   ├── nvim-lazyvim/           # LazyVim configurationnvs-vanilla                     # Quick switch to vanilla

gp

```│   └── README.md               # Configuration docsnvs-lazy                        # Quick switch to LazyVim



## 📁 Project Structure│



```├── flakes/                     # Nix development environments# Maintenance

~/.dotfiles/

├── 📘 guides/              # Comprehensive documentation│   ├── go/                     # Go development environmentnvim-switch backup              # Backup current plugin state

│   ├── setup-guide.md      # Detailed installation guide

│   ├── daily-workflow.md   # Essential commands and shortcuts│   ├── python/                 # Python development environmentnvim-switch clean               # Clean plugin data/cache

│   ├── neovim-guide.md     # Neovim configuration management

│   ├── troubleshooting.md  # Common issues and solutions│   ├── nodejs/                 # Node.js development environmentnvim-switch current             # Show current configuration

│   └── AI_CODING_GUIDE.md  # Complete AI features guide

├── 🛠️ setup.sh             # One-command setup script│   └── rust/                   # Rust development environment```

├── 🔑 ai-keys              # AI API key management

├── 🎛️ nvim-switch          # Neovim configuration switcher│

├── 📦 stow/                # Configuration files (GNU Stow)

│   ├── zsh/                # Enhanced shell configuration└── nvim-backups/              # Automatic backups (auto-created)## 📁 Directory Structure

│   ├── git/                # Git aliases and settings

│   ├── nvim/               # AstroNvim with AI integration```

│   ├── tmux/               # Terminal multiplexer

│   └── kitty/              # Modern terminal emulator```

├── ⚙️ configs/             # Alternative configurations

│   ├── nvim-lazyvim/       # Fast LazyVim setup## 🔧 Development Environments~/.dotfiles/

│   └── nvim-vanilla/       # Minimal configuration

└── 🐳 flakes/              # Development environments├── setup.sh                   # One-command setup script

    ├── go/                 # Go development

    ├── python/             # Python development  This dotfiles setup includes Nix flakes for isolated development environments:├── nvim-switch                 # Neovim configuration switcher

    ├── nodejs/             # Node.js development

    └── rust/               # Rust development├── README.md                   # This file

```

```bash│

## 🔧 Key Features Deep Dive

# Enter development environment├── stow/                       # Configurations managed by GNU Stow

### AI Integration

- **Multiple Providers**: OpenAI, Anthropic, Google Gemini, and local Ollamadev-go          # Go development│   ├── nvim/                   # AstroNvim configuration (default)

- **Secure Key Management**: Encrypted storage with easy rotation

- **Intelligent Context**: Automatically includes project structure and git diffdev-python      # Python development  │   │   └── .config/nvim/

- **Cost Effective**: Smart model selection (~$0.10-0.50 per day of coding)

dev-nodejs      # Node.js development│   ├── zsh/                    # ZSH configuration

### Shell Enhancements

- **Smart Completions**: Context-aware tab completion for all toolsdev-rust        # Rust development│   │   ├── .zshrc

- **Fuzzy Finding**: Interactive file, command, and history search

- **Git Integration**: Visual git status in file listings│   │   └── .zsh/

- **Modern Tools**: `bat`, `eza`, `ripgrep`, `fd` for enhanced CLI experience

# Or manually│   ├── git/                    # Git configuration

### Development Environments

- **Isolated**: Each project gets its own environmentcd ~/.dotfiles/flakes/go && nix develop│   ├── tmux/                   # Tmux configuration

- **Reproducible**: Same setup across machines and team members

- **Language-Specific**: Tailored tools for Go, Python, Node.js, Rust```│   └── ssh/                    # SSH configuration

- **LSP Ready**: Language servers configured out of the box

│

## 📚 Learning Resources

## 🎨 Customization├── configs/                    # Alternative configurations

### New to This Setup?

1. **[Setup Guide](guides/setup-guide.md)** - Complete installation walkthrough│   ├── nvim-astronvim/         # AstroNvim configuration

2. **[Daily Workflow](guides/daily-workflow.md)** - Essential commands to memorize

3. **[AI Quick Reference](guides/AI_QUICK_REF.md)** - Handy AI shortcuts### Adding New Neovim Configurations│   ├── nvim-vanilla/           # Minimal Neovim setup



### Want to Customize?│   ├── nvim-lazyvim/           # LazyVim configuration

1. **[Neovim Guide](guides/neovim-guide.md)** - Managing different Neovim configs

2. **[AI Coding Guide](guides/AI_CODING_GUIDE.md)** - Full AI features documentation1. Create a new directory in `configs/`:│   └── README.md               # Configuration docs

3. **[Troubleshooting](guides/troubleshooting.md)** - Common issues and solutions

   ```bash│

### Quick Reference

```bash   mkdir ~/.dotfiles/configs/nvim-custom├── flakes/                     # Nix development environments

# Essential daily commands

./ai-keys status              # Check AI providers   ```│   ├── go/                     # Go development environment

nvim-switch current           # Show current Neovim config

<leader>aa                    # AI action palette (in Neovim)│   ├── python/                 # Python development environment

gs                           # Git status

ll                           # Enhanced file listing2. Add your `init.lua` and configuration files│   ├── nodejs/                 # Node.js development environment

```

│   └── rust/                   # Rust development environment

## 🆘 Need Help?

3. Update the `nvim-switch` script to include your new config:│

### Quick Fixes

```bash   ```bash└── nvim-backups/              # Automatic backups (auto-created)

# AI not working?

./ai-keys test anthropic   # Edit the CONFIGS array in nvim-switch```



# Neovim issues?   "custom:$DOTFILES_DIR/configs/nvim-custom"

nvim-switch clean && nvim-switch switch astronvim

   ```## 🔧 Development Environments

# Shell problems?

source ~/.zshrc



# Check overall health### Customizing ZSHThis dotfiles setup includes Nix flakes for isolated development environments:

echo $SHELL && nvim --version && git --version

```



### Get Detailed Help- **Aliases**: Edit `stow/zsh/.zsh/aliases.zsh````bash

- **[Troubleshooting Guide](guides/troubleshooting.md)** - Comprehensive problem solving

- **Check AI status**: `:CodeCompanionStatus` in Neovim- **Functions**: Edit `stow/zsh/.zsh/functions.zsh`# Enter development environment

- **Test individual components**: Each tool has built-in health checks

- **Environment**: Edit `stow/zsh/.zsh/env.zsh`dev-go          # Go development

## 🔄 Staying Updated

- **Plugins**: Edit `stow/zsh/.zsh/plugins.zsh`dev-python      # Python development

```bash

# Update everything (recommended monthly)dev-nodejs      # Node.js development

cd ~/.dotfiles

git pull### Adding New Stow Packagesdev-rust        # Rust development

./setup.sh



# Update just Neovim plugins

nvim +Lazy sync +qa1. Create a new directory in `stow/`:# Or manually



# Update AI providers   ```bashcd ~/.dotfiles/flakes/go && nix develop

./ai-keys test

```   mkdir ~/.dotfiles/stow/newapp```



## 🤝 Community & Contributions   ```



This dotfiles setup is designed to be:## 🎨 Customization

- **Modular**: Pick and choose what you want

- **Extensible**: Easy to add your own configurations2. Mirror the home directory structure:

- **Shareable**: Great foundation for team setups

- **Educational**: Learn modern development practices   ```bash### Adding New Neovim Configurations



Feel free to:   mkdir -p ~/.dotfiles/stow/newapp/.config/newapp

- 🍴 Fork and customize for your needs

- 🐛 Report issues or suggest improvements     ```1. Create a new directory in `configs/`:

- 🎉 Share your own enhancements

- 📚 Contribute to the documentation   ```bash



## 🏆 Why Choose This Setup?3. Add your configuration files   mkdir ~/.dotfiles/configs/nvim-custom



### Compared to Other Dotfiles:   ```

✅ **AI Integration** - Built-in coding assistance

✅ **Multiple Neovim Configs** - Switch based on your needs  4. Stow the package:

✅ **Comprehensive Guides** - Actually usable documentation

✅ **Secure AI Keys** - Proper secret management     ```bash2. Add your `init.lua` and configuration files

✅ **Modern Tools** - Latest CLI enhancements

✅ **Cross-Platform** - Works on macOS and Linux     cd ~/.dotfiles && stow -t ~ stow/newapp



### Perfect For:   ```3. Update the `nvim-switch` script to include your new config:

- 🧑‍💻 **Daily Developers** - Boost productivity with AI assistance

- 🎓 **Learning** - Great examples of modern development practices   ```bash

- 👥 **Teams** - Standardize development environments

- 🔄 **Multi-Machine** - Consistent setup everywhere## 🖥️ Platform Support   # Edit the CONFIGS array in nvim-switch



---   "custom:$DOTFILES_DIR/configs/nvim-custom"



**Ready to supercharge your development workflow?** 🚀This dotfiles setup is designed to work across:   ```



Start with the [Setup Guide](guides/setup-guide.md) and you'll be coding with AI assistance in minutes!



> **Pro Tip**: After setup, try selecting some code in Neovim and pressing `<leader>ar` for AI refactoring. You'll never want to code without AI assistance again! 🤖✨- **macOS** (with Homebrew)### Customizing ZSH

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
