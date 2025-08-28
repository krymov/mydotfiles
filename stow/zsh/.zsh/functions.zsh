# Useful functions for cross-platform development

# Create and enter directory
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.xz)        unxz "$1"      ;;
      *.lzma)      unlzma "$1"    ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find file by name
ff() {
  if command -v fd >/dev/null; then
    fd -H -I "$1"
  else
    find . -iname "*$1*" 2>/dev/null
  fi
}

# Find in files
fif() {
  if command -v rg >/dev/null; then
    rg -i "$1"
  else
    grep -r -i "$1" .
  fi
}

# Change to git root directory
cdgit() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$git_root" ]]; then
    cd "$git_root"
  else
    echo "Not in a git repository"
    return 1
  fi
}

# Quick tmux session management
tn() {
  local session_name="${1:-$(basename "$PWD")}"
  tmux new-session -d -s "$session_name" 2>/dev/null || tmux attach-session -t "$session_name"
}

# Kill tmux session
tk() {
  local session_name="${1:-$(tmux display-message -p '#S')}"
  tmux kill-session -t "$session_name"
}

# Weather function
weather() {
  local location="${1:-}"
  curl "wttr.in/${location}?format=3"
}

# Create a backup of a file
backup() {
  if [[ -f "$1" ]]; then
    cp "$1" "${1}.backup-$(date +%Y%m%d-%H%M%S)"
    echo "Backup created: ${1}.backup-$(date +%Y%m%d-%H%M%S)"
  else
    echo "File '$1' does not exist"
    return 1
  fi
}

# Quick HTTP server
serve() {
  local port="${1:-8000}"
  if command -v python3 >/dev/null; then
    python3 -m http.server "$port"
  elif command -v python >/dev/null; then
    python -m SimpleHTTPServer "$port"
  else
    echo "Python not found"
    return 1
  fi
}

# Get public IP
myip() {
  curl -s https://ipinfo.io/ip
}

# Process management
psg() {
  ps aux | grep -v grep | grep -i "$1"
}

# Git helpers
gclean() {
  git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -n 1 git branch -d
}

# Quick note taking
note() {
  local note_file="$HOME/notes.md"
  if [[ $# -eq 0 ]]; then
    # Open notes file for editing
    $EDITOR "$note_file"
  else
    # Add a timestamped note
    echo "## $(date '+%Y-%m-%d %H:%M:%S')" >> "$note_file"
    echo "$*" >> "$note_file"
    echo "" >> "$note_file"
    echo "Note added to $note_file"
  fi
}

# System information
sysinfo() {
  echo "System Information:"
  echo "=================="
  echo "Hostname: $(hostname)"
  echo "Platform: $PLATFORM"
  echo "OS: $OSTYPE"
  echo "Shell: $SHELL"
  echo "Terminal: $TERM"
  echo "Editor: $EDITOR"
  uname -a
  
  if command -v nix-env >/dev/null; then
    echo ""
    echo "Nix Profile:"
    nix-env --version
  fi
}

# Directory size
dirsize() {
  du -sh "${1:-.}" | sort -hr
}

# Platform-specific functions
case "$PLATFORM" in
  "macos")
    # Quick Look preview
    ql() { qlmanage -p "$*" &>/dev/null; }
    
    # Spotlight search
    spotlight() { mdfind "kMDItemDisplayName == '*$1*'"; }
    ;;
  "nixos"|"linux")
    # Open file manager
    filemanager() {
      if command -v nautilus >/dev/null; then
        nautilus "${1:-.}" &
      elif command -v dolphin >/dev/null; then
        dolphin "${1:-.}" &
      elif command -v thunar >/dev/null; then
        thunar "${1:-.}" &
      else
        echo "No supported file manager found"
      fi
    }
    ;;
esac

# Load machine-specific functions if they exist
[[ -r "$HOME/.zsh/functions.local.zsh" ]] && source "$HOME/.zsh/functions.local.zsh"