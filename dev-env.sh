#!/usr/bin/env bash
# Easy environment switcher for dotfiles

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_help() {
    echo "🚀 Dotfiles Environment Switcher"
    echo ""
    echo "Usage: $0 [ENVIRONMENT]"
    echo ""
    echo "Environments:"
    echo "  development  - Full development environment with data tools (default)"
    echo "  server      - Minimal server environment"
    echo "  minimal     - Basic minimal environment"
    echo "  data        - Dedicated data analysis environment (flake-based)"
    echo ""
    echo "Examples:"
    echo "  $0 development  # Load full development environment"
    echo "  $0 server      # Load minimal server environment"
    echo "  $0 data        # Load data analysis environment"
    echo ""
    echo "For project-specific environments, use flakes:"
    echo "  dev-go myproject       # Go development"
    echo "  dev-python myproject   # Python development"
    echo "  dev-nodejs myproject   # Node.js development"
    echo "  dev-rust myproject     # Rust development"
}

load_environment() {
    local env="$1"
    local dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    case "$env" in
        "development"|"dev")
            echo -e "${GREEN}Loading development environment...${NC}"
            nix-shell "$dotfiles_dir/shell.nix" --arg environment '"development"'
            ;;
        "server")
            echo -e "${BLUE}Loading server environment...${NC}"
            nix-shell "$dotfiles_dir/shell.nix" --arg environment '"server"'
            ;;
        "minimal"|"min")
            echo -e "${YELLOW}Loading minimal environment...${NC}"
            nix-shell "$dotfiles_dir/shell.nix" --arg environment '"minimal"'
            ;;
        "data"|"analysis")
            echo -e "${GREEN}Loading data analysis environment...${NC}"
            if [[ -f "$dotfiles_dir/flakes/data/flake.nix" ]]; then
                nix --extra-experimental-features nix-command --extra-experimental-features flakes develop "$dotfiles_dir/flakes/data"
            else
                echo -e "${RED}Data flake not found at $dotfiles_dir/flakes/data/flake.nix${NC}"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}Unknown environment: $env${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Main execution
main() {
    if [[ $# -eq 0 ]] || [[ "$1" == "help" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_help
        exit 0
    fi

    local environment="$1"
    load_environment "$environment"
}

main "$@"
