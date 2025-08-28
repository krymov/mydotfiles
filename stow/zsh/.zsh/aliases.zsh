# Dotfiles management
alias dotfiles='cd ~/.dotfiles'
alias dotup='~/.dotfiles/update.sh'
alias dotup-all='~/.dotfiles/update.sh --all'
alias dotup-pkg='~/.dotfiles/update.sh --packages'
alias bootstrap='~/.dotfiles/bootstrap.sh'

# Enhanced aliases for cross-platform compatibility

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# List files (eza if available, otherwise ls)
if command -v eza >/dev/null; then
  alias ls='eza'
  alias ll='eza -lh --git'
  alias la='eza -lah --git'
  alias lt='eza --tree'
  alias l='eza -1'
else
  alias ll='ls -lh'
  alias la='ls -lah'
  alias l='ls -1'
fi

# Better cat with syntax highlighting
if command -v bat >/dev/null; then
  alias cat='bat --paging=never'
  alias less='bat'
else
  alias cat='cat'
fi

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# Lazygit
if command -v lazygit >/dev/null; then
  alias lg='lazygit'
fi

# Kubernetes (if used)
if command -v kubectl >/dev/null; then
  alias k='kubectl'
fi

# tmux shortcuts
alias t='tmux'
alias ta='tmux attach'
alias tn='tmux new-session'
alias tl='tmux list-sessions'

# System shortcuts
alias h='history'
alias j='jobs -l'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Platform-specific aliases
case "$PLATFORM" in
  "macos")
    alias o='open'
    alias pbcopy='pbcopy'
    alias pbpaste='pbpaste'
    # Homebrew shortcuts if available
    if command -v brew >/dev/null; then
      alias brewup='brew update && brew upgrade'
      alias brewclean='brew cleanup'
    fi
    ;;
  "nixos"|"linux")
    alias o='xdg-open'
    if command -v xclip >/dev/null; then
      alias pbcopy='xclip -selection clipboard'
      alias pbpaste='xclip -selection clipboard -o'
    fi
    # NixOS specific
    if [[ "$PLATFORM" == "nixos" ]]; then
      alias nrs='sudo nixos-rebuild switch'
      alias nrt='sudo nixos-rebuild test'
      alias nrb='sudo nixos-rebuild build'
    fi
    ;;
esac

# Nix package manager shortcuts
if command -v nix-env >/dev/null; then
  alias nixup='nix-env -u'
  alias nixsearch='nix-env -qaP'
  alias nixinstall='nix-env -iA'
  alias nixuninstall='nix-env -e'
  alias nixlist='nix-env -q'
fi

# Docker shortcuts (if Docker is available)
if command -v docker >/dev/null; then
  alias d='docker'
  alias dc='docker-compose'
  alias dps='docker ps'
  alias dpa='docker ps -a'
  alias di='docker images'
  alias drmf='docker system prune -f'
fi

# Network and system
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias wget='wget -c'  # Resume downloads by default

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Quick directory jumps
alias dev='cd ~/Development'
alias dl='cd ~/Downloads'
alias docs='cd ~/Documents'

# Edit configs quickly
alias vimrc='$EDITOR ~/.config/nvim/init.lua'
alias zshrc='$EDITOR ~/.zshrc'
alias tmuxrc='$EDITOR ~/.tmux.conf'
