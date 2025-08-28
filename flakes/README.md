# Development Environment Flakes

This directory contains Nix flakes for different programming languages and development environments. Each flake provides a complete development environment with language-specific tools, linters, formatters, and dependencies.

## Available Environments

### Go (`go/`)
- Go compiler and toolchain
- Language server (gopls)
- Linting (golangci-lint)
- Debugging (delve)
- Database tools (PostgreSQL, Redis)

### Python (`python/`)
- Python 3.11 interpreter
- Package management (pip, poetry)
- Language server (python-lsp-server)
- Formatting and linting (black, isort, flake8, mypy)
- Testing (pytest)
- Common packages (requests, numpy, pandas)

### Node.js (`nodejs/`)
- Node.js 20 runtime
- Package managers (npm, yarn, pnpm)
- TypeScript support
- Language server and tools (ESLint, Prettier)
- Build tools (Vite, Webpack)
- Testing (Jest)

### Rust (`rust/`)
- Latest stable Rust toolchain
- Language server (rust-analyzer)
- Development tools (cargo-watch, cargo-edit, cargo-audit)
- System dependencies (pkg-config, OpenSSL)

## Quick Start

### Using the Helper Script
```bash
# Set up a new Go project
dev-go myapp

# Set up Python environment in current directory
dev-python

# Set up Node.js project
dev-nodejs my-web-app

# Set up Rust project
dev-rust my-rust-app
```

### Manual Setup
1. Copy the appropriate `.envrc` file to your project root
2. Modify the flake path if needed
3. Run `direnv allow`

### Example `.envrc` for Go project
```bash
# Copy from flakes/go/.envrc to your project root
use flake ~/.dotfiles/flakes/go

# Optional: Load .env file
dotenv_if_exists

# Optional: Project-specific environment variables
export DATABASE_URL="postgres://localhost/myapp_dev"
```

## Customizing Environments

### Adding Packages
Edit the `buildInputs` in the respective `flake.nix`:

```nix
buildInputs = with pkgs; [
  # Existing packages...
  
  # Add your packages here
  postgresql
  redis
  docker
];
```

### Environment Variables
Add to the `shellHook` in `flake.nix` or use the `.envrc` file:

```bash
# In .envrc
export API_KEY="your-key-here"
export DATABASE_URL="postgres://localhost/myapp"

# Load from .env file
dotenv_if_exists
```

### Project-Specific Paths
```bash
# In .envrc
PATH_add bin
PATH_add scripts
PATH_add node_modules/.bin
```

## Advanced Usage

### Multiple Environments
You can combine multiple flakes or create environment-specific `.envrc` files:

```bash
# .envrc.development
use flake ~/.dotfiles/flakes/python
export DEBUG=true
export DATABASE_URL="postgres://localhost/myapp_dev"

# .envrc.production
use flake ~/.dotfiles/flakes/python
export DEBUG=false
export DATABASE_URL="$PRODUCTION_DATABASE_URL"
```

### Custom Flakes
Create your own flakes for specific projects or combinations:

```nix
# flakes/fullstack/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Backend (Go)
            go gopls
            
            # Frontend (Node.js)
            nodejs_20 nodePackages.npm
            
            # Database
            postgresql redis
            
            # Infrastructure
            docker docker-compose
            terraform
          ];
        };
      });
}
```

## Integration with IDEs

### VS Code
Install the direnv extension to automatically load environments.

### Neovim (AstroNvim)
The environments work automatically with LSP servers configured in your dotfiles.

### Other Editors
Most editors that support Language Server Protocol (LSP) will work with the provided language servers.

## Troubleshooting

### Environment Not Loading
```bash
# Check direnv status
direnv status

# Reload environment
direnv reload

# Allow environment
direnv allow
```

### Missing Dependencies
```bash
# Enter the nix shell manually
nix develop

# Check what's available
nix flake show ~/.dotfiles/flakes/go
```

### Flake Updates
```bash
# Update flake inputs
nix flake update ~/.dotfiles/flakes/go

# Update all flakes
find ~/.dotfiles/flakes -name flake.nix -execdir nix flake update \;
```

## Tips

1. **Use `.env` files** for sensitive data (already in `.gitignore`)
2. **Commit `.envrc`** to your project repos for team consistency
3. **Pin flake versions** for production environments
4. **Use `direnv reload`** when changing `.envrc`
5. **Check `direnv status`** if environment seems wrong

## Examples

See the individual directories for example `.envrc` files and usage patterns for each language environment.