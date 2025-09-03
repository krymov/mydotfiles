{
  description = "Ultra-minimal Python project environment (assumes everything from dotfiles)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = {
          # Ultra-minimal shell - assumes ALL tools from main dotfiles
          default = pkgs.mkShell {
            # Only set environment, don't add any packages
            buildInputs = [ ];

            shellHook = ''
              echo "🐍 Python Project Environment (minimal)"
              echo "📋 Using tools from main dotfiles:"
              echo ""
              
              # Check availability of core tools
              if command -v python3 >/dev/null; then
                echo "✅ Python: $(python3 --version)"
              else
                echo "❌ python3 not found - install in main dotfiles"
                exit 1
              fi
              
              if command -v uv >/dev/null; then
                echo "✅ uv: $(uv --version)"
              else
                echo "❌ uv not found - install in main dotfiles"
                exit 1
              fi
              
              if command -v ruff >/dev/null; then
                echo "✅ ruff: $(ruff --version)"
              else
                echo "❌ ruff not found - install in main dotfiles"
                exit 1
              fi
              
              echo ""
              echo "� Project-specific dependency management:"
              echo "  uv init                    # Initialize project"
              echo "  uv add requests            # Add runtime dependency"
              echo "  uv add --dev pytest mypy  # Add dev dependencies"
              echo "  uv sync                    # Install all dependencies"
              echo ""
              echo "🚀 Development workflow:"
              echo "  uv run python src/main.py  # Run with dependencies"
              echo "  ruff check .               # Lint code"
              echo "  ruff format .              # Format code"
              echo "  uv run pytest             # Run tests"
              echo "  uv run mypy .              # Type check"
              echo ""
              echo "💡 All tools managed by uv - no Nix package conflicts!"

              # Set up project environment
              export PYTHONPATH="$PWD:$PYTHONPATH"
              export UV_CACHE_DIR="$PWD/.uv-cache"

              # Create uv cache directory
              mkdir -p .uv-cache
            '';
          };

          # Full shell - still minimal but adds project organization
          full = pkgs.mkShell {
            buildInputs = [ ];

            shellHook = ''
              echo "🐍 Python Project Environment (full workflow)"
              echo "📋 Using tools from main dotfiles:"
              echo ""
              
              # Check availability of core tools
              if command -v python3 >/dev/null; then
                echo "✅ Python: $(python3 --version)"
              else
                echo "❌ python3 not found - install in main dotfiles"
                exit 1
              fi
              
              if command -v uv >/dev/null; then
                echo "✅ uv: $(uv --version)"
              else
                echo "❌ uv not found - install in main dotfiles"
                exit 1
              fi
              
              if command -v ruff >/dev/null; then
                echo "✅ ruff: $(ruff --version)"
              else
                echo "❌ ruff not found - install in main dotfiles"
                exit 1
              fi
              
              echo ""
              echo "📦 Recommended project dependencies:"
              echo "  # Runtime"
              echo "  uv add requests fastapi uvicorn"
              echo "  uv add click rich typer"
              echo ""
              echo "  # Development"
              echo "  uv add --dev pytest mypy ruff"
              echo "  uv add --dev ipython jupyter"
              echo ""
              echo "� Full development workflow:"
              echo "  uv run python src/main.py  # Run application"
              echo "  uv run pytest             # Run tests"
              echo "  uv run mypy .              # Type checking"
              echo "  ruff check . && ruff format .  # Lint and format"
              echo "  uv run jupyter lab         # Interactive development"
              echo ""
              echo "🎯 Modern Python workflow - all deps via uv!"
              echo "   No more global package conflicts or long builds!"

              # Set up project environment
              export PYTHONPATH="$PWD:$PYTHONPATH"
              export UV_CACHE_DIR="$PWD/.uv-cache"

              # Create uv cache directory
              mkdir -p .uv-cache
            '';
          };
        };
      });
}