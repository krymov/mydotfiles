#!/usr/bin/env bash
# Cachix setup and management script
# Provides easy functions for managing Cachix binary caches

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_help() {
    echo "🗄️  Cachix Management Script"
    echo ""
    echo "Usage: cachix-setup.sh [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  use <cache-name>              - Configure and use a cachix cache"
    echo "  push <cache> <derivation>     - Push a derivation to cache"
    echo "  push-env <cache>              - Push current nix environment to cache"
    echo "  watch <cache>                 - Watch and automatically push builds"
    echo "  auth                          - Authenticate with cachix"
    echo "  create <cache-name>           - Create a new cache (requires auth)"
    echo "  list                          - List available caches"
    echo "  status                        - Show current cachix configuration"
    echo ""
    echo "Examples:"
    echo "  cachix-setup.sh use nix-community"
    echo "  cachix-setup.sh push my-cache ./result"
    echo "  cachix-setup.sh push-env my-project-cache"
    echo "  cachix-setup.sh watch my-cache"
    echo ""
}

# Function to setup a new cachix cache
setup_cache() {
    local cache_name="$1"
    echo -e "${BLUE}🗄️  Setting up Cachix cache: ${cache_name}${NC}"
    
    # Use the cache
    cachix use "$cache_name"
    
    echo -e "${GREEN}✅ Cache ${cache_name} configured successfully${NC}"
    
    # If we're in a project directory with flake.nix, suggest adding to config
    if [[ -f "flake.nix" ]]; then
        echo ""
        echo -e "${YELLOW}💡 Suggestion: Add this cache to your flake.nix:${NC}"
        echo ""
        echo "  nixConfig = {"
        echo "    extra-substituters = ["
        echo "      \"https://${cache_name}.cachix.org\""
        echo "    ];"
        echo "    extra-trusted-public-keys = ["
        echo "      \"${cache_name}.cachix.org-1:YOUR_PUBLIC_KEY_HERE\""
        echo "    ];"
        echo "  };"
        echo ""
        echo "Get the public key from: https://app.cachix.org/cache/${cache_name}"
    fi
}

# Function to push to cachix
push_to_cache() {
    local cache_name="$1"
    local derivation="${2:-.}"
    
    echo -e "${BLUE}📤 Pushing ${derivation} to ${cache_name}${NC}"
    
    if [[ -d "$derivation" ]]; then
        # If it's a directory, build first
        nix-build "$derivation" | cachix push "$cache_name"
    elif [[ -f "$derivation" ]]; then
        # If it's a file, assume it's a store path
        cachix push "$cache_name" "$derivation"
    else
        # Try to build the derivation
        nix-build "$derivation" | cachix push "$cache_name"
    fi
    
    echo -e "${GREEN}✅ Successfully pushed to ${cache_name}${NC}"
}

# Function to push current environment to cache
push_env_to_cache() {
    local cache_name="$1"
    
    echo -e "${BLUE}📤 Pushing current nix environment to ${cache_name}${NC}"
    
    if [[ -f "flake.nix" ]]; then
        # If we have a flake, build the dev shell
        nix develop --print-out-paths | cachix push "$cache_name"
    elif [[ -f "shell.nix" ]]; then
        # If we have shell.nix, build that
        nix-build shell.nix | cachix push "$cache_name"
    elif [[ -f "default.nix" ]]; then
        # If we have default.nix, build that
        nix-build | cachix push "$cache_name"
    else
        echo -e "${RED}❌ No flake.nix, shell.nix, or default.nix found${NC}"
        echo "Please run this from a directory with a Nix expression"
        return 1
    fi
    
    echo -e "${GREEN}✅ Environment pushed to ${cache_name}${NC}"
}

