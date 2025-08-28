#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Change to script directory
cd "$(dirname "$0")"

# Platform detection
detect_platform() {
    case "$OSTYPE" in
        darwin*)
            echo "macos"
            ;;
        linux*)
            if command -v nixos-rebuild >/dev/null 2>&1; then
                echo "nixos"
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

PLATFORM=$(detect_platform)
log_info "Detected platform: $PLATFORM"

# Check if Nix is available
if ! command -v nix-env >/dev/null 2>&1; then
    log_error "Nix package manager not found. Please install Nix first:"
    echo "  curl -L https://nixos.org/nix/install | sh"
    exit 1
fi

# Install base packages via Nix
log_info "Installing base packages via Nix..."
nix-env -iA \
  nixpkgs.stow \
  nixpkgs.git \
  nixpkgs.tmux \
  nixpkgs.zsh \
  nixpkgs.fzf \
  nixpkgs.ripgrep \
  nixpkgs.fd \
  nixpkgs.eza \
  nixpkgs.bat \
  nixpkgs.direnv \
  nixpkgs.gh \
  nixpkgs.lazygit \
  nixpkgs.neovim \
  nixpkgs.curl \
  nixpkgs.wget \
  nixpkgs.tree \
  nixpkgs.htop || {
    log_warning "Some packages failed to install, continuing..."
}

# Platform-specific package installation
case "$PLATFORM" in
    "nixos"|"linux")
        log_info "Installing Linux-specific packages..."
        nix-env -iA nixpkgs.kitty nixpkgs.xclip || log_warning "Failed to install some Linux packages"
        ;;
    "macos")
        log_info "Installing macOS-specific packages..."
        # On macOS, kitty might be better installed via Homebrew
        if command -v brew >/dev/null 2>&1; then
            brew install --cask kitty || log_warning "Failed to install kitty via Homebrew"
        else
            nix-env -iA nixpkgs.kitty || log_warning "Failed to install kitty via Nix"
        fi
        ;;
esac

# Set zsh as default shell
log_info "Setting up zsh as default shell..."
case "$PLATFORM" in
    "macos")
        if ! dscl . -read /Users/"$USER" UserShell | grep -q "/zsh$"; then
            ZSH_PATH=$(command -v zsh)
            if ! grep -q "$ZSH_PATH" /etc/shells; then
                echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
            fi
            chsh -s "$ZSH_PATH"
            log_success "Changed default shell to zsh"
        else
            log_info "zsh is already the default shell"
        fi
        ;;
    "nixos"|"linux")
        if [[ "$SHELL" != *"zsh"* ]]; then
            ZSH_PATH=$(command -v zsh)
            if grep -q "$ZSH_PATH" /etc/shells; then
                chsh -s "$ZSH_PATH"
                log_success "Changed default shell to zsh"
            else
                log_warning "zsh not in /etc/shells. You may need to add it manually."
            fi
        else
            log_info "zsh is already the default shell"
        fi
        ;;
esac

# Create necessary directories
log_info "Creating necessary directories..."
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.cache"

# Backup existing configs
backup_config() {
    local config_path="$1"
    if [[ -f "$config_path" && ! -L "$config_path" ]]; then
        log_warning "Backing up existing $config_path to ${config_path}.backup"
        mv "$config_path" "${config_path}.backup"
    fi
}

# Backup existing configurations
backup_config "$HOME/.zshrc"
backup_config "$HOME/.tmux.conf"
backup_config "$HOME/.gitconfig"

# Stow dotfiles
log_info "Symlinking dotfiles with Stow..."

# Core modules for all platforms
STOW_MODULES="zsh tmux git nvim"

# Add kitty on Linux/NixOS
if [[ "$PLATFORM" == "nixos" || "$PLATFORM" == "linux" ]] && [[ -d stow/kitty ]]; then
    STOW_MODULES="$STOW_MODULES kitty"
fi

for module in $STOW_MODULES; do
    if [[ -d "stow/$module" ]]; then
        log_info "Stowing $module..."
        stow -d stow "$module" || log_error "Failed to stow $module"
    else
        log_warning "Module $module not found, skipping..."
    fi
done

# Install AstroNvim if not present
if [[ ! -d "$HOME/.config/nvim/lua/astronvim" ]]; then
    log_info "Installing AstroNvim..."

    # Check if nvim config directory exists but is not AstroNvim
    if [[ -d "$HOME/.config/nvim" ]]; then
        log_warning "Existing nvim config found. Backing up to ~/.config/nvim.backup-$(date +%Y%m%d-%H%M%S)"
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup-$(date +%Y%m%d-%H%M%S)"
    fi

    # Install AstroNvim
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
    log_success "AstroNvim installed"

    # Copy our user configuration
    if [[ -d "stow/nvim/.config/nvim/lua/user" ]]; then
        log_info "Installing user configuration..."
        cp -r stow/nvim/.config/nvim/lua/user ~/.config/nvim/lua/
        log_success "User configuration installed"
    fi
else
    log_info "AstroNvim already installed"

    # Update user configuration if it exists in our dotfiles
    if [[ -d "stow/nvim/.config/nvim/lua/user" ]]; then
        log_info "Updating user configuration..."
        mkdir -p ~/.config/nvim/lua/user
        cp -r stow/nvim/.config/nvim/lua/user/* ~/.config/nvim/lua/user/
        log_success "User configuration updated"
    fi
fi

# Create initial tmux session
log_info "Setting up tmux..."
if command -v tmux >/dev/null 2>&1; then
    # Kill any existing default session
    tmux kill-session -t default 2>/dev/null || true
    # Source tmux config
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null || log_warning "Could not source tmux config"
fi

log_success "Dotfiles setup complete!"
echo
log_info "Next steps:"
echo "  1. Open a new terminal to load zsh configuration"
echo "  2. Run 'tmux' to start a tmux session"
echo "  3. Run 'nvim' to initialize AstroNvim (it will download plugins automatically)"
echo "  4. Consider running 'git config --global user.name \"Your Name\"'"
echo "  5. Consider running 'git config --global user.email \"your@email.com\"'"
echo
log_info "Your old configs have been backed up with .backup extension if they existed."
