{ config, pkgs, ... }:

let
  # Import your existing package definitions
  # You can override the environment here: "development", "server", or "minimal"
  packages = import ./packages.nix {
    inherit pkgs;
    environment = "development";
  };

  # Get the current user from environment or default to "mark"
  username = builtins.getEnv "USER";
  homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs information about you and the paths it should manage
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is compatible with.
  # You should not change this value, even if you update Home Manager.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Install all packages from your packages.nix
  home.packages = packages;

  # Program-specific configurations
  # Many of these can eventually replace your stow configurations

  # Direnv integration (replaces manual sourcing)
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Git configuration
  # You can keep using stow for now, or migrate to this declarative approach
  programs.git = {
    enable = true;
    # Uncomment and configure these if you want to migrate from stow:
    # userName = "Your Name";
    # userEmail = "your.email@example.com";
    # extraConfig = {
    #   init.defaultBranch = "main";
    #   pull.rebase = true;
    # };
  };

  # Zsh configuration
  # Keep using stow for now, or gradually migrate shell config here
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # You can add shell aliases here or keep them in stow
    shellAliases = {
      # Add any global aliases you want managed by Nix
      ll = "eza -la";
      la = "eza -la";
      l = "eza -l";
      cat = "bat";
      grep = "rg";
      find = "fd";
    };

    # Keep your existing zsh config from stow
    initContent = ''
      # Source any existing zsh configuration from stow
      # This allows gradual migration
    '';
  };

  # Neovim configuration
  # Keep using stow for now, but you can migrate to Home Manager later
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # tmux configuration
  # Keep using stow for now
  programs.tmux = {
    enable = true;
    # You can add basic tmux config here or keep using stow
  };

  # Bat (cat replacement) configuration
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  # FZF configuration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  # Ripgrep configuration
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/*"
    ];
  };

  # Platform-specific configurations
  home.sessionVariables = {
    # Set environment variables
    EDITOR = "nvim";
    PAGER = "less";

    # Nix-specific variables
    NIX_PATH = "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
  } // (if pkgs.stdenv.isDarwin then {
    # macOS-specific environment variables
    HOMEBREW_NO_AUTO_UPDATE = "1";
  } else {
    # Linux-specific environment variables
  });

  # XDG configuration (mostly for Linux, but good to have)
  xdg.enable = true;

  # File associations and desktop entries (Linux only)
  xdg.mimeApps = if pkgs.stdenv.isLinux then {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "nvim.desktop" ];
      "application/json" = [ "nvim.desktop" ];
    };
  } else {};

  # Font configuration (optional, you might prefer system fonts)
  fonts.fontconfig.enable = true;

  # News about Home Manager changes (you can disable this)
  news.display = "show";
}
