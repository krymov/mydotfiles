{
  description = "Python development environment with uv and ruff";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Cachix configuration for faster builds
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python311;
        
        # Common tools for both minimal and full
        commonTools = with pkgs; [
          # Modern Python tooling
          python
          uv              # Fast Python package manager
          ruff            # Fast Python linter and formatter
          
          # Development utilities
          git
          curl
          jq
          cachix
        ];
        
        # Additional tools for full environment
        fullTools = with pkgs; [
          # Language servers and advanced tools
          python.pkgs.python-lsp-server
          python.pkgs.mypy
          python.pkgs.pytest
          python.pkgs.ipython
          
          # Popular libraries (commonly needed)
          python.pkgs.requests
          python.pkgs.click
          python.pkgs.rich
          python.pkgs.typer
          
          # Database tools
          sqlite
          
          # Additional utilities
          tree
          fd
          ripgrep
          bat
        ];
      in
      {
        devShells = {
          # Default minimal shell
          default = pkgs.mkShell {
            buildInputs = commonTools;
            
            shellHook = ''
              echo "🐍 Python Minimal Environment (uv + ruff)"
              echo "Python version: $(python --version)"
              echo "uv version: $(uv --version)"
              echo "ruff version: $(ruff --version)"
              echo ""
              echo "🚀 Modern Python tools:"
              echo "  uv         - Ultra-fast package manager"
              echo "  ruff       - Fast linter and formatter"
              echo ""
              echo "📦 Quick start:"
              echo "  uv init                    # Initialize project"
              echo "  uv add requests            # Add dependency"
              echo "  uv run python main.py      # Run with dependencies"
              echo "  ruff check .               # Lint code"
              echo "  ruff format .              # Format code"
              echo ""
              echo "💡 For full environment: nix develop .#full"
              
              # Set up project environment
              export PYTHONPATH="$PWD:$PYTHONPATH"
              export UV_CACHE_DIR="$PWD/.uv-cache"
              
              # Create uv cache directory
              mkdir -p .uv-cache
            '';
          };
          
          # Full development shell with additional tools
          full = pkgs.mkShell {
            buildInputs = commonTools ++ fullTools;
            
            shellHook = ''
              echo "🐍 Python Full Environment (uv + ruff + extras)"
              echo "Python version: $(python --version)"
              echo "uv version: $(uv --version)"
              echo "ruff version: $(ruff --version)"
              echo ""
              echo "🚀 Modern Python tools:"
              echo "  uv         - Ultra-fast package manager"
              echo "  ruff       - Fast linter and formatter"
              echo "  mypy       - Type checker"
              echo "  pytest     - Testing framework"
              echo "  ipython    - Enhanced interactive shell"
              echo ""
              echo "📦 Available libraries:"
              echo "  requests   - HTTP library"
              echo "  click      - CLI framework"
              echo "  rich       - Rich text and beautiful formatting"
              echo "  typer      - Modern CLI framework"
              echo ""
              echo "🔧 Additional tools:"
              echo "  sqlite     - SQLite database"
              echo "  tree, fd, rg, bat - File utilities"
              echo ""
              echo "📦 Quick start:"
              echo "  uv init                    # Initialize project"
              echo "  uv add fastapi uvicorn     # Add web framework"
              echo "  uv add pytest ruff mypy    # Add dev tools"
              echo "  uv run python main.py      # Run with dependencies"
              echo "  ruff check . && ruff format .  # Lint and format"
              echo "  mypy .                     # Type check"
              echo "  pytest                     # Run tests"
              echo ""
              
              # Set up project environment
              export PYTHONPATH="$PWD:$PYTHONPATH"
              export UV_CACHE_DIR="$PWD/.uv-cache"
              
              # Create uv cache directory
              mkdir -p .uv-cache
              
              echo "🎯 Pro tip: Add dependencies with uv instead of pip:"
              echo "  uv add numpy pandas        # Runtime dependencies"
              echo "  uv add --dev pytest ruff   # Development dependencies"
            '';
          };
        };
      });
}