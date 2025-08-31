# Neovim Configuration Management

This dotfiles setup includes a flexible Neovim configuration switcher that allows you to easily switch between different Neovim configurations.

## Available Configurations

- **astronvim**: Full-featured configuration based on AstroNvim framework
- **vanilla**: Minimal, lightweight configuration with essential features
- **lazyvim**: LazyVim-based configuration (placeholder - needs setup)

## Usage

### Command Line Tool

Use the `nvim-switch` script to manage configurations:

```bash
# Show current configuration
./nvim-switch current

# List available configurations
./nvim-switch list

# Switch to a specific configuration
./nvim-switch switch astronvim
./nvim-switch switch vanilla
./nvim-switch switch lazyvim

# Backup current nvim data/cache
./nvim-switch backup

# Clean nvim data/cache (useful when switching)
./nvim-switch clean

# Show help
./nvim-switch help
```

### Shell Aliases

If you have the dotfiles stowed, you can use these convenient aliases:

```bash
# General switcher
nvs current              # Show current config
nvs list                 # List available configs
nvs switch astronvim     # Switch to astronvim

# Quick switches
nvs-astro               # Switch to AstroNvim
nvs-vanilla             # Switch to vanilla config
nvs-lazy                # Switch to LazyVim
```

## How It Works

- Each configuration is stored in its own directory
- The switcher creates a symlink from `~/.config/nvim` to the chosen configuration
- Data and cache directories (`~/.local/share/nvim`, `~/.cache/nvim`) are preserved but can be cleaned when switching
- Backups can be created before switching to preserve plugin states

## Adding New Configurations

To add a new configuration:

1. Create a new directory in `configs/` (e.g., `configs/nvim-custom`)
2. Add your `init.lua` and configuration files
3. Update the `CONFIGS` array in the `nvim-switch` script
4. Optionally add an alias in `.zsh/aliases.zsh`

## Directory Structure

```
.dotfiles/
├── nvim-switch              # Configuration switcher script
├── stow/nvim/               # AstroNvim configuration (stowed)
│   └── .config/nvim/
├── configs/
│   ├── nvim-vanilla/        # Minimal configuration
│   └── nvim-lazyvim/        # LazyVim configuration
└── nvim-backups/           # Backup storage (auto-created)
```

## Tips

- Use `nvs backup` before switching configurations to save plugin states
- Use `nvs clean` after switching if you encounter plugin conflicts
- Each configuration maintains its own plugin installations
- The AstroNvim configuration is managed through stow like other dotfiles
