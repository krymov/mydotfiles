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

DOTFILES_DIR="$HOME/.dotfiles"

show_help() {
    echo "Usage: $0 <LANGUAGE> [PROJECT_NAME]"
    echo ""
    echo "Set up a new development environment with direnv and flakes"
    echo ""
    echo "Languages:"
    echo "  go         Go development environment"
    echo "  python     Python development environment"
    echo "  nodejs     Node.js/JavaScript development environment"
    echo "  rust       Rust development environment"
    echo ""
    echo "Examples:"
    echo "  $0 go myapp              # Create Go project in ./myapp"
    echo "  $0 python               # Set up Python env in current directory"
    echo "  $0 nodejs my-web-app    # Create Node.js project in ./my-web-app"
}

setup_environment() {
    local language="$1"
    local project_name="${2:-}"
    local target_dir="."
    
    # If project name provided, create directory
    if [[ -n "$project_name" ]]; then
        target_dir="$project_name"
        mkdir -p "$target_dir"
        log_info "Created project directory: $target_dir"
    fi
    
    cd "$target_dir"
    
    # Check if flake exists
    local flake_path="$DOTFILES_DIR/flakes/$language"
    if [[ ! -f "$flake_path/flake.nix" ]]; then
        log_error "Flake for $language not found at $flake_path"
        return 1
    fi
    
    # Copy .envrc
    if [[ -f ".envrc" ]]; then
        log_warning "Found existing .envrc, backing up to .envrc.backup"
        mv .envrc .envrc.backup
    fi
    
    cp "$flake_path/.envrc" .envrc
    log_success "Created .envrc for $language"
    
    # Language-specific setup
    case "$language" in
        "go")
            if [[ -n "$project_name" ]]; then
                log_info "Initializing Go module..."
                echo "module $project_name" > go.mod
                echo 'go 1.21' >> go.mod
                echo "" >> go.mod
                
                # Create main.go
                cat > main.go << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
EOF
                log_success "Created go.mod and main.go"
            fi
            ;;
        "python")
            # Create basic Python project structure
            cat > requirements.txt << 'EOF'
# Add your Python dependencies here
# requests
# fastapi
# django
EOF
            
            if [[ -n "$project_name" ]]; then
                mkdir -p src tests
                touch src/__init__.py
                touch tests/__init__.py
                
                cat > src/main.py << 'EOF'
#!/usr/bin/env python3
"""Main module for the application."""

def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
EOF
                log_success "Created Python project structure"
            fi
            ;;
        "nodejs")
            if [[ -n "$project_name" ]]; then
                log_info "Initializing npm project..."
                npm init -y > /dev/null
                
                # Update package.json with project name
                if command -v jq >/dev/null; then
                    jq --arg name "$project_name" '.name = $name' package.json > package.json.tmp && mv package.json.tmp package.json
                fi
                
                # Create basic structure
                mkdir -p src
                cat > src/index.js << 'EOF'
console.log("Hello, World!");
EOF
                log_success "Created Node.js project with package.json"
            fi
            ;;
        "rust")
            if [[ -n "$project_name" ]]; then
                log_info "Initializing Cargo project..."
                # We'll use the flake environment for this
                echo "Run 'direnv allow' first, then 'cargo init' to initialize the Rust project"
            fi
            ;;
    esac
    
    # Allow direnv
    log_info "Allowing direnv..."
    direnv allow
    
    log_success "Development environment setup complete!"
    echo ""
    log_info "Next steps:"
    echo "  1. The environment will load automatically when you cd into this directory"
    echo "  2. Edit .envrc to add project-specific environment variables"
    case "$language" in
        "go")
            echo "  3. Run 'go run main.go' to test the setup"
            ;;
        "python")
            echo "  3. Create a virtual environment: python -m venv .venv"
            echo "  4. Activate it: source .venv/bin/activate"
            echo "  5. Install dependencies: pip install -r requirements.txt"
            ;;
        "nodejs")
            echo "  3. Install dependencies: npm install"
            echo "  4. Run the app: node src/index.js"
            ;;
        "rust")
            echo "  3. Initialize Cargo project: cargo init"
            echo "  4. Build and run: cargo run"
            ;;
    esac
}

# Parse arguments
case "${1:-help}" in
    go|python|nodejs|rust)
        setup_environment "$1" "${2:-}"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_error "Unknown language: ${1:-}"
        echo ""
        show_help
        exit 1
        ;;
esac