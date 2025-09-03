#!/usr/bin/env bash
# Install packages from packages.nix using nix-env
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Environment selection (default to development)
ENVIRONMENT="${1:-development}"

log_info "Installing packages for environment: $ENVIRONMENT"

# Create a temporary Nix expression that exposes our packages
cat > /tmp/install-packages.nix << EOF
let
  pkgs = import <nixpkgs> {};
  packages = import $(pwd)/packages.nix { inherit pkgs; environment = "$ENVIRONMENT"; };
in
  pkgs.buildEnv {
    name = "dotfiles-packages-$ENVIRONMENT";
    paths = packages;
  }
EOF

# Install using nix-env
log_info "Installing packages..."
if nix-env -i -f /tmp/install-packages.nix; then
    log_success "Packages installed successfully!"
else
    log_error "Failed to install packages"
    exit 1
fi

# Clean up
rm -f /tmp/install-packages.nix

log_info "Installed packages for environment: $ENVIRONMENT"
log_info "Available environments: development, server, minimal"
