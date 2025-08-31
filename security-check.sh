#!/usr/bin/env bash
# Pre-publish security check
# Scans dotfiles for potentially sensitive information before making repo public

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo "🔍 Security scan for dotfiles repository"
echo "Checking for potentially sensitive information..."
echo ""

cd "$DOTFILES_DIR"

# Patterns to search for (case insensitive)
SENSITIVE_PATTERNS=(
    "password"
    "secret"
    "token"
    "api_key"
    "apikey"
    "private_key"
    "privatekey"
    "credential"
    "auth"
    "ssh_key"
    "BEGIN PRIVATE KEY"
    "BEGIN RSA PRIVATE KEY"
    "BEGIN DSA PRIVATE KEY"
    "BEGIN EC PRIVATE KEY"
    "BEGIN OPENSSH PRIVATE KEY"
)

# File extensions to check
FILE_EXTENSIONS=(
    "*.sh"
    "*.zsh"
    "*.lua"
    "*.json"
    "*.yaml"
    "*.yml"
    "*.toml"
    "*.conf"
    "*.config"
    "*.txt"
    "*.md"
)

# Directories to exclude from search
EXCLUDE_DIRS=(
    ".git"
    "nvim-backups"
    ".direnv"
    "node_modules"
    "stow/zsh/.zsh/plugins"
)

# Files to exclude from search (security script itself and docs)
EXCLUDE_FILES=(
    "./security-check.sh"
    "./flakes/README.md"
    "./README.md"
    "./setup.sh"
    "./bootstrap.sh"
    "./stow/zsh/.zsh/env.zsh"
)

# Build find command with exclusions
FIND_CMD="find . -type f"
for dir in "${EXCLUDE_DIRS[@]}"; do
    FIND_CMD="$FIND_CMD -not -path \"./$dir/*\""
done

# Add file extension filters
FIND_CMD="$FIND_CMD \\( "
for i in "${!FILE_EXTENSIONS[@]}"; do
    if [ $i -eq 0 ]; then
        FIND_CMD="$FIND_CMD -name \"${FILE_EXTENSIONS[$i]}\""
    else
        FIND_CMD="$FIND_CMD -o -name \"${FILE_EXTENSIONS[$i]}\""
    fi
done
FIND_CMD="$FIND_CMD \\)"

# Check for sensitive patterns
log_info "Scanning files for sensitive patterns..."
found_issues=false

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    log_info "Checking for: $pattern"

    # Use the find command and pipe to grep, then filter out excluded files
    matches=$(eval "$FIND_CMD" | xargs grep -l -i "$pattern" 2>/dev/null || true)

    # Filter out excluded files
    if [ -n "$matches" ]; then
        filtered_matches=""
        while IFS= read -r file; do
            excluded=false
            for exclude in "${EXCLUDE_FILES[@]}"; do
                if [ "$file" = "$exclude" ]; then
                    excluded=true
                    break
                fi
            done
            if [ "$excluded" = false ]; then
                filtered_matches="$filtered_matches$file"$'\n'
            fi
        done <<< "$matches"

        if [ -n "$filtered_matches" ] && [ "$filtered_matches" != $'\n' ]; then
            log_error "Found '$pattern' in:"
            echo "$filtered_matches" | sed 's/^/  - /' | grep -v '^  - $'
            found_issues=true
            echo ""
        fi
    fi
done

# Check for hardcoded IP addresses
log_info "Checking for hardcoded IP addresses..."
ip_matches=$(eval "$FIND_CMD" | xargs grep -l -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' 2>/dev/null | grep -v "127.0.0.1\|0.0.0.0\|localhost" || true)
if [ -n "$ip_matches" ]; then
    log_warning "Found potential IP addresses in:"
    echo "$ip_matches" | sed 's/^/  - /'
    echo ""
fi

# Check for email addresses
log_info "Checking for email addresses..."
email_matches=$(eval "$FIND_CMD" | xargs grep -l -E '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b' 2>/dev/null || true)
if [ -n "$email_matches" ]; then
    log_info "Found email addresses in:"
    echo "$email_matches" | sed 's/^/  - /'
    echo "📧 Review these to ensure they're meant to be public"
    echo ""
fi

# Check for URLs with credentials
log_info "Checking for URLs with credentials..."
url_cred_matches=$(eval "$FIND_CMD" | xargs grep -l -E 'https?://[^:]+:[^@]+@' 2>/dev/null || true)
if [ -n "$url_cred_matches" ]; then
    log_error "Found URLs with credentials in:"
    echo "$url_cred_matches" | sed 's/^/  - /'
    found_issues=true
    echo ""
fi

# Check for SSH keys
log_info "Checking for SSH keys..."
ssh_key_files=$(find . -name "id_*" -o -name "*.pem" -o -name "*.key" | grep -v ".git" || true)
if [ -n "$ssh_key_files" ]; then
    log_error "Found potential SSH key files:"
    echo "$ssh_key_files" | sed 's/^/  - /'
    found_issues=true
    echo ""
fi

# Check file permissions
log_info "Checking for files with sensitive permissions..."
sensitive_perms=$(find . -type f \( -perm -077 -o -perm -007 \) | grep -v ".git" || true)
if [ -n "$sensitive_perms" ]; then
    log_warning "Found files with restricted permissions:"
    echo "$sensitive_perms" | sed 's/^/  - /'
    echo "🔒 These might contain sensitive data"
    echo ""
fi

# Check .gitignore coverage
log_info "Checking .gitignore coverage..."
if [ ! -f .gitignore ]; then
    log_warning "No .gitignore file found"
else
    log_success ".gitignore file exists"

    # Check if common sensitive patterns are ignored
    common_ignores=(".env" "*.key" "*.pem" "*.secret" "personal/" ".aws/" ".gcloud/" ".kube/config")
    missing_ignores=()

    for ignore in "${common_ignores[@]}"; do
        if ! grep -q "$ignore" .gitignore 2>/dev/null; then
            missing_ignores+=("$ignore")
        fi
    done

    if [ ${#missing_ignores[@]} -gt 0 ]; then
        log_warning "Consider adding these patterns to .gitignore:"
        printf '  - %s\n' "${missing_ignores[@]}"
        echo ""
    fi
fi

# Final assessment
echo "🏁 Security scan complete!"
echo ""

if [ "$found_issues" = true ]; then
    log_error "CRITICAL ISSUES FOUND!"
    echo "❗ Do NOT make this repository public until these issues are resolved."
    echo ""
    echo "Steps to fix:"
    echo "1. Remove or redact sensitive information"
    echo "2. Add appropriate patterns to .gitignore"
    echo "3. Consider using git filter-branch if sensitive data was committed"
    echo "4. Re-run this security check"
    exit 1
else
    log_success "No critical security issues found!"
    echo ""
    echo "✅ Repository appears safe to make public"
    echo "💡 Remember to:"
    echo "   - Review any warnings above"
    echo "   - Double-check email addresses and IP addresses"
    echo "   - Ensure no personal information is included"
    echo "   - Test the setup script on a clean environment"
    echo ""
    echo "🚀 Ready to publish!"
fi
