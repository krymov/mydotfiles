# Enhanced plugin configuration for maximum stability and reliability

# Plugin directory
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

# Function to install plugin if not present (used for initial setup)
# Note: Plugins are now included in the dotfiles repo, so this mainly serves
# as a fallback for missing plugins or when setting up on a new machine
install_plugin() {
  local plugin_url="$1"
  local plugin_name="$(basename "$plugin_url")"
  local plugin_dir="$ZSH_PLUGINS_DIR/$plugin_name"

  if [[ ! -d "$plugin_dir" ]]; then
    echo "Installing $plugin_name..."
    git clone --depth 1 --quiet "$plugin_url" "$plugin_dir" 2>/dev/null || {
      echo "Failed to install $plugin_name"
      return 1
    }
    # Remove .git directory to avoid submodule issues
    rm -rf "$plugin_dir/.git"
  fi
}

# Install essential plugins if git is available
if command -v git >/dev/null 2>&1; then
  install_plugin "https://github.com/zsh-users/zsh-autosuggestions"
  install_plugin "https://github.com/zsh-users/zsh-syntax-highlighting"
  install_plugin "https://github.com/zsh-users/zsh-history-substring-search"

  # Load autosuggestions
  if [[ -f "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi

  # Load syntax highlighting (must be loaded last)
  if [[ -f "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi

  # Load history substring search
  if [[ -f "$ZSH_PLUGINS_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
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

  # Use standard FZF history widget instead of custom one
  # The standard fzf-history-widget is usually better at filtering
  # and doesn't interfere with vim/editor commands
fi

# History substring search configuration
if zle -la | grep -q "history-substring-search"; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down
fi

# Autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
