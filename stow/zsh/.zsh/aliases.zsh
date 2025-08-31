# Dotfiles management
alias dotfiles='cd ~/.dotfiles'
alias dotup='~/.dotfiles/update.sh'
alias dotup-all='~/.dotfiles/update.sh --all'
alias dotup-pkg='~/.dotfiles/update.sh --packages'
alias bootstrap='~/.dotfiles/bootstrap.sh'

# Development environment setup
alias dev-env='~/.dotfiles/dev-env.sh'
alias dev-go='~/.dotfiles/dev-env.sh go'
alias dev-python='~/.dotfiles/dev-env.sh python'
alias dev-nodejs='~/.dotfiles/dev-env.sh nodejs'
alias dev-rust='~/.dotfiles/dev-env.sh rust'

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
  alias kgp='kubectl get pods'
  alias kgs='kubectl get services'
  alias kgd='kubectl get deployments'
  alias kgn='kubectl get nodes'
  alias kga='kubectl get all'
  alias kdp='kubectl describe pod'
  alias kds='kubectl describe service'
  alias kdd='kubectl describe deployment'
  alias kdn='kubectl describe node'
  alias kaf='kubectl apply -f'
  alias kdf='kubectl delete -f'
  alias kcf='kubectl create -f'
  alias keti='kubectl exec -ti'
  alias kccc='kubectl config current-context'
  alias kcdc='kubectl config delete-context'
  alias kcsc='kubectl config set-context'
  alias kcuc='kubectl config use-context'
  alias kcci='kubectl cluster-info'
  alias kcgc='kubectl config get-contexts'
  alias kns='kubectl config set-context --current --namespace'
fi

# Google Cloud Platform (if used)
if command -v gcloud >/dev/null; then
  alias gc='gcloud'
  alias gce='gcloud compute'
  alias gcei='gcloud compute instances'
  alias gcel='gcloud compute instances list'
  alias gces='gcloud compute instances start'
  alias gcest='gcloud compute instances stop'
  alias gceip='gcloud compute addresses list'
  alias gcssh='gcloud compute ssh'
  alias gcp='gcloud config set project'
  alias gcpl='gcloud projects list'
  alias gcsl='gcloud config list'
  alias gcsc='gcloud config configurations list'
  alias gcsa='gcloud config configurations activate'
fi

# AWS CLI (if used)
if command -v aws >/dev/null; then
  alias awsp='export AWS_PROFILE'
  alias awspl='aws configure list-profiles'
  alias awssl='aws s3 ls'
  alias awsec2='aws ec2 describe-instances'
  alias awsiam='aws iam'
  alias awslogs='aws logs'
fi

# Docker shortcuts (if Docker is available)
if command -v docker >/dev/null; then
  alias d='docker'
  alias dc='docker-compose'
  alias dps='docker ps'
  alias dpa='docker ps -a'
  alias di='docker images'
  alias drmf='docker system prune -f'
  alias dlog='docker logs'
  alias dexec='docker exec -it'
  alias dbuild='docker build'
  alias dpull='docker pull'
  alias dpush='docker push'
  alias drun='docker run'
  alias dstop='docker stop'
  alias dstart='docker start'
  alias drm='docker rm'
  alias drmi='docker rmi'
fi

# Terraform (if used)
if command -v terraform >/dev/null; then
  alias tf='terraform'
  alias tfi='terraform init'
  alias tfp='terraform plan'
  alias tfa='terraform apply'
  alias tfd='terraform destroy'
  alias tfs='terraform show'
  alias tfv='terraform validate'
  alias tff='terraform fmt'
  alias tfw='terraform workspace'
  alias tfws='terraform workspace select'
  alias tfwl='terraform workspace list'
fi

# Helm (if used)
if command -v helm >/dev/null; then
  alias h='helm'
  alias hl='helm list'
  alias hi='helm install'
  alias hu='helm upgrade'
  alias hd='helm delete'
  alias hs='helm search'
  alias hr='helm repo'
  alias hrl='helm repo list'
  alias hru='helm repo update'
fi

# tmux aliases
alias t='tmux'
alias ta='tmux attach'
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

# VS Code aliases
if [[ -d "/Applications/Visual Studio Code - Insiders.app" ]]; then
  alias code-insiders='"/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code"'
  alias code='code-insiders'  # Use insiders as default code command
fi
