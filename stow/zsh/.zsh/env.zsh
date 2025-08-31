# Environment variables for cross-platform compatibility

# Locale settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Default applications
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="nvim +Man!"

# Color support
export TERM="xterm-256color"
export COLORTERM="truecolor"

# Less configuration
export LESS="-R"
export LESSOPEN="|bat --color=always %s 2>/dev/null || cat %s"

# History settings (additional to what's in .zshrc)
export HISTCONTROL="ignoreboth:erasedups"

# Development environment
export NODE_ENV="development"

# GPG TTY (for git signing)
export GPG_TTY=$(tty)

# Platform-specific environment variables
case "$PLATFORM" in
  "macos")
    # macOS specific
    export BROWSER="open"
    # Homebrew
    if [[ -d "/opt/homebrew" ]]; then
      export HOMEBREW_PREFIX="/opt/homebrew"
      export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
      export HOMEBREW_REPOSITORY="/opt/homebrew"
      export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
      export MANPATH="/opt/homebrew/share/man:$MANPATH"
      export INFOPATH="/opt/homebrew/share/info:$INFOPATH"
    fi
    ;;
  "nixos"|"linux")
    # Linux specific
    export BROWSER="firefox"
    # Enable Wayland support for some apps
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export GDK_BACKEND=wayland
    ;;
esac

# Language-specific environments
# Python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1

# Rust
if [[ -d "$HOME/.cargo" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Go
if command -v go >/dev/null; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

# Node.js
if [[ -d "$HOME/.npm-global" ]]; then
  export PATH="$HOME/.npm-global/bin:$PATH"
fi

# Nix
if [[ -d "/nix" ]]; then
  export NIX_PATH="nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs"
fi

# Docker
if command -v docker >/dev/null; then
  export DOCKER_BUILDKIT=1
  export COMPOSE_DOCKER_CLI_BUILD=1
fi

# Cloud CLI environment variables
# Google Cloud SDK
if command -v gcloud >/dev/null; then
  # Use application default credentials
  export GOOGLE_APPLICATION_CREDENTIALS=""
  # Enable gcloud beta components
  export CLOUDSDK_PYTHON_SITEPACKAGES=1
  # Suppress update check
  export CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true
fi

# AWS CLI
if command -v aws >/dev/null; then
  # Use AWS CLI v2 pager
  export AWS_PAGER=""
  # Enable CLI auto-prompt
  export AWS_CLI_AUTO_PROMPT=on-partial
  # Default output format
  export AWS_DEFAULT_OUTPUT=table
fi

# Kubernetes
if command -v kubectl >/dev/null; then
  # Disable kubectl auto-update check
  export KUBECTL_EXTERNAL_DIFF=""
  # Enable kubectl plugins discovery
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# Terraform
if command -v terraform >/dev/null; then
  # Disable Terraform telemetry
  export CHECKPOINT_DISABLE=1
  # Enable detailed logging for debugging (commented out by default)
  # export TF_LOG=DEBUG
fi

# FZF configuration (additional to what's in .zshrc)
export FZF_COMPLETION_TRIGGER='**'

# Bat configuration
if command -v bat >/dev/null; then
  export BAT_THEME="TwoDark"
  export BAT_STYLE="numbers,changes,header"
fi

# Ripgrep configuration
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
