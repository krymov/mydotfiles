# Development shell for dotfiles environment
# Run `nix-shell` in this directory to enter the environment
# Usage:
#   nix-shell                              # development environment (default)
#   nix-shell --arg environment '"server"' # minimal server environment
#   nix-shell --arg environment '"minimal"' # minimal environment

{ pkgs ? import <nixpkgs> {}, environment ? "development" }:

let
  packages = import ./packages.nix { inherit pkgs environment; };
  envName = if environment == "server" then "Server"
           else if environment == "minimal" then "Minimal"
           else "Development";
in

pkgs.mkShell {
  buildInputs = packages;

  shellHook = ''
    echo "🚀 Dotfiles ${envName} environment loaded!"
    ${if environment == "development" then ''
    echo "📊 Data Processing Tools Available:"
    echo "  CSV/TSV: qsv, tv, mlr, csvkit, csvtk, visidata, daff, xan"
    echo "  JSON: jq, gojq, yq, dasel, fx, jo, jc"
    echo "  SQL: duckdb, sqlite, sqlite-utils"
    echo "  Analysis: visidata, sc-im, gnuplot"
    echo "  Pipelines: ag, rg, fd, bat, delta, sd, choose, datamash"
    echo "  Utils: parallel, pv, hyperfine, moreutils"
    echo ""
    '' else if environment == "server" then ''
    echo "🖥️  Server Environment - Essential tools only"
    echo "  Core: zsh, tmux, git, neovim, jq, yq"
    echo "  Search: ripgrep, fd, fzf, bat"
    echo "  Utils: curl, wget, htop, tree"
    echo ""
    '' else ''
    echo "⚡ Minimal Environment"
    echo "  Core: zsh, tmux, git, neovim, jq, yq"
    echo "  Search: ripgrep, fd, fzf, bat"
    echo ""
    ''}
    echo "Environment: ${environment}"
    echo "To switch environments:"
    echo "  nix-shell --arg environment '\"development\"'  # Full data tools"
    echo "  nix-shell --arg environment '\"server\"'       # Server minimal"
    echo "  nix-shell --arg environment '\"minimal\"'      # Basic minimal"
    echo ""
    echo "To update packages: ./update.sh --packages"
    echo ""
  '';
}
