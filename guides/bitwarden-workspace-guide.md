# Bitwarden Workspace Integration

A comprehensive system for managing client credentials, projects, and environment files using Bitwarden CLI with fzf integration.

## Quick Start

```bash
# Login to Bitwarden
bwl

# Create a new client structure
bwc "YourClient"

# Add credentials using interactive template with client selection
bwt

# List all clients
bwls

# Switch to a project context
bwp "YourClient"
```

## Folder Structure

Your Bitwarden vault will be organized as:

```
📁 Clients/
├── 📁 yepic/
│   ├── 📁 Billing/          # Invoicing, contracts, financial access
│   ├── 📁 Infrastructure/   # Servers, cloud accounts, domains  
│   ├── 📁 Projects/         # Per-project credentials and envs
│   │   ├── 📁 frontend/
│   │   │   ├── 📁 Development/
│   │   │   ├── 📁 Staging/
│   │   │   └── 📁 Production/
│   │   └── 📁 backend/
│   │       ├── 📁 Development/
│   │       ├── 📁 Staging/
│   │       └── 📁 Production/
│   └── 📁 Services/         # 3rd party APIs, integrations
└── 📁 otherclient/
    ├── 📁 Billing/
    ├── 📁 Infrastructure/
    ├── 📁 Projects/
    └── 📁 Services/
```

## Core Commands

### Session Management
```bash
bwl              # Login and unlock vault
bws              # Check session status  
bwlock           # Lock vault and clear session
```

### Project Management
```bash
bwswitch <client> <project> [env]   # Switch to project context
bwcontext                           # Show current context
bwnew <client> <project>           # Create new project structure
```

### Credential Management
```bash
bwt                                # Interactive template creator
bwget <service>                    # Get credentials for current context
bw_get_login <client> <project> <env> <service>  # Get specific login
bw_list_client <client>            # List all client entries
```

### Environment Files
```bash
bwsave [file]                      # Save .env to Bitwarden (default: .env)
bwload [file]                      # Load .env from Bitwarden
bw_add_env <client> <project> <env> <file>  # Add env file
bw_get_env <client> <project> <env> [output] # Get env file
```

## Usage Examples

### 1. Setting up a new client

```bash
# Login
bwl

# Create client structure
bw_create_client "yepic"

# Add infrastructure credentials
bwt
# Choose: 1) Infrastructure credential
# Service: AWS Console
# Username: admin@yepic.com
# Password: [generated]
```

### 2. Working with projects

```bash
# Create and setup new project
bwnew yepic frontend

# Switch to project context
bwswitch yepic frontend development

# Your workspace will be: ~/workspace/yepic/repos/frontend
# Environment variables will auto-load if stored in Bitwarden
```

### 3. Managing environment files

```bash
# In your project directory ~/workspace/yepic/repos/frontend
cd ~/workspace/yepic/repos/frontend

# Save current .env to Bitwarden
bwsave

# Later, load .env from Bitwarden
bwload

# Or save/load specific files
bwsave .env.staging
bwload .env.production
```

### 4. Managing different credential types

```bash
# Add database credentials for production
bwt
# Choose: 4) Project credential  
# Project: frontend
# Environment: production
# Service: Database
# Username: app_user
# Password: [generated]

# Add billing access
bwt
# Choose: 2) Billing credential
# Service: Stripe Dashboard
# Username: billing@yepic.com
# Password: [manual entry]

# Add 3rd party API
bwt  
# Choose: 3) Service credential
# Service: SendGrid API
# Username: apikey
# Password: SG.abc123...
```

### 5. Daily workflow

```bash
# Start of day - login once
bwl

# Switch between projects
bwswitch yepic frontend production    # Deploy to production
bwswitch yepic backend development    # Back to development
bwswitch otherclient mobile staging   # Different client

# Get specific credentials when needed
bwget "Database"          # For current context
bwget "AWS Console"       # For current context
bwget "API"              # For current context

# Work on environment files
bwload .env.production   # Load prod env
# Edit and test...
bwsave .env.production   # Save back to Bitwarden
```

## Security Features

- **Session timeout**: Auto-locks after 1 hour
- **Secure storage**: Environment files stored as encrypted notes
- **Context isolation**: Each project has separate credential space
- **No plain text**: Credentials never stored in plain text files
- **Audit trail**: All entries tagged with creation/update dates

## Tips

1. **Use descriptive service names**: "AWS Console", "Database Master", "API Key Production"
2. **Consistent naming**: Follow the template patterns for easy searching
3. **Regular rotation**: Use the "Last Rotated" custom field to track credential age
4. **Environment separation**: Keep dev/staging/prod credentials completely separate
5. **Backup important .env files**: Store in Bitwarden before making changes

## Troubleshooting

```bash
# Session issues
bws                    # Check session status
bwl                    # Re-login if needed

# Context issues  
bwcontext             # Check current context
bwswitch client proj  # Reset context

# Missing credentials
bw_list_client yepic  # See all entries for client
bwt                   # Add missing credentials

# Environment files
bwload                # Re-download from Bitwarden
ls -la .env*          # Check local files
```