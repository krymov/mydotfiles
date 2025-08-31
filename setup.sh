#!/usr/bin/env bash
# Dotfiles Setup Script
# Sets up the dotfiles environment on a new system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUcheck_git_config() {
    log_info "Checking Git configuration..."

    local needs_config=false

    if ! git config --global user.name >/dev/null 2>&1; then
        log_warning "Git user.name not set"
        needs_config=true
    fi

    if ! git config --global user.email >/dev/null 2>&1; then
        log_warning "Git user.email not set"
        needs_config=true
    fi

    if [ "$needs_config" = true ]; then
        echo
        echo "📧 Git configuration required for this repository."
        echo "   This ensures proper commit attribution."
        echo
        echo "Please run these commands to configure git:"
        if ! git config --global user.name >/dev/null 2>&1; then
            echo "   git config --global user.name \"Your Name\""
        fi
        if ! git config --global user.email >/dev/null 2>&1; then
            echo "   git config --global user.email \"your.email@example.com\""
        fi
        echo
        echo "Then re-run this setup script if needed."
        echo
    fi
}'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_dependencies() {
    log_info "Checking dependencies..."

    local missing_deps=()

    # Check for essential tools
    command -v stow >/dev/null 2>&1 || missing_deps+=("stow")
    command -v nvim >/dev/null 2>&1 || missing_deps+=("neovim")
    command -v git >/dev/null 2>&1 || missing_deps+=("git")

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "Please install them first:"
        echo ""

        # Platform-specific installation instructions
        case "$OSTYPE" in
            darwin*)
                echo "macOS (Homebrew):"
                echo "  brew install stow neovim git"
                ;;
            linux*)
                if command -v apt >/dev/null 2>&1; then
                    echo "Ubuntu/Debian:"
                    echo "  sudo apt update && sudo apt install stow neovim git"
                elif command -v pacman >/dev/null 2>&1; then
                    echo "Arch Linux:"
                    echo "  sudo pacman -S stow neovim git"
                elif command -v dnf >/dev/null 2>&1; then
                    echo "Fedora:"
                    echo "  sudo dnf install stow neovim git"
                else
                    echo "Linux: Install stow, neovim, and git using your package manager"
                fi
                ;;
            *)
                echo "Install stow, neovim, and git using your package manager"
                ;;
        esac
        echo ""
        exit 1
    fi

    log_success "All dependencies found"
}

backup_existing_configs() {
    log_info "Backing up existing configurations..."

    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    local backed_up=false

    # Backup existing configs (including symlinks that point elsewhere)
    for config in nvim; do
        if [ -e "$HOME/.config/$config" ]; then
            # Check if it's a symlink pointing to our dotfiles
            if [ -L "$HOME/.config/$config" ]; then
                local target=$(readlink "$HOME/.config/$config")
                # If it points to our dotfiles, skip it
                if [[ "$target" == *"$DOTFILES_DIR"* ]]; then
                    log_info "Existing $config configuration already points to dotfiles, skipping backup"
                    continue
                fi
            fi

            if [ "$backed_up" = false ]; then
                mkdir -p "$backup_dir"
                backed_up=true
            fi
            log_warning "Backing up existing $config configuration"
            mv "$HOME/.config/$config" "$backup_dir/"
        fi
    done

    # Backup zsh configs
    for file in .zshrc .zsh; do
        if [ -e "$HOME/$file" ]; then
            # Check if it's a symlink pointing to our dotfiles
            if [ -L "$HOME/$file" ]; then
                local target=$(readlink "$HOME/$file")
                # If it points to our dotfiles, skip it
                if [[ "$target" == *"$DOTFILES_DIR"* ]] || [[ "$target" == *".dotfiles"* ]]; then
                    log_info "Existing $file already points to dotfiles, skipping backup"
                    continue
                fi
            fi

            if [ "$backed_up" = false ]; then
                mkdir -p "$backup_dir"
                backed_up=true
            fi
            log_warning "Backing up existing $file"
            mv "$HOME/$file" "$backup_dir/"
        fi
    done

    if [ "$backed_up" = true ]; then
        log_success "Existing configurations backed up to: $backup_dir"
    else
        log_info "No existing configurations to backup"
    fi
}

setup_symlinks() {
    log_info "Setting up configuration symlinks..."

    # Create necessary directories
    mkdir -p "$HOME/.config"

    # Use stow to create symlinks
    cd "$DOTFILES_DIR/stow"

    log_info "Stowing ZSH configuration..."
    stow -t "$HOME" zsh

    # Skip nvim for now - it's managed by nvim-switch
    log_info "Skipping Neovim configuration (managed by nvim-switch)"

    # Handle other stow directories
    for dir in */; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            if [ "$dirname" != "zsh" ] && [ "$dirname" != "nvim" ]; then
                log_info "Stowing $dirname configuration..."
                stow -t "$HOME" "$dirname"
            fi
        fi
    done

    log_success "Configuration symlinks created"
}

setup_nvim_switch() {
    log_info "Setting up Neovim configuration switcher..."

    # Make nvim-switch executable
    chmod +x "$DOTFILES_DIR/nvim-switch"

    # Add to PATH in .zshrc if not already there
    local zshrc="$HOME/.zshrc"
    if [ -f "$zshrc" ] && ! grep -q "nvim-switch" "$zshrc"; then
        echo "" >> "$zshrc"
        echo "# Dotfiles PATH" >> "$zshrc"
        echo "export PATH=\"$DOTFILES_DIR:\$PATH\"" >> "$zshrc"
        log_success "Added nvim-switch to PATH in .zshrc"
    fi

    log_success "Neovim configuration switcher ready"
}

setup_git_config() {
    log_info "Checking Git configuration..."

    if ! git config --global user.name >/dev/null 2>&1; then
        log_warning "Git user.name not set"
        echo "Please run: git config --global user.name \"Your Name\""
    fi

    if ! git config --global user.email >/dev/null 2>&1; then
        log_warning "Git user.email not set"
        echo "Please run: git config --global user.email \"your.email@example.com\""
    fi
}

main() {
    echo "🚀 Setting up dotfiles..."
    echo "Dotfiles directory: $DOTFILES_DIR"
    echo ""

    check_dependencies
    backup_existing_configs
    setup_symlinks
    setup_nvim_switch
    setup_git_config

    echo ""
    log_success "Dotfiles setup complete!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your shell or run: source ~/.zshrc"
    echo "2. Use 'nvim-switch list' to see available Neovim configurations"
    echo "3. Use 'nvim-switch switch astronvim' to use AstroNvim"
    echo "4. Customize configurations in ~/.dotfiles/configs/"
    echo ""
    echo "Happy coding! 🎉"
}

# Run the main function
main "$@"
