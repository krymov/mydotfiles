# Nix packages for cross-platform development
# This file defines all the packages that should be available in your environment

{ pkgs ? import <nixpkgs> {} }:

let
  # Core development tools
  corePackages = with pkgs; [
    # Shell and terminal
    zsh
    tmux
    
    # File management
    stow
    tree
    
    # Text processing and search
    ripgrep
    fd
    fzf
    bat
    eza
    
    # Development tools
    git
    lazygit
    gh
    direnv
    
    # System utilities
    curl
    wget
    htop
    
    # Editors
    neovim
  ];

  # Platform-specific packages
  platformPackages = with pkgs; [
    # Add platform-specific packages here
  ] ++ (if pkgs.stdenv.isLinux then [
    # Linux-specific packages
    kitty
    xclip
  ] else [
    # macOS-specific packages (can be empty if using Homebrew)
  ]);

  # Optional development packages (uncomment as needed)
  devPackages = with pkgs; [
    # Python development
    # python3
    # python3Packages.pip
    # python3Packages.virtualenv
    
    # Node.js development
    # nodejs
    # nodePackages.npm
    # nodePackages.yarn
    
    # Rust development
    # rustup
    
    # Go development
    # go
    
    # Docker and containers
    # docker
    # docker-compose
    
    # Kubernetes tools
    # kubectl
    # kubectx
    # stern
    
    # Cloud tools
    # awscli2
    # google-cloud-sdk
    # terraform
    
    # Database tools
    # postgresql
    # redis
    # sqlite
  ];

in
  corePackages ++ platformPackages ++ devPackages