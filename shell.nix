# Development shell for dotfiles environment
# Run `nix-shell` in this directory to enter the environment

{ pkgs ? import <nixpkgs> {} }:

let
  packages = import ./packages.nix { inherit pkgs; };
in

pkgs.mkShell {
  buildInputs = packages;
  
  shellHook = ''
    echo "🚀 Dotfiles development environment loaded!"
    echo "Available packages:"
    echo "  Core: zsh, tmux, git, neovim, stow"
    echo "  Search: ripgrep, fd, fzf, bat, eza"
    echo "  Dev: lazygit, gh, direnv"
    echo "  Utils: curl, wget, htop, tree"
    echo ""
    echo "To update packages: ./update.sh --packages"
    echo "To install new packages: edit packages.nix"
    echo ""
  '';
}