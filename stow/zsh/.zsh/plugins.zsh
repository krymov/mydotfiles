# Lightweight plugin management with znap

# Bootstrap znap if not present
if [[ ! -f "$HOME/.znap/znap.zsh" ]]; then
  echo "Installing znap plugin manager..."
  mkdir -p "$HOME/.znap"
  if command -v curl >/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/marlonrichert/zsh-snap/main/install.zsh | zsh
  elif command -v wget >/dev/null; then
    wget -qO- https://raw.githubusercontent.com/marlonrichert/zsh-snap/main/install.zsh | zsh
  else
    echo "Error: curl or wget required to install znap"
    return 1
  fi
fi

# Only load znap if it was successfully installed
if [[ -f "$HOME/.znap/znap.zsh" ]]; then
  source "$HOME/.znap/znap.zsh"
  
  # Essential plugins (lazy-loaded for performance)
  znap source zsh-users/zsh-autosuggestions
  znap source zsh-users/zsh-completions
  znap source zsh-users/zsh-syntax-highlighting
  
  # Additional useful plugins
  znap source zsh-users/zsh-history-substring-search
  
  # Fast directory jumping
  znap source agkozak/zsh-z
  
  # Better completion system
  znap fpath _cmd zsh-users/zsh-completions src
  
else
  echo "Warning: znap not available, using minimal configuration"
fi

# FZF integration (if available)
if command -v fzf >/dev/null; then
  # Load fzf key bindings and completion
  if [[ -f "$HOME/.nix-profile/share/fzf/key-bindings.zsh" ]]; then
    source "$HOME/.nix-profile/share/fzf/key-bindings.zsh"
  fi
  if [[ -f "$HOME/.nix-profile/share/fzf/completion.zsh" ]]; then
    source "$HOME/.nix-profile/share/fzf/completion.zsh"
  fi
  
  # Custom FZF functions
  # Ctrl+R for command history with fzf
  __fzf_history__() {
    local selected
    selected=$(fc -rl 1 | fzf +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r -q "${LBUFFER//$/\\$}")
    if [[ -n "$selected" ]]; then
      LBUFFER=$(echo "$selected" | sed 's/^[[:space:]]*[0-9]*\*\?[[:space:]]*//')
    fi
    zle redisplay
  }
  zle -N __fzf_history__
  bindkey '^R' __fzf_history__
fi

# History substring search configuration
if zle -la | grep -q "history-substring-search"; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down
fi

# Autosuggestions configuration
if [[ -n "${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:-}" ]]; then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# Prompt setup
# Try pure prompt first, fall back to a simple custom prompt
if ! command -v pure >/dev/null && [[ -f "$HOME/.znap/znap.zsh" ]]; then
  znap source sindresorhus/pure
fi

autoload -Uz promptinit && promptinit

if command -v pure >/dev/null; then
  prompt pure
else
  # Fallback: simple but informative prompt
  setopt PROMPT_SUBST
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' formats ' (%b)'
  zstyle ':vcs_info:*' actionformats ' (%b|%a)'
  
  precmd() {
    vcs_info
  }
  
  # Simple two-line prompt
  PROMPT='%F{blue}%~%f%F{red}${vcs_info_msg_0_}%f
%F{green}❯%f '
  RPROMPT='%F{8}%T%f'
fi
