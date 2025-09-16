# Home Manager Quick Start

## Prerequisites

1. Install Nix (if not already installed):
   ```bash
   curl -L https://nixos.org/nix/install | sh
   source ~/.nix-profile/etc/profile.d/nix.sh
   ```

## Setup

1. Clone dotfiles (if not already done):
   ```bash
   git clone https://github.com/krymov/mydotfiles ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run bootstrap script:
   ```bash
   ./bootstrap.sh
   ```

   This will:
   - Install Home Manager
   - Apply package configuration
   - Set up stow for dotfiles

## Daily Commands

```bash
# Apply configuration changes
home-manager switch

# Update packages
nix-channel --update && home-manager switch

# List generations (snapshots)
home-manager generations

# Rollback to previous generation
home-manager switch --rollback

# Check what packages are installed
home-manager packages
```

## Changing Package Environment

Edit `home.nix` and change the environment:

```nix
packages = import ./packages.nix { 
  inherit pkgs; 
  environment = "development"; # or "server" or "minimal"
};
```

Then run: `home-manager switch`

## Adding New Packages

1. Edit `packages.nix`
2. Add package to appropriate category
3. Run `home-manager switch`

## Troubleshooting

- **Command not found**: Run `source ~/.nix-profile/etc/profile.d/nix.sh`
- **Config error**: Run `home-manager build` to check syntax
- **Packages missing**: Run `home-manager switch` to reapply

For detailed information, see `HOME_MANAGER_MIGRATION.md`