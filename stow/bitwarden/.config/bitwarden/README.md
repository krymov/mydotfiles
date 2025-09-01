# Bitwarden Configuration Directory

This directory contains configuration files for the Bitwarden workspace integration.

## 🔐 Security Notice

**IMPORTANT:** The following files contain sensitive information and should NEVER be committed to git:
- `session` - Contains your temporary Bitwarden session token (24h expiry)
- `workspace` - Contains current workspace context (may reveal client names)
- `server` - Contains your Bitwarden server URL (may reveal self-hosted instance)

These files are automatically added to `.gitignore` for your protection.

## Files

### Template Files (Safe to commit)
- `server.example` - Example server configuration template
- `workspace.example` - Example workspace configuration template  
- `session.example` - Documentation for session file
- `README.md` - This documentation

### Runtime Files (Never commit)
- `server` - Your actual Bitwarden server configuration
- `workspace` - Current active workspace/client context
- `session` - Temporary session token (auto-expires after 24h)

## Setup

1. Copy the example server configuration:
   ```bash
   cp server.example server
   ```

2. Edit the `server` file with your Bitwarden instance URL:
   - For Bitwarden cloud: `https://vault.bitwarden.com`
   - For self-hosted: `https://your-vaultwarden-instance.com`

3. Login using the session management:
   ```bash
   bwl  # Login and create session
   ```

## Commands

Core session management:
- `bwl` - Login to Bitwarden (alias for bw_login)
- `bwlock` - Logout and clear session (alias for bw_logout)
- `bws` - Sync vault (alias for bw_sync)
- `bwst` - Check status (alias for bw_status)

Client and workspace management:
- `bwc <client>` - Create new client structure
- `bwt` - Interactive template creator with fzf client selection
- `bwls` - List all clients  
- `bwp <project>` - Switch to project workspace
- `bwload [file]` - Load environment variables from Bitwarden

## Security Best Practices

1. **Session Management**: Sessions auto-expire after 24 hours for security
2. **File Permissions**: Runtime config files are created with restricted permissions
3. **Git Safety**: All sensitive files are automatically gitignored
4. **Server Config**: Consider if your server URL should be kept private
5. **Environment Loading**: Use `bwload` to inject secrets into environment without persisting them

## Troubleshooting

If you encounter permission or configuration issues:

1. Check that example files exist and are readable
2. Verify `.gitignore` includes the sensitive files
3. Ensure Bitwarden CLI is installed and accessible
4. Check that your server URL is correct in the `server` file

For self-hosted Vaultwarden instances, ensure your server supports the Bitwarden CLI API.