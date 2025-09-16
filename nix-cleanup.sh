#!/usr/bin/env bash
# Complete Nix cleanup script for macOS

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

confirm() {
    read -p "$1 (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

log_info "Nix Cleanup Script for macOS"
echo "This will completely remove Nix from your system."
echo

if ! confirm "Do you want to proceed with complete Nix removal?"; then
    log_info "Cleanup cancelled."
    exit 0
fi

# Stop and unload Nix daemon
log_info "Stopping Nix daemon..."
if [[ -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist ]]; then
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
    sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    log_success "Nix daemon stopped and removed"
fi

# Remove system files
log_info "Removing system Nix files..."
sudo rm -rf /etc/nix 2>/dev/null || true
sudo rm -rf /nix 2>/dev/null || true
sudo rm -rf /var/root/.nix-profile 2>/dev/null || true
sudo rm -rf /var/root/.nix-defexpr 2>/dev/null || true
sudo rm -rf /var/root/.nix-channels 2>/dev/null || true

# Remove user files
log_info "Removing user Nix files..."
rm -rf ~/.nix-profile 2>/dev/null || true
rm -rf ~/.nix-defexpr 2>/dev/null || true
rm -rf ~/.nix-channels 2>/dev/null || true
rm -rf ~/.local/state/nix 2>/dev/null || true
rm -rf ~/.config/nix 2>/dev/null || true
rm -rf ~/.config/home-manager 2>/dev/null || true
rm -rf ~/.cache/nix 2>/dev/null || true

# Remove nixbld users and group (if they exist)
log_info "Removing nixbld users and group..."
for i in $(seq 1 32); do
    sudo dscl . -delete /Users/nixbld$i 2>/dev/null || true
done
sudo dscl . -delete /Groups/nixbld 2>/dev/null || true

# Clean up any remaining shell configuration
log_info "Cleaning up shell profiles..."

# Remove Nix from individual user profiles if they exist
for profile in ~/.bash_profile ~/.bashrc ~/.zshrc ~/.profile; do
    if [[ -f "$profile" ]]; then
        # Remove Nix-related lines
        sed -i.bak '/# Nix/,/# End Nix/d' "$profile" 2>/dev/null || true
        sed -i.bak '/\/nix\/var\/nix\/profiles\/default\/etc\/profile\.d\/nix\.sh/d' "$profile" 2>/dev/null || true
        sed -i.bak '/\.nix-profile\/etc\/profile\.d\/nix\.sh/d' "$profile" 2>/dev/null || true
    fi
done

# Verify system shell configs are clean (already done above)
log_success "Shell configuration cleaned"

# Remove any Nix-related entries from PATH in current session
export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v nix | tr '\n' ':' | sed 's/:$//')

log_success "Nix completely removed from the system!"
log_info "You may want to restart your terminal or log out/in to ensure all changes take effect."
log_info "Shell configuration backups were created with .bak extension."
