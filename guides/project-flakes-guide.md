# 🚀 Per-Project Flakes Organization Guide

This guide shows you how to set up isolated, reproducible development environments for each project using Nix flakes and direnv.

## 🎯 Quick Setup Process

### 1. Project Structure Overview
```
my-awesome-project/
├── .envrc                 # direnv configuration
├── .env                   # Project secrets (gitignored)
├── flake.nix             # Nix development environment
├── flake.lock            # Locked dependencies
├── .gitignore            # Include flake.lock, exclude .env
├── shell.nix             # Fallback for non-flake users
└── src/                  # Your project code
```

### 2. Initialize a New Project

#### Option A: Using Helper Scripts
```bash
# Go project
pinit go my-api-server
cd my-api-server

# Python project (minimal - uv + ruff only)
pinit python my-ml-project
cd my-ml-project

# Python project (full - with mypy, pytest, ipython, etc.)
ppy-full my-web-api
cd my-web-api

# Node.js project
pinit nodejs my-web-app
cd my-web-app

# Rust project
pinit rust my-cli-tool
cd my-cli-tool

# Data analysis project
pinit data my-analysis
cd my-analysis

# Full-stack project
pinit fullstack my-saas
cd my-saas
```

#### Modern Python Development
The Python setup now uses modern tools by default:

```bash
# Create minimal Python project (uv + ruff)
pinit python my-app
cd my-app

# Create full Python project (+ mypy, pytest, ipython, libraries)
ppy-full my-app
cd my-app

# Switch environments in existing project
py-env full     # Switch to full environment
py-env minimal  # Switch back to minimal

# Setup Python project in current directory
py-here         # Minimal setup
py-here full    # Full setup

# Modern Python workflow
uv add requests          # Add dependency
uv add --dev pytest     # Add dev dependency
uv run python src/main.py   # Run with dependencies
ruff check . && ruff format .  # Lint and format
```

#### Option B: Manual Setup
```bash
# Create project directory
mkdir my-project && cd my-project

# Initialize git
git init

# Copy base flake template
cp ~/.dotfiles/flakes/python/flake.nix .  # or go/nodejs/rust
cp ~/.dotfiles/flakes/python/.envrc .

# Customize for your project
$EDITOR flake.nix
$EDITOR .envrc

# Enable direnv
direnv allow
```

### 3. Customize Your Project Flake

#### Basic Project flake.nix Template
```nix
{
  description = "My Awesome Project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Optional: Cachix configuration
  nixConfig = {
    extra-substituters = [
      "https://my-project.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "my-project.cachix.org-1:YOUR_KEY_HERE"
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Language specific tools
            python311
            python311Packages.pip
            python311Packages.virtualenv
            
            # Development tools
            git
            curl
            jq
            
            # Project specific tools
            postgresql
            redis
            
            # Cachix for binary caching
            cachix
          ];

          shellHook = ''
            echo "🚀 Welcome to My Awesome Project!"
            echo ""
            echo "📦 Environment loaded with:"
            echo "  Python $(python --version)"
            echo "  PostgreSQL $(pg_config --version)"
            echo "  Redis available"
            echo ""
            echo "🏁 Quick start:"
            echo "  pip install -r requirements.txt"
            echo "  python manage.py runserver"
            echo ""
            
            # Set up project-specific environment
            export PROJECT_ROOT=$(pwd)
            export DATABASE_URL="postgresql://localhost/myproject_dev"
            
            # Create virtual environment if it doesn't exist
            if [[ ! -d .venv ]]; then
              echo "📦 Creating Python virtual environment..."
              python -m venv .venv
            fi
            
            source .venv/bin/activate
          '';
        };
      });
}
```

#### Advanced Multi-Shell Setup
```nix
# For projects with multiple environments (dev/test/prod)
outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      basePackages = with pkgs; [ git curl jq ];
    in
    {
      devShells = {
        # Development environment
        default = pkgs.mkShell {
          buildInputs = basePackages ++ (with pkgs; [
            python311
            postgresql
            redis
            docker
          ]);
          shellHook = ''
            export NODE_ENV="development"
            export DEBUG="true"
          '';
        };
        
        # Testing environment
        test = pkgs.mkShell {
          buildInputs = basePackages ++ (with pkgs; [
            python311
            postgresql
          ]);
          shellHook = ''
            export NODE_ENV="test"
            export DATABASE_URL="postgresql://localhost/myproject_test"
          '';
        };
        
        # Production-like environment
        prod = pkgs.mkShell {
          buildInputs = basePackages ++ (with pkgs; [
            python311
          ]);
          shellHook = ''
            export NODE_ENV="production"
            export DEBUG="false"
          '';
        };
      };
    });
```

