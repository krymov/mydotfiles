# 🔐 Bitwarden CLI Helpers

Your Bitwarden CLI helpers have been restored! Here's how to use them:

## 🚀 Quick Start

```bash
# After restarting your shell or running: exec zsh

# 1. Source the helper functions
bw-source

# 2. Unlock your vault
bwu

# 3. List your items
bwl

# 4. Get a password (copies to clipboard)
bwg "GitHub"
```

## 📚 Available Commands

### Core Functions (after running `bw-source`)
- `bwu` - Unlock vault
- `bwl` - List all items
- `bwg <item>` - Get password (copies to clipboard)
- `bwuser <item>` - Get username (copies to clipboard)
- `bwsearch <term>` - Search for items
- `bwgen [length]` - Generate password
- `bwst` - Show vault status

### Session Management
- `bws-save` - Save current session
- `bws-load` - Load saved session
- `bws-clear` - Clear saved session
- `bws-status` - Show session status

### Workspace Management
- `bww-list` - List workspaces
- `bww-switch <name>` - Switch to workspace
- `bww-add <item>` - Add item to current workspace
- `bww-items` - Show items in current workspace
- `bww-current` - Show current workspace

## 🔧 Setup Required

1. **Install Bitwarden CLI** (if not already installed):
   ```bash
   brew install bitwarden-cli
   ```

2. **Login to Bitwarden**:
   ```bash
   bw login
   ```

3. **Source the helpers** (add to your workflow):
   ```bash
   bw-source  # or source ~/.local/bin/bw-helpers.sh
   ```

## 💡 Usage Examples

### Basic Password Management
```bash
# Source helpers and unlock
bw-source && bwu

# Search for GitHub-related items
bwsearch github

# Get GitHub password
bwg "GitHub Personal"

# Generate a new 20-character password
bwgen 20
```

### Workspace Management for Projects
```bash
# Create a workspace for a project
bww create "project-alpha"

# Switch to the workspace
bww-switch "project-alpha"

# Add relevant items to the workspace
bww-add "AWS Production"
bww-add "Database Admin"
bww-add "API Keys"

# View workspace items
bww-items

# Get all passwords for workspace items (requires unlocked vault)
bww passwords
```

### Session Persistence
```bash
# After unlocking, save the session
bws-save

# Later, restore the session
bws-load

# Check session status
bws-status
```

## 🎯 Pro Tips

1. **Add to your shell startup**: Add `source ~/.local/bin/bw-helpers.sh` to your `.zshrc` for automatic loading

2. **Use workspaces**: Group related passwords by project for easier management

3. **Save sessions**: Use session management to avoid frequent re-authentication

4. **Security**: Sessions are saved locally - use `bws-clear` when done

## 🔒 Security Notes

- Session files are stored in `~/.config/bitwarden/`
- These files are excluded from git via `.gitignore`
- Always lock your vault when not in use
- Use `bws-clear` to remove saved sessions on shared machines