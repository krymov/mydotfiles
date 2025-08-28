#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

cd "$(dirname "$0")"

show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Manage Nix packages for dotfiles"
    echo ""
    echo "Commands:"
    echo "  install       Install all packages from packages.nix"
    echo "  update        Update all installed packages"
    echo "  list          List currently installed packages"
    echo "  search TERM   Search for packages containing TERM"
    echo "  add PACKAGE   Add a package to your environment"
    echo "  shell         Enter development shell with all packages"
    echo "  clean         Remove unused packages and garbage collect"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 install           # Install all packages"
    echo "  $0 search python     # Search for Python packages"
    echo "  $0 add nodejs        # Add nodejs to your environment"
}

install_packages() {
    log_info "Installing packages from packages.nix..."

    if [[ ! -f "packages.nix" ]]; then
        log_error "packages.nix not found!"
        return 1
    fi

    # Build the package list
    local packages
    packages=$(nix-instantiate --eval --expr 'map (p: p.name) (import ./packages.nix {})' | tr -d '[]"' | tr ';' '\n' | grep -v '^$' | sort)

    log_info "Installing packages:"
    echo "$packages" | sed 's/^/  - /'

    # Install packages one by one for better error handling
    while IFS= read -r package; do
        if [[ -n "$package" ]]; then
            log_info "Installing $package..."
            nix-env -iA "nixpkgs.$package" || log_warning "Failed to install $package"
        fi
    done <<< "$packages"

    log_success "Package installation complete!"
}

update_packages() {
    log_info "Updating all installed packages..."
    nix-env -u || log_warning "Some packages failed to update"
    log_success "Package update complete!"
}

list_packages() {
    log_info "Currently installed packages:"
    nix-env -q | sort
}

search_packages() {
    local term="$1"
    log_info "Searching for packages containing '$term'..."
    nix-env -qaP | grep -i "$term" | head -20
}

add_package() {
    local package="$1"
    log_info "Installing $package..."
    nix-env -iA "nixpkgs.$package" || {
        log_error "Failed to install $package"
        log_info "Try searching first: $0 search $package"
        return 1
    }
    log_success "$package installed!"
}

enter_shell() {
    log_info "Entering development shell..."
    nix-shell
}

clean_packages() {
    log_info "Cleaning up unused packages..."
    nix-collect-garbage -d
    log_success "Cleanup complete!"
}

# Parse command
case "${1:-help}" in
    install)
        install_packages
        ;;
    update)
        update_packages
        ;;
    list|ls)
        list_packages
        ;;
    search)
        if [[ $# -lt 2 ]]; then
            log_error "Usage: $0 search TERM"
            exit 1
        fi
        search_packages "$2"
        ;;
    add)
        if [[ $# -lt 2 ]]; then
            log_error "Usage: $0 add PACKAGE"
            exit 1
        fi
        add_package "$2"
        ;;
    shell)
        enter_shell
        ;;
    clean)
        clean_packages
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
