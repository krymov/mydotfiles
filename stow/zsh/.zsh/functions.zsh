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

# Cloud and DevOps functions

# Kubernetes context switching with fuzzy finder
kctx() {
  if command -v kubectl >/dev/null && command -v fzf >/dev/null; then
    local context
    context=$(kubectl config get-contexts -o name | fzf --prompt="Select kubectl context: ")
    if [[ -n "$context" ]]; then
      kubectl config use-context "$context"
      echo "Switched to context: $context"
    fi
  else
    echo "kubectl and fzf are required for this function"
  fi
}

# Kubernetes namespace switching with fuzzy finder
knsf() {
  if command -v kubectl >/dev/null && command -v fzf >/dev/null; then
    local namespace
    namespace=$(kubectl get namespaces -o name | sed 's/namespace\///' | fzf --prompt="Select namespace: ")
    if [[ -n "$namespace" ]]; then
      kubectl config set-context --current --namespace="$namespace"
      echo "Switched to namespace: $namespace"
    fi
  else
    echo "kubectl and fzf are required for this function"
  fi
}

# Get pod logs with fuzzy selection
klogs() {
  if command -v kubectl >/dev/null && command -v fzf >/dev/null; then
    local pod
    pod=$(kubectl get pods -o name | sed 's/pod\///' | fzf --prompt="Select pod for logs: ")
    if [[ -n "$pod" ]]; then
      kubectl logs "$pod" "${@}"
    fi
  else
    echo "kubectl and fzf are required for this function"
  fi
}

# Execute into pod with fuzzy selection
kexec() {
  if command -v kubectl >/dev/null && command -v fzf >/dev/null; then
    local pod
    pod=$(kubectl get pods -o name | sed 's/pod\///' | fzf --prompt="Select pod to exec into: ")
    if [[ -n "$pod" ]]; then
      kubectl exec -it "$pod" -- "${@:-/bin/bash}"
    fi
  else
    echo "kubectl and fzf are required for this function"
  fi
}

# Google Cloud project switching with fuzzy finder
gcproj() {
  if command -v gcloud >/dev/null && command -v fzf >/dev/null; then
    local project
    project=$(gcloud projects list --format="value(projectId)" | fzf --prompt="Select GCP project: ")
    if [[ -n "$project" ]]; then
      gcloud config set project "$project"
      echo "Switched to project: $project"
    fi
  else
    echo "gcloud and fzf are required for this function"
  fi
}

# AWS profile switching with fuzzy finder
awsprof() {
  if command -v aws >/dev/null && command -v fzf >/dev/null; then
    local profile
    profile=$(aws configure list-profiles | fzf --prompt="Select AWS profile: ")
    if [[ -n "$profile" ]]; then
      export AWS_PROFILE="$profile"
      echo "Switched to AWS profile: $profile"
    fi
  else
    echo "aws and fzf are required for this function"
  fi
}

# Docker container management
dsh() {
  if command -v docker >/dev/null && command -v fzf >/dev/null; then
    local container
    container=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | tail -n +2 | fzf --prompt="Select container: " | awk '{print $1}')
    if [[ -n "$container" ]]; then
      docker exec -it "$container" "${@:-/bin/bash}"
    fi
  else
    echo "docker and fzf are required for this function"
  fi
}

# Docker logs with fuzzy selection
dlogs() {
  if command -v docker >/dev/null && command -v fzf >/dev/null; then
    local container
    container=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | tail -n +2 | fzf --prompt="Select container for logs: " | awk '{print $1}')
    if [[ -n "$container" ]]; then
      docker logs -f "$container" "${@}"
    fi
  else
    echo "docker and fzf are required for this function"
  fi
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

# Python environment management
py-env() {
    local env_type="${1:-status}"

    case "$env_type" in
        "minimal"|"min")
            echo "🐍 Switching to Python minimal environment"
            export PYTHON_ENV=minimal
            dr  # direnv reload
            ;;
        "full")
            echo "🐍 Switching to Python full environment"
            export PYTHON_ENV=full
            dr  # direnv reload
            ;;
        "status"|*)
            echo "🐍 Python Environment Status:"
            echo "Current: ${PYTHON_ENV:-minimal}"
            echo ""
            echo "Usage: py-env [minimal|full]"
            echo "  minimal - uv + ruff only"
            echo "  full    - uv + ruff + mypy + pytest + ipython + libraries"
            ;;
    esac
}

# Modern Python project helpers
py-new() {
    local project_name="$1"
    local env_type="${2:-minimal}"

    if [[ -z "$project_name" ]]; then
        echo "Usage: py-new <project-name> [minimal|full]"
        echo "  minimal - Basic uv + ruff setup (default)"
        echo "  full    - Full development environment"
        return 1
    fi

    if [[ "$env_type" == "full" ]]; then
        PYTHON_ENV=full project-init python "$project_name"
    else
        project-init python "$project_name"
    fi
}

# Quick uv project setup in current directory
py-here() {
    local env_type="${1:-minimal}"

    if [[ -f "pyproject.toml" ]]; then
        echo "⚠️  pyproject.toml already exists"
        return 1
    fi

    echo "🐍 Setting up Python project in current directory"

    if [[ "$env_type" == "full" ]]; then
        export PYTHON_ENV=full
        echo 'export PYTHON_ENV=full' > .env
    fi

    # Create .envrc
    cat > .envrc << 'EOF'
use flake ~/.dotfiles/flakes/python
dotenv_if_exists
PATH_add bin
PATH_add scripts

if [[ "${PYTHON_ENV:-minimal}" == "full" ]]; then
  echo "Using Python full environment"
else
  echo "Using Python minimal environment"
fi

alias uv-add="uv add"
alias uv-run="uv run"
alias lint="ruff check ."
alias format="ruff format ."
alias check="ruff check . && ruff format --check ."
EOF

    # Initialize uv project
    uv init --no-readme
    direnv allow

    echo "✅ Python environment ready!"
    echo "🚀 Next steps:"
    echo "  uv add requests            # Add dependencies"
    echo "  uv run python main.py      # Run code"
    echo "  ruff check . && ruff format .  # Lint and format"
}
