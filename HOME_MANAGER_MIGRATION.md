# Home Manager Migration Guide

This guide explains how to migrate from the old `nix-env` based package management to the new declarative Home Manager approach.

## Overview

The dotfiles have been updated to use **Home Manager** for declarative package management. This solves the "missing packages after restart" problem and provides truly reproducible environments across macOS and NixOS.

## What Changed

### Before (Old Approach)
- Used `nix-env -iA` commands to install packages imperatively
- Packages defined in `packages.nix` but installed via shell scripts
- Packages could disappear after system updates or restarts
- Each machine might end up with slightly different packages

### After (New Approach)
- Uses Home Manager for declarative package management
- Same `packages.nix` file, but now imported by `home.nix`
- Packages are consistently available across reboots and updates
- Identical environments across all machines
- Easy rollbacks and generations management

## Prerequisites

1. **Nix Package Manager**: Must be installed first
   ```bash
   # Install Nix (if not already installed)
   curl -L https://nixos.org/nix/install | sh
   source ~/.nix-profile/etc/profile.d/nix.sh
   ```

2. **Update Nix Channels**: Ensure you have the latest packages
   ```bash
   nix-channel --update
   ```

## Migration Steps

### 1. Clean Up Old nix-env Packages (Optional)

If you want to start fresh and remove old `nix-env` installed packages:

```bash
# List currently installed packages
nix-env -q

# Remove all user-installed packages (optional)
nix-env -e '*'

# Or remove specific packages
nix-env -e package-name
```

### 2. Install Home Manager

Run the automated installer:

```bash
cd ~/.dotfiles
./install-home-manager.sh
```

This script will:
- Install Home Manager if not present
- Link your `home.nix` configuration
- Apply the configuration
- Install all packages from `packages.nix`

### 3. Use Updated Bootstrap Script

The `bootstrap.sh` script has been updated to use Home Manager:

```bash
cd ~/.dotfiles
./bootstrap.sh
```

## Daily Usage

### Applying Changes

After modifying `packages.nix` or `home.nix`:

```bash
home-manager switch
```

### Managing Generations

```bash
# List all generations
home-manager generations

# Rollback to previous generation
home-manager switch --rollback

# Rollback to specific generation
home-manager switch --switch-generation 42
```

### Updating Packages

```bash
# Update channels
nix-channel --update

# Apply updates
home-manager switch
```

## Configuration Files

### `home.nix`
- Main Home Manager configuration
- Imports packages from `packages.nix`
- Configures programs (git, zsh, neovim, etc.)
- Sets environment variables and aliases

### `packages.nix` (Unchanged)
- Same structure as before
- Supports different environments: "development", "server", "minimal"
- Platform-specific packages for macOS vs Linux

### `install-home-manager.sh`
- Automated Home Manager installation script
- Handles channel setup and initial configuration
- Cross-platform compatible

## Environment Selection

You can change the package environment by editing `home.nix`:

```nix
packages = import ./packages.nix { 
  inherit pkgs; 
  environment = "development"; # Change to "server" or "minimal"
};
```

Available environments:
- **development**: All packages (default)
- **server**: Core packages only
- **minimal**: Minimal package set

## Cross-Platform Usage

### macOS
- Full package set from `packages.nix`
- Integrates with existing Homebrew (if installed)
- Platform-specific packages handled automatically

### NixOS
- Can be integrated with system configuration
- Add to `/etc/nixos/configuration.nix`:
  ```nix
  imports = [ <home-manager/nixos> ];
  home-manager.users.mark = import /path/to/dotfiles/home.nix;
  ```

### Linux (non-NixOS)
- Works as standalone Home Manager installation
- Platform-specific packages (like `kitty`, `xclip`) included

## Troubleshooting

### Home Manager Not Found
```bash
# Source Nix profile
source ~/.nix-profile/etc/profile.d/nix.sh

# Reinstall Home Manager
./install-home-manager.sh
```

### Configuration Errors
```bash
# Check configuration syntax
home-manager build

# See detailed error output
home-manager switch --show-trace
```

### Package Conflicts
```bash
# Remove conflicting nix-env packages
nix-env -e package-name

# Then apply Home Manager
home-manager switch
```

### Missing Packages After Updates
This should no longer happen with Home Manager, but if it does:
```bash
# Reapply configuration
home-manager switch

# Or rollback to working generation
home-manager switch --rollback
```

## Benefits of New Approach

1. **Declarative**: Everything defined in configuration files
2. **Reproducible**: Same setup on every machine
3. **Atomic**: All-or-nothing updates prevent broken states
4. **Rollbacks**: Easy to undo changes
5. **Cross-platform**: Works on macOS, NixOS, and Linux
6. **Persistent**: Packages survive reboots and system updates

## Advanced Usage

### Adding New Packages

1. Edit `packages.nix` to add packages to appropriate category
2. Run `home-manager switch`

### Program-specific Configuration

Home Manager can manage configuration for many programs. Examples in `home.nix`:

- **Git**: User info, aliases, settings
- **Zsh**: Plugins, aliases, prompt
- **Neovim**: Basic settings (or keep using stow)
- **Tmux**: Configuration (or keep using stow)

### Gradual Migration from Stow

You can gradually migrate from stow to Home Manager:

1. Keep using stow for complex configurations initially
2. Move simple configurations to Home Manager over time
3. Both approaches can coexist

## Getting Help

- Check Home Manager manual: https://nix-community.github.io/home-manager/
- Nix documentation: https://nixos.org/manual/nix/stable/
- Report issues in the dotfiles repository

## Next Steps

1. Test the new setup on one machine
2. Verify all expected packages are installed
3. Deploy to other machines
4. Consider migrating some stow configurations to Home Manager
5. Explore Home Manager's program-specific options