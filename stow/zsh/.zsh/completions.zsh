# Enhanced completions for cross-platform tools

# Note: compinit is handled automatically by znap
# Only run compinit manually if znap is not available
if [[ ! -f "$HOME/.znap/znap.zsh" ]]; then
    autoload -Uz compinit
    compinit -u
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
  alias k=kubectl
  complete -F __start_kubectl k
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

# Create cache directory if it doesn't exist
[[ ! -d ~/.zsh/cache ]] && mkdir -p ~/.zsh/cache
