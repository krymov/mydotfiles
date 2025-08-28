{
  description = "Go development environment";

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
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Go toolchain
            go
            gopls
            go-tools
            golangci-lint
            delve
            
            # Database tools (commonly used with Go)
            postgresql
            redis
            
            # Development utilities
            git
            curl
            jq
            
            # Optional: Docker for containerization
            # docker
            # docker-compose
          ];

          shellHook = ''
            echo "🐹 Go development environment loaded!"
            echo "Go version: $(go version)"
            echo ""
            echo "Available tools:"
            echo "  go         - Go compiler"
            echo "  gopls      - Go Language Server"
            echo "  golangci-lint - Go linter"
            echo "  delve      - Go debugger"
            echo ""
            
            # Set up Go environment
            export GOPATH="$PWD/.go"
            export GOBIN="$GOPATH/bin"
            export PATH="$GOBIN:$PATH"
            
            # Create necessary directories
            mkdir -p "$GOPATH/bin"
            mkdir -p "$GOPATH/pkg"
            mkdir -p "$GOPATH/src"
            
            echo "GOPATH set to: $GOPATH"
            echo "GOBIN set to: $GOBIN"
          '';
        };
      });
}