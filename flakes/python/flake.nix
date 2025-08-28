{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python311;
        pythonPackages = python.pkgs;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Python interpreter and tools
            python
            pythonPackages.pip
            pythonPackages.setuptools
            pythonPackages.wheel
            pythonPackages.virtualenv
            pythonPackages.poetry
            
            # Python language server and tools
            pythonPackages.python-lsp-server
            pythonPackages.black
            pythonPackages.isort
            pythonPackages.flake8
            pythonPackages.mypy
            pythonPackages.pytest
            
            # Common Python packages
            pythonPackages.requests
            pythonPackages.numpy
            pythonPackages.pandas
            # pythonPackages.flask
            # pythonPackages.fastapi
            # pythonPackages.django
            
            # Development utilities
            git
            curl
            jq
          ];

          shellHook = ''
            echo "🐍 Python development environment loaded!"
            echo "Python version: $(python --version)"
            echo ""
            echo "Available tools:"
            echo "  python     - Python interpreter"
            echo "  pip        - Package installer"
            echo "  poetry     - Dependency management"
            echo "  black      - Code formatter"
            echo "  isort      - Import sorter"
            echo "  flake8     - Linter"
            echo "  mypy       - Type checker"
            echo "  pytest     - Testing framework"
            echo ""
            
            # Set up Python environment
            export PYTHONPATH="$PWD:$PYTHONPATH"
            
            # Create virtual environment if it doesn't exist
            if [ ! -d ".venv" ]; then
              echo "Creating virtual environment..."
              python -m venv .venv
            fi
            
            echo "To activate virtual environment: source .venv/bin/activate"
            echo "To install dependencies: pip install -r requirements.txt"
          '';
        };
      });
}