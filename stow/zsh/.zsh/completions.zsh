# Enhanced completions for cross-platform tools

# Initialize completion system
autoload -Uz compinit
# Only run compinit if needed (for performance)
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Create cache directory if it doesn't exist
[[ ! -d ~/.zsh/cache ]] && mkdir -p ~/.zsh/cache
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# Kill command completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Enable completion for aliases
setopt complete_aliases

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Fuzzy matching of completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore completion for commands we don't have
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Docker completion
if command -v docker >/dev/null; then
  # Docker completion
  if [[ -f "$HOME/.nix-profile/share/zsh/site-functions/_docker" ]]; then
    autoload -U "$HOME/.nix-profile/share/zsh/site-functions/_docker"
  fi
fi

# Kubectl completion
if command -v kubectl >/dev/null; then
  source <(kubectl completion zsh)
  # Enable completion for k alias
  compdef k=kubectl
fi

# Google Cloud completion
if command -v gcloud >/dev/null; then
  # Source gcloud completion if available
  if [[ -f "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"
  elif [[ -f "/usr/share/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "/usr/share/google-cloud-sdk/completion.zsh.inc"
  elif [[ -f "$HOME/.nix-profile/share/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$HOME/.nix-profile/share/google-cloud-sdk/completion.zsh.inc"
  fi
fi

# AWS CLI completion
if command -v aws >/dev/null; then
  # AWS CLI v2 completion
  if command -v aws_completer >/dev/null; then
    autoload -U bashcompinit && bashcompinit
    complete -C aws_completer aws
  fi
fi

# Docker completion
if command -v docker >/dev/null; then
  # Docker completion for macOS (Homebrew)
  if [[ -f "/opt/homebrew/share/zsh/site-functions/_docker" ]]; then
    autoload -U "/opt/homebrew/share/zsh/site-functions/_docker"
  # Docker completion for Linux/NixOS
  elif [[ -f "$HOME/.nix-profile/share/zsh/site-functions/_docker" ]]; then
    autoload -U "$HOME/.nix-profile/share/zsh/site-functions/_docker"
  elif [[ -f "/usr/share/zsh/vendor-completions/_docker" ]]; then
    autoload -U "/usr/share/zsh/vendor-completions/_docker"
  fi
fi

# Terraform completion
if command -v terraform >/dev/null; then
  terraform -install-autocomplete 2>/dev/null || true
fi

# Helm completion
if command -v helm >/dev/null; then
  source <(helm completion zsh)
fi

# Nix completion
if command -v nix >/dev/null; then
  # Enable nix completion if available
  if [[ -f "$HOME/.nix-profile/share/zsh/site-functions/_nix" ]]; then
    autoload -U "$HOME/.nix-profile/share/zsh/site-functions/_nix"
  fi
fi

# Tmux completion
if command -v tmux >/dev/null; then
  # Custom tmux session completion
  _tmux_sessions() {
    local sessions
    sessions=($(tmux list-sessions -F '#S' 2>/dev/null))
    _describe 'sessions' sessions
  }

  # Add completion for our tmux aliases
  compdef _tmux_sessions ta
  compdef _tmux_sessions tk
fi

# Custom completions for our functions
compdef '_path_files -/' mkcd  # Directory completion for mkcd
compdef '_files' extract       # File completion for extract

# SSH host completion from ~/.ssh/config
if [[ -f ~/.ssh/config ]]; then
  _ssh_config_hosts() {
    if [[ -r ~/.ssh/config ]]; then
      hosts=($(awk '/^Host [^*]/ {print $2}' ~/.ssh/config))
      _describe 'hosts' hosts
    fi
  }
  compdef _ssh_config_hosts ssh
fi
