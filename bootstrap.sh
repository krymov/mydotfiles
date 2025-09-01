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

# Environment detection and selection
detect_environment() {
    local env_type="development"  # default
    
    # Check command line arguments
    if [[ "${1:-}" == "--server" ]] || [[ "${1:-}" == "-s" ]]; then
        env_type="server"
    elif [[ "${1:-}" == "--minimal" ]] || [[ "${1:-}" == "-m" ]]; then
        env_type="minimal"
    elif [[ "${1:-}" == "--data" ]] || [[ "${1:-}" == "-d" ]]; then
        env_type="data"
    elif [[ "${1:-}" == "--development" ]] || [[ "${1:-}" == "--dev" ]]; then
        env_type="development"
    elif [[ -n "${SSH_CONNECTION:-}" ]] || [[ -n "${SSH_CLIENT:-}" ]] || [[ -n "${SSH_TTY:-}" ]]; then
        # Auto-detect server environment via SSH
        log_info "SSH connection detected, suggesting server environment"
        echo "Environment options:"
        echo "  1) Server (minimal, essential tools only)"
        echo "  2) Development (full data science stack)"
        echo "  3) Minimal (basic tools)"
        read -p "Choose environment [1-3, default=1]: " choice
        case "${choice:-1}" in
            1) env_type="server" ;;
            2) env_type="development" ;;
            3) env_type="minimal" ;;
            *) env_type="server" ;;
        esac
    fi
    
    echo "$env_type"
}

# Show help
show_help() {
    echo "🚀 Dotfiles Bootstrap Script"
    echo ""
    echo "Usage: $0 [ENVIRONMENT_TYPE]"
    echo ""
    echo "Environment Types:"
    echo "  (none)              Auto-detect or use development (default)"
    echo "  --development, --dev Full development environment with data science tools"
    echo "  --server, -s        Minimal server environment (essential tools only)"
    echo "  --minimal, -m       Basic minimal environment"
    echo "  --data, -d          Dedicated data analysis environment"
    echo ""
    echo "Examples:"
    echo "  $0                  # Auto-detect environment"
    echo "  $0 --server         # Force server environment"
    echo "  $0 --development    # Full development environment"
    echo ""
    exit 0
}

# Parse arguments first
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    show_help
fi

# Detect environment
ENVIRONMENT=$(detect_environment "$@")

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
log_info "🚀 Starting bootstrap for $ENVIRONMENT environment on $PLATFORM"

# Check if Nix is available
if ! command -v nix-env >/dev/null 2>&1; then
    log_error "Nix package manager not found. Installing Nix..."
    
    if [[ "$PLATFORM" == "macos" ]]; then
        # Use Determinate Systems installer for better macOS support
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    else
        # Standard installer for Linux
        curl -L https://nixos.org/nix/install | sh -s -- --daemon
    fi
    
    # Source nix environment
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
    
    log_success "Nix installed successfully"
fi

# Setup environment using our packages.nix
log_info "Setting up $ENVIRONMENT environment packages..."
nix-shell --arg environment "\"$ENVIRONMENT\"" --run "echo 'Environment packages ready!'" || {
    log_error "Failed to setup environment packages"
    exit 1
}

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
backup_config "$HOME/.ssh/config"

# Stow dotfiles
log_info "Symlinking dotfiles with Stow..."

# Environment-specific stow modules
case "$ENVIRONMENT" in
    "development"|"data")
        STOW_MODULES="zsh tmux git nvim ssh"
        if [[ "$PLATFORM" == "nixos" || "$PLATFORM" == "linux" ]]; then
            STOW_MODULES="$STOW_MODULES kitty"
        fi
        ;;
    "server")
        STOW_MODULES="zsh tmux git ssh"
        ;;
    "minimal")
        STOW_MODULES="zsh git ssh"
        ;;
esac

for module in $STOW_MODULES; do
    if [[ -d "stow/$module" ]]; then
        if [[ "$module" == "nvim" ]]; then
            # Check if nvim is already properly symlinked
            if [[ -L "$HOME/.config/nvim" ]] && [[ "$(readlink "$HOME/.config/nvim")" == *"stow/nvim/.config/nvim"* ]]; then
                log_info "Nvim already symlinked correctly, skipping stow"
            else
                log_info "Stowing $module..."
                stow -d stow --target="$HOME" "$module" || log_error "Failed to stow $module"
            fi
        else
            log_info "Stowing $module..."
            stow -d stow --target="$HOME" "$module" || log_error "Failed to stow $module"
        fi
    else
        log_warning "Module $module not found, skipping..."
    fi