# Function to watch and push builds
watch_cache() {
    local cache_name="$1"
    
    echo -e "${BLUE}👀 Watching builds and pushing to ${cache_name}${NC}"
    echo "Press Ctrl+C to stop watching"
    
    if command -v cachix >/dev/null && cachix --help | grep -q "watch-exec"; then
        cachix watch-exec "$cache_name" -- nix build
    else
        echo -e "${YELLOW}⚠️  cachix watch-exec not available, using manual watching${NC}"
        echo "Monitoring current directory for changes..."
        
        # Simple file watcher (requires manual trigger)
        while true; do
            echo "Press Enter to build and push, or Ctrl+C to exit"
            read -r
            
            if [[ -f "flake.nix" ]]; then
                nix build && nix develop --print-out-paths | cachix push "$cache_name"
            elif [[ -f "shell.nix" ]]; then
                nix-build shell.nix | cachix push "$cache_name"
            else
                nix-build | cachix push "$cache_name"
            fi
        done
    fi
}

# Function to authenticate with cachix
auth_cachix() {
    echo -e "${BLUE}🔐 Authenticating with Cachix...${NC}"
    echo ""
    echo "You can get your auth token from: https://app.cachix.org/personal-auth-tokens"
    echo ""
    
    cachix authtoken
    
    echo -e "${GREEN}✅ Authentication configured${NC}"
}

# Function to create a new cache
create_cache() {
    local cache_name="$1"
    
    echo -e "${BLUE}🆕 Creating new Cachix cache: ${cache_name}${NC}"
    
    if ! cachix authtoken --help >/dev/null 2>&1; then
        echo -e "${RED}❌ Not authenticated with Cachix${NC}"
        echo "Please run: cachix-setup.sh auth"
        return 1
    fi
    
    cachix create "$cache_name"
    
    echo -e "${GREEN}✅ Cache ${cache_name} created successfully${NC}"
    echo ""
    echo "You can now use it with:"
    echo "  cachix-setup.sh use ${cache_name}"
}

# Function to list available caches
list_caches() {
    echo -e "${BLUE}📋 Available Cachix caches:${NC}"
    echo ""
    
    # List some popular public caches
    echo "Popular public caches:"
    echo "  nix-community     - Community packages"
    echo "  nixpkgs-unfree    - Unfree packages"
    echo "  cuda-maintainers  - CUDA packages"
    echo "  devenv            - devenv.sh environments"
    echo ""
    
    # Try to list user's private caches if authenticated
    if cachix authtoken --help >/dev/null 2>&1; then
        echo "Your caches:"
        cachix list 2>/dev/null || echo "  (none found or not authenticated)"
    else
        echo "Your caches: (not authenticated)"
    fi
}

# Function to show current status
show_status() {
    echo -e "${BLUE}📊 Cachix Status${NC}"
    echo ""
    
    echo "Cachix version:"
    cachix --version
    echo ""
    
    echo "Authentication status:"
    if cachix authtoken --help >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Authenticated${NC}"
    else
        echo -e "${YELLOW}⚠️  Not authenticated${NC}"
    fi
    echo ""
    
    echo "Configured substituters:"
    nix show-config | grep substituters || echo "No custom substituters configured"
    echo ""
    
    echo "Trusted public keys:"
    nix show-config | grep trusted-public-keys || echo "No custom public keys configured"
}

# Main function
main() {
    case "${1:-help}" in
        "use")
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}❌ Cache name required${NC}"
                echo "Usage: cachix-setup.sh use <cache-name>"
                exit 1
            fi
            setup_cache "$2"
            ;;
        "push")
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}❌ Cache name required${NC}"
                echo "Usage: cachix-setup.sh push <cache-name> [derivation]"
                exit 1
            fi
            push_to_cache "$2" "${3:-}"
            ;;
        "push-env")
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}❌ Cache name required${NC}"
                echo "Usage: cachix-setup.sh push-env <cache-name>"
                exit 1
            fi
            push_env_to_cache "$2"
            ;;
        "watch")
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}❌ Cache name required${NC}"
                echo "Usage: cachix-setup.sh watch <cache-name>"
                exit 1
            fi
            watch_cache "$2"
            ;;
        "auth")
            auth_cachix
            ;;
        "create")
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}❌ Cache name required${NC}"
                echo "Usage: cachix-setup.sh create <cache-name>"
                exit 1
            fi
            create_cache "$2"
            ;;
        "list")
            list_caches
            ;;
        "status")
            show_status
            ;;
        "help"|"--help"|"-h"|*)
            show_help
            ;;
    esac
}

main "$@"