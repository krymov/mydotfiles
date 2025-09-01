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
        darwin*) echo "macos" ;;
        linux*)
            if command -v nixos-rebuild >/dev/null 2>&1; then
                echo "nixos"
            else
                echo "linux"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}

PLATFORM=$(detect_platform)

show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Update dotfiles and packages"
    echo ""
    echo "Options:"
    echo "  -a, --all         Update everything (packages + dotfiles + nvim)"
    echo "  -p, --packages    Update only Nix packages"
    echo "  -d, --dotfiles    Update only dotfiles (pull from git + restow)"
    echo "  -n, --nvim        Update only Neovim/AstroNvim"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -a             # Update everything"
    echo "  $0 -p             # Update only packages"
    echo "  $0 --dotfiles     # Update only dotfiles"
}

update_packages() {
    log_info "Updating Nix packages..."

    # Update Nix packages
    if command -v nix-env >/dev/null; then
        nix-env -u || log_warning "Some packages failed to update"
        log_success "Nix packages updated"
    else
        log_error "Nix not found"
        return 1
    fi

    # Platform-specific updates
    case "$PLATFORM" in
        "macos")
            if command -v brew >/dev/null; then
                log_info "Updating Homebrew packages..."
                brew update && brew upgrade || log_warning "Homebrew update failed"
                brew cleanup || log_warning "Homebrew cleanup failed"
                log_success "Homebrew packages updated"
            fi
            ;;
        "nixos")
            log_info "For NixOS system updates, run: sudo nixos-rebuild switch --upgrade"
            ;;
    esac
}

update_dotfiles() {
    log_info "Updating dotfiles from git..."

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        return 1
    fi

    # Check for local changes and handle them
    if ! git diff --quiet || ! git diff --cached --quiet; then
        log_warning "Local changes detected..."
        
        # Try to stash changes
        if ! git stash push -m "Auto-stash before update $(date)" 2>/dev/null; then
            log_warning "Could not stash changes automatically. Trying reset..."
            
            # Reset any staged changes that might be causing conflicts
            git reset HEAD . 2>/dev/null || true
            
            # Try stash again
            if ! git stash push -m "Auto-stash before update $(date)" 2>/dev/null; then
                log_warning "Still cannot stash. Will try to pull anyway..."
            fi
        fi
    fi

    # Pull latest changes
    if ! git pull; then
        log_warning "Git pull failed. Trying to resolve..."
        
        # Try to reset any problematic index state
        git reset --hard HEAD 2>/dev/null || true
        
        # Try pull again
        if ! git pull; then
            log_error "Failed to pull from git after reset"
            return 1
        fi
    fi

    log_success "Dotfiles updated from git"

    # Re-stow configurations
    log_info "Re-stowing configurations..."

    STOW_MODULES="zsh tmux git nvim"
    if [[ "$PLATFORM" == "nixos" || "$PLATFORM" == "linux" ]] && [[ -d stow/kitty ]]; then
        STOW_MODULES="$STOW_MODULES kitty"
    fi

    for module in $STOW_MODULES; do
        if [[ -d "stow/$module" ]]; then
            log_info "Re-stowing $module..."
            stow -R -d stow "$module" || log_warning "Failed to restow $module"
        fi
    done

    log_success "Configurations re-stowed"
}

update_nvim() {
    log_info "Updating Neovim/AstroNvim..."

    # Update AstroNvim itself
    if [[ -d "$HOME/.config/nvim/.git" ]]; then
        log_info "Updating AstroNvim core..."
        cd "$HOME/.config/nvim"
        git pull || log_warning "Failed to update AstroNvim core"
        cd - > /dev/null
    fi

    # Update user configuration
    if [[ -d "stow/nvim/.config/nvim/lua/user" ]]; then
        log_info "Updating user configuration..."
        mkdir -p ~/.config/nvim/lua/user
        cp -r stow/nvim/.config/nvim/lua/user/* ~/.config/nvim/lua/user/
        log_success "User configuration updated"
    fi

    # Update plugins (this will happen when nvim is next opened)
    log_info "Neovim plugins will be updated on next nvim startup"
    log_info "Or run: nvim +AstroUpdate"

    log_success "Neovim/AstroNvim updated"
}

# Parse command line arguments
case "${1:-}" in
    -a|--all)
        log_info "Updating everything..."
        update_packages
        update_dotfiles
        update_nvim
        ;;
    -p|--packages)
        update_packages
        ;;
    -d|--dotfiles)
        update_dotfiles
        ;;
    -n|--nvim)
        update_nvim
        ;;
    -h|--help)
        show_help
        exit 0
        ;;
    "")
        # No arguments - interactive mode
        echo "What would you like to update?"
        echo "1) Everything (packages + dotfiles + nvim)"
        echo "2) Only packages"
        echo "3) Only dotfiles"
        echo "4) Only Neovim/AstroNvim"
        echo "5) Show help"
        read -p "Choose [1-5]: " choice

        case "$choice" in
            1) update_packages && update_dotfiles && update_nvim ;;
            2) update_packages ;;
            3) update_dotfiles ;;
            4) update_nvim ;;
            5) show_help ;;
            *) log_error "Invalid choice" && exit 1 ;;
        esac
        ;;
    *)
        log_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac

log_success "Update complete!"
echo ""
log_info "If you updated dotfiles, consider:"
echo "  - Restart your shell: exec zsh"
echo "  - Reload tmux config: tmux source-file ~/.tmux.conf"
echo "  - Open nvim to update plugins: nvim +AstroUpdate"