done

# Ensure nvim configuration is properly set up
if [[ -L "$HOME/.config/nvim" ]] && [[ "$(readlink "$HOME/.config/nvim")" == *"stow/nvim/.config/nvim"* ]]; then
    log_success "Neovim configuration is properly symlinked"
elif [[ ! -d "$HOME/.config/nvim" ]]; then
    log_info "Installing AstroNvim user template..."
    # Install AstroNvim user template (v4 method)
    git clone --depth 1 https://github.com/AstroNvim/user_example ~/.config/nvim
    log_success "AstroNvim user template installed"

    # Copy our user configuration
    if [[ -d "stow/nvim/.config/nvim" ]]; then
        log_info "Installing user configuration..."
        cp -r stow/nvim/.config/nvim/* ~/.config/nvim/
        log_success "User configuration installed"
    fi
else
    log_info "Neovim config exists but not symlinked - manual setup may be needed"
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
log_info "🎯 Environment: $ENVIRONMENT"

case "$ENVIRONMENT" in
    "development")
        echo "📊 Data Science Tools Available:"
        echo "  • CSV/TSV: qsv, tv, mlr, csvkit, csvtk, visidata"
        echo "  • JSON: jq, gojq, yq, dasel, fx, jo, jc"
        echo "  • SQL: duckdb, sqlite, sqlite-utils"
        echo "  • Python: pandas, polars, ydata-profiling, great-expectations"
        echo "  • Visualization: gnuplot, matplotlib, seaborn, plotly"
        echo "  • Pipelines: parallel, pv, hyperfine"
        echo ""
        echo "🧪 Try these commands:"
        echo "  echo 'name,age\\nAlice,30\\nBob,25' > test.csv"
        echo "  qsv stats test.csv"
        echo "  tv test.csv"
        echo "  duckdb -c \"SELECT * FROM 'test.csv'\""
        echo "  python -c \"import polars as pl; print(pl.__version__)\""
        ;;
    "data")
        echo "📊 Dedicated Data Analysis Environment:"
        echo "  Use: ./dev-env.sh data"
        echo "  Or: nix develop ~/.dotfiles/flakes/data"
        echo "  Copy to projects: cp ~/.dotfiles/flakes/data/.envrc ."
        ;;
    "server")
        echo "🖥️  Server Tools Available:"
        echo "  • Core: jq, yq, ripgrep, fd, bat, git, neovim"
        echo "  • Shell: zsh, tmux with optimized configs"
        echo "  • Minimal footprint for production environments"
        ;;
    "minimal")
        echo "⚡ Minimal Environment:"
        echo "  • Essential tools only: git, neovim, basic shell utilities"
        echo "  • Optimized for resource-constrained systems"
        ;;
esac

echo ""
log_info "Next steps:"
echo "  1. Restart shell: exec zsh"
echo "  2. Enter environment: nix-shell --arg environment '\"$ENVIRONMENT\"'"
echo "  3. Quick switch: ./dev-env.sh $ENVIRONMENT"

if [[ "$ENVIRONMENT" == "development" || "$ENVIRONMENT" == "data" ]]; then
    echo "  4. Read EDA guide: cat guides/EDA_WORKFLOWS.md"
fi
echo
log_info "SSH Key Setup (if not already done):"
echo "  If you need to set up SSH keys for GitHub:"
echo "  1. Generate key: ssh-keygen -t ed25519 -C \"your@email.com\" -f ~/.ssh/id_ed25519"
echo "  2. Add to agent: ssh-add ~/.ssh/id_ed25519"
echo "  3. Add to GitHub: gh ssh-key add ~/.ssh/id_ed25519.pub --title \"YourMachine-\$(date +%Y%m%d)\""
echo "  4. Test: ssh -T git@github.com"
echo
log_info "Your old configs have been backed up with .backup extension if they existed."
log_success "Bootstrap completed successfully! 🎉"