### 4. Project .envrc Configuration

#### Basic .envrc
```bash
# Load the nix development environment
use flake

# Load .env file if it exists (for secrets)
dotenv_if_exists

# Project-specific PATH additions
PATH_add bin
PATH_add scripts

# Optional: Auto-activate virtual environment
layout python3

# Optional: Set project-specific environment variables
export PROJECT_NAME="my-awesome-project"
export LOG_LEVEL="debug"
```

#### Advanced .envrc with Multiple Shells
```bash
# Choose development shell based on environment
if [[ "${ENVIRONMENT:-dev}" == "test" ]]; then
  use flake .#test
elif [[ "${ENVIRONMENT:-dev}" == "prod" ]]; then
  use flake .#prod
else
  use flake .#default
fi

# Load secrets
dotenv_if_exists .env.local
dotenv_if_exists .env

# Project paths
PATH_add bin
PATH_add scripts
PATH_add node_modules/.bin

# Language-specific layouts
case "$(basename $PWD)" in
  *-python-*|*-py-*)
    layout python3
    ;;
  *-node-*|*-js-*|*-ts-*)
    layout node
    ;;
  *-go-*)
    export GOPATH="$PWD/.go"
    PATH_add "$GOPATH/bin"
    ;;
esac
```

### 5. Cachix Integration

#### Setup Cachix for Your Project
```bash
# Create a new cache (if you have write access)
cachix create my-project-cache

# Configure cache for current project
csetup my-project-cache

# Push your development environment
cpush my-project-cache

# Set up automatic pushing during builds
cwatch my-project-cache
```

#### Add Cachix to Your Flake
```nix
# Add to flake.nix
nixConfig = {
  extra-substituters = [
    "https://my-project-cache.cachix.org"
    "https://nix-community.cachix.org"  # Community cache
  ];
  extra-trusted-public-keys = [
    "my-project-cache.cachix.org-1:YOUR_PUBLIC_KEY_HERE"
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
};
```

## 🛠️ Project Organization Patterns

### Pattern 1: Language-Specific Projects
```
~/projects/
├── go-projects/
│   ├── api-server/
│   │   ├── flake.nix (extends ~/.dotfiles/flakes/go)
│   │   └── .envrc
│   └── cli-tool/
├── python-projects/
│   ├── ml-pipeline/
│   │   ├── flake.nix (extends ~/.dotfiles/flakes/python)
│   │   └── .envrc
│   └── web-app/
└── rust-projects/
    └── game-engine/
```

### Pattern 2: Client-Based Projects
```
~/clients/
├── acme-corp/
│   ├── backend-api/     # Go project
│   ├── frontend/        # Node.js project
│   └── data-pipeline/   # Python project
└── startup-xyz/
    ├── mobile-app/      # React Native
    └── landing-page/    # Next.js
```

### Pattern 3: Full-Stack Monorepo
```
my-saas-project/
├── flake.nix           # Combined environment
├── .envrc              # Root environment
├── backend/
│   ├── .envrc          # Backend-specific (Go)
│   └── go.mod
├── frontend/
│   ├── .envrc          # Frontend-specific (Node.js)
│   └── package.json
├── shared/
└── infrastructure/
    └── .envrc          # Infrastructure-specific (Terraform)
```

## 🚀 Daily Workflow

### Starting Work on a Project
```bash
# Navigate to project
cd ~/projects/my-awesome-project

# direnv automatically loads environment
# (if you see permission denied, run: direnv allow)

# Check environment status
direnv status

# Start coding!
$EDITOR .
```

### Switching Between Projects
```bash
# Each project has its own isolated environment
cd ~/projects/python-ml     # Python 3.11, scikit-learn, jupyter
cd ~/projects/go-api        # Go 1.21, air, golangci-lint
cd ~/projects/rust-cli      # Rust stable, cargo-watch, clippy
```

### Updating Project Dependencies
```bash
# Update flake inputs
nflake update

# Push updated environment to cache
cpush my-project-cache

# Commit the updated flake.lock
git add flake.lock
git commit -m "Update nix dependencies"
```

## 🔧 Advanced Patterns

