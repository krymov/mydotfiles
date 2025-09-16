#!/usr/bin/env bash
# Home Manager installation script for cross-platform support

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if Home Manager is already installed
check_home_manager() {
    if command -v home-manager &> /dev/null; then
        log_info "Home Manager is already installed"
        home-manager --version
        return 0
    else
        return 1
    fi
}

# Install Home Manager
install_home_manager() {
    log_info "Installing Home Manager..."
    
    # Add Home Manager channel if not already added
    if ! nix-channel --list | grep -q home-manager; then
        log_info "Adding Home Manager channel..."
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
    else
        log_info "Home Manager channel already exists, updating..."
        nix-channel --update
    fi
    
    # Install Home Manager
    log_info "Installing Home Manager binary..."
    export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
    nix-shell '<home-manager>' -A install
    
    log_success "Home Manager installed successfully!"
}

# Apply Home Manager configuration
apply_configuration() {
    local config_path="$1"
    
    if [[ ! -f "$config_path" ]]; then
        log_error "Home Manager configuration not found at: $config_path"
        exit 1
    fi
    
    log_info "Applying Home Manager configuration from: $config_path"
    
    # Link the configuration to the expected location
    mkdir -p "$HOME/.config/home-manager"
    if [[ ! -L "$HOME/.config/home-manager/home.nix" ]]; then
        ln -sf "$config_path" "$HOME/.config/home-manager/home.nix"
        log_info "Linked configuration to ~/.config/home-manager/home.nix"
    fi
    
    # Apply the configuration
    home-manager switch
    
    log_success "Home Manager configuration applied successfully!"
}

# Main function
main() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local config_path="$script_dir/home.nix"
    
    log_info "Starting Home Manager setup..."
    
    # Check if Nix is installed
    if ! command -v nix &> /dev/null; then
        log_error "Nix is not installed. Please install Nix first."
        exit 1
    fi
    
    # Install Home Manager if not present
    if ! check_home_manager; then
        install_home_manager
    fi
    
    # Apply configuration
    apply_configuration "$config_path"
    
    log_success "Home Manager setup complete!"
    log_info "You can now use 'home-manager switch' to apply configuration changes"
    log_info "Use 'home-manager generations' to see previous generations"
    log_info "Use 'home-manager switch --rollback' to rollback if needed"
}

# Run main function
main "$@"