{
  description = "Node.js/JavaScript development environment";

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
            # Node.js and package managers
            nodejs_20
            nodePackages.npm
            nodePackages.yarn
            nodePackages.pnpm
            
            # Language servers and tools
            nodePackages.typescript-language-server
            nodePackages.eslint
            nodePackages.prettier
            nodePackages.typescript
            
            # Build tools
            nodePackages.vite
            nodePackages.webpack-cli
            
            # Testing
            nodePackages.jest
            
            # Development utilities
            git
            curl
            jq
          ];

          shellHook = ''
            echo "🟨 Node.js development environment loaded!"
            echo "Node.js version: $(node --version)"
            echo "npm version: $(npm --version)"
            echo ""
            echo "Available tools:"
            echo "  node       - Node.js runtime"
            echo "  npm        - Node package manager"
            echo "  yarn       - Alternative package manager"
            echo "  pnpm       - Fast package manager"
            echo "  tsc        - TypeScript compiler"
            echo "  eslint     - JavaScript linter"
            echo "  prettier   - Code formatter"
            echo "  vite       - Build tool"
            echo ""
            
            # Set up Node.js environment
            export NPM_CONFIG_PREFIX="$PWD/.npm-global"
            export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
            
            # Create npm directory
            mkdir -p .npm-global
            
            echo "NPM global prefix set to: $NPM_CONFIG_PREFIX"
            echo ""
            echo "Quick start:"
            echo "  npm init -y                    # Initialize package.json"
            echo "  npm install                    # Install dependencies"
            echo "  npx create-vite@latest         # Create Vite project"
            echo "  npx create-next-app@latest     # Create Next.js project"
          '';
        };
      });
}