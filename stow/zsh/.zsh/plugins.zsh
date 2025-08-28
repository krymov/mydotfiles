# Minimal plugin configuration for maximum stability

# Only use znap if git is available and working
if command -v git >/dev/null 2>&1; then
  # Bootstrap znap if not present
  if [[ ! -f "$HOME/.znap/znap.zsh" ]]; then
    echo "Installing znap plugin manager..."
    if git clone --depth 1 --quiet https://github.com/marlonrichert/zsh-snap.git "$HOME/.znap" 2>/dev/null; then
      echo "znap installed successfully"
    else
      echo "Warning: znap installation failed, using minimal configuration"
    fi
  fi

  # Load znap and essential plugins only
  if [[ -f "$HOME/.znap/znap.zsh" ]]; then
    source "$HOME/.znap/znap.zsh"

    # Essential plugins only
    znap source zsh-users/zsh-autosuggestions 2>/dev/null || true
    znap source zsh-users/zsh-syntax-highlighting 2>/dev/null || true
  fi
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

# History substring search (if plugin is available)
if zle -la | grep -q "history-substring-search"; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down
fi
