# Enhanced .zshrc for cross-platform compatibility
# Works on macOS with Nix and NixOS

# Performance: measure startup time (uncomment to debug)
# zmodload zsh/zprof

# Shell options
setopt promptsubst autocd correct
setopt hist_ignore_all_dups share_history inc_append_history
setopt hist_verify hist_expire_dups_first
setopt extended_glob nomatch notify
setopt auto_pushd pushd_ignore_dups pushd_minus

# History configuration
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Platform detection and flags
case "$OSTYPE" in
  darwin*)
    export IS_MAC=1
    export PLATFORM="macos"
    ;;
  linux*)
    export IS_LINUX=1
    if command -v nixos-rebuild >/dev/null 2>&1; then
      export PLATFORM="nixos"
    else
      export PLATFORM="linux"
    fi
    ;;
  *)
    export PLATFORM="unknown"
    ;;
esac

# PATH management (keep it clean and predictable)
typeset -U path  # Remove duplicates
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.nix-profile/bin"
  "/nix/var/nix/profiles/default/bin"
  $path
)
export PATH

# Essential environment variables
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"
export BROWSER="firefox"

# Nix-specific environment (if using Nix on non-NixOS)
if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Create XDG directories if they don't exist
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"

# direnv (project-specific environments)
if command -v direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi

# fzf configuration
if command -v fzf >/dev/null; then
  # Use fd if available, otherwise fall back to find
  if command -v fd >/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" 2>/dev/null'
  fi
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

  # fzf options
  export FZF_DEFAULT_OPTS='
    --height 40%
    --reverse
    --border
    --preview "bat --style=numbers --color=always {} 2>/dev/null || cat {} 2>/dev/null || echo \"Binary file\""
    --preview-window=right:60%:wrap
  '
fi

# Load modular configuration files
for config_file in "$HOME/.zsh/"{env,aliases,functions,plugins,completions}.zsh; do
  [[ -r "$config_file" ]] && source "$config_file"
done

# Git-aware prompt setup
autoload -Uz colors vcs_info && colors
setopt PROMPT_SUBST

# Configure git info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' (%{$fg[red]%}%b%{$reset_color%})'
zstyle ':vcs_info:git:*' actionformats ' (%{$fg[red]%}%b%{$reset_color%}|%{$fg[yellow]%}%a%{$reset_color%})'

# Function to get git info
precmd() {
  vcs_info
}

# Clean, informative prompt
PS1='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg[green]%}%1~%{$reset_color%}${vcs_info_msg_0_} %# '

# Load local machine-specific configuration (not tracked in git)
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Performance measurement (uncomment the zmodload line at the top to use)
# zprof