### Shared Flake Inputs
```nix
# flakes/shared/flake.nix - Shared base
{
  description = "Shared development tools";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    in
    {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devTools = pkgs.buildEnv {
            name = "shared-dev-tools";
            paths = with pkgs; [ git curl jq tree fzf bat eza ];
          };
        });
    };
}

# In your project flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    shared.url = "path:~/.dotfiles/flakes/shared";
  };
  
  outputs = { self, nixpkgs, shared }:
    # Use shared.packages.${system}.devTools in your buildInputs
}
```

### Template System
```bash
# Create project templates
mkdir -p ~/.dotfiles/templates/

# Python FastAPI template
~/.dotfiles/templates/python-api/
├── flake.nix
├── .envrc
├── requirements.txt
├── app/
│   └── main.py
└── tests/

# Use templates
nix flake init -t ~/.dotfiles/templates/python-api
```

## 🐛 Troubleshooting

### Common Issues

#### Environment Not Loading
```bash
# Check direnv status
ds

# Reload environment
dr

# Allow environment (if blocked)
da

# Check flake syntax
ncheck
```

#### Missing Packages
```bash
# Search for packages
nix search nixpkgs python

# Enter environment manually to debug
ndev

# Check what's in PATH
echo $PATH | tr ':' '\n'
```

#### Cache Issues
```bash
# Clear nix cache
sudo nix store gc

# Rebuild environment
ndev --rebuild

# Check cachix status
cstatus
```

## 💡 Best Practices

1. **Always commit `flake.lock`** - Ensures reproducible builds across team
2. **Use `.env` for secrets** - Never commit sensitive data
3. **Pin important versions** - Use specific versions for production dependencies
4. **Document your environment** - Include setup instructions in README
5. **Share caches** - Use Cachix to speed up team onboarding
6. **Test in CI** - Use `nix develop -c command` in CI to test with exact environment
7. **Keep flakes simple** - Start minimal, add complexity as needed

## 📚 Available Commands

### Project Management
- `pinit <type> <name>` - Initialize new project
- `ppy <name>` - Create minimal Python project (uv + ruff)
- `ppy-full <name>` - Create full Python project (+ mypy, pytest, etc.)
- `pgo <name>` - Create Go project
- `pjs <name>` - Create Node.js project
- `prs <name>` - Create Rust project
- `pdata <name>` - Create data analysis project
- `pfull <name>` - Create full-stack project

### Python Environment Management
- `py-env [minimal|full]` - Switch Python environment type
- `py-min` - Switch to minimal environment (uv + ruff)
- `py-full` - Switch to full environment (+ mypy, pytest, ipython, etc.)
- `py-new <name> [minimal|full]` - Create new Python project
- `py-here [minimal|full]` - Setup Python project in current directory

### Modern Python Workflow
- `uv-init` - Initialize uv project
- `uv-add <package>` - Add dependency
- `uv-run <command>` - Run command with dependencies
- `lint` - Run ruff check
- `format` - Run ruff format
- `check` - Run ruff check and format validation

### Cachix Operations
- `csetup <cache>` - Setup cache for project
- `cpush <cache>` - Push current environment to cache
- `cwatch <cache>` - Watch and push builds automatically
- `cuse <cache>` - Use existing cache
- `cauth` - Authenticate with Cachix
- `cstatus` - Show Cachix status

### direnv Operations
- `da` - Allow current directory
- `dr` - Reload environment
- `ds` - Show direnv status

### Nix Operations
- `ndev` - Enter development shell
- `nflake <cmd>` - Run flake commands
- `ncheck` - Check flake syntax
- `nupdate` - Update flake inputs
- `nbuild` - Build current flake
- `nrun` - Run flake application
- `nshell` - Enter temporary shell

## 📖 Examples

Check out these example project setups in your dotfiles:
- [`flakes/python/`](../flakes/python/) - Python development
- [`flakes/go/`](../flakes/go/) - Go development  
- [`flakes/nodejs/`](../flakes/nodejs/) - Node.js development
- [`flakes/rust/`](../flakes/rust/) - Rust development
- [`flakes/data/`](../flakes/data/) - Data analysis environment

## 🤝 Team Collaboration

### Sharing Development Environments
```bash
# Team member clones project
git clone https://github.com/yourorg/project.git
cd project

# Environment automatically loads with direnv
direnv allow

# All dependencies available instantly (thanks to Cachix)
npm install  # or pip install, cargo build, etc.
```

### CI/CD Integration
```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: cachix/install-nix-action@v20
      - uses: cachix/cachix-action@v12
        with:
          name: my-project-cache
      - run: nix develop -c npm test
```

This setup ensures that your entire team has identical development environments and CI/CD pipelines use the exact same tooling!