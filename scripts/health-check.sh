#!/bin/bash
# =============================================================================
# Dotfiles Health Check
# =============================================================================
#
# Verifies that all expected tools and configurations are properly set up.
# Run this after installation or when troubleshooting issues.
#
# Usage:
#   ./scripts/health-check.sh
#   ./scripts/health-check.sh --verbose
#
# =============================================================================

set -e

VERBOSE="${1:-}"
PASSED=0
FAILED=0
WARNINGS=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

pass() {
    echo -e "${GREEN}✓${NC} $1"
    (( PASSED += 1 ))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    (( FAILED += 1 ))
}

warn() {
    echo -e "${YELLOW}!${NC} $1"
    (( WARNINGS += 1 ))
}

info() {
    if [[ "$VERBOSE" == "--verbose" ]]; then
        echo -e "${BLUE}ℹ${NC} $1"
    fi
}

check_command() {
    local cmd="$1"
    local name="${2:-$1}"
    local version
    if command -v "$cmd" &>/dev/null; then
        version=$("$cmd" --version 2>/dev/null | head -1 || echo "installed")
        pass "$name: $version"
        return 0
    else
        fail "$name: not found"
        return 1
    fi
}

check_file() {
    local file="$1"
    local desc="$2"
    if [[ -f "$file" ]]; then
        pass "$desc exists"
        return 0
    else
        fail "$desc missing: $file"
        return 1
    fi
}

check_dir() {
    local dir="$1"
    local desc="$2"
    if [[ -d "$dir" ]]; then
        pass "$desc exists"
        return 0
    else
        warn "$desc missing: $dir"
        return 1
    fi
}

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}     Dotfiles Health Check${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# =============================================================================
# SHELL CONFIGURATION
# =============================================================================
echo -e "${BLUE}Shell Configuration${NC}"
echo "-------------------"

check_file ~/.zshrc ".zshrc"
check_dir ~/.zsh ".zsh directory"
check_file ~/.zsh/aliases.zsh "aliases.zsh"
check_dir ~/.zsh/dev "dev modules directory"

# Check shell startup
echo ""
echo "Testing shell startup..."
if zsh -i -c 'exit 0' 2>/dev/null; then
    pass "Shell starts without errors"
else
    fail "Shell startup has errors"
fi

echo ""

# =============================================================================
# CORE TOOLS
# =============================================================================
echo -e "${BLUE}Core Tools${NC}"
echo "----------"

check_command zsh "Zsh"
check_command git "Git"
check_command curl "curl"
check_command wget "wget"

if [[ "$(uname)" == "Darwin" ]]; then
    check_command brew "Homebrew"
fi

echo ""

# =============================================================================
# DEVELOPMENT TOOLS
# =============================================================================
echo -e "${BLUE}Development Tools${NC}"
echo "-----------------"

check_command nvim "Neovim" || check_command vim "Vim"
check_command tmux "tmux"
check_command fzf "fzf"
check_command rg "ripgrep"
check_command fd "fd"
check_command bat "bat"
check_command exa "exa" || check_command eza "eza"
check_command jq "jq"
check_command yq "yq"

echo ""

# =============================================================================
# DEVOPS TOOLS
# =============================================================================
echo -e "${BLUE}DevOps Tools${NC}"
echo "------------"

check_command docker "Docker"
check_command kubectl "kubectl"
check_command helm "Helm"
check_command terraform "Terraform"
check_command aws "AWS CLI"
check_command gh "GitHub CLI"

echo ""

# =============================================================================
# GIT CONFIGURATION
# =============================================================================
echo -e "${BLUE}Git Configuration${NC}"
echo "-----------------"

check_file ~/.gitconfig ".gitconfig"

if git config user.name &>/dev/null; then
    pass "Git user.name: $(git config user.name)"
else
    warn "Git user.name not set"
fi

if git config user.email &>/dev/null; then
    pass "Git user.email: $(git config user.email)"
else
    warn "Git user.email not set"
fi

echo ""

# =============================================================================
# SSH CONFIGURATION
# =============================================================================
echo -e "${BLUE}SSH Configuration${NC}"
echo "-----------------"

check_dir ~/.ssh "SSH directory"

if [[ -f ~/.ssh/id_ed25519 ]] || [[ -f ~/.ssh/id_rsa ]]; then
    pass "SSH key exists"
else
    warn "No SSH key found (id_ed25519 or id_rsa)"
fi

if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    pass "GitHub SSH authentication works"
else
    warn "GitHub SSH authentication not verified"
fi

echo ""

# =============================================================================
# KUBERNETES CONFIGURATION
# =============================================================================
echo -e "${BLUE}Kubernetes Configuration${NC}"
echo "------------------------"

if [[ -f ~/.kube/config ]]; then
    pass "kubeconfig exists"
    if kubectl config current-context &>/dev/null; then
        pass "Current context: $(kubectl config current-context)"
    else
        warn "No current context set"
    fi
else
    info "kubeconfig not found (optional)"
fi

echo ""

# =============================================================================
# AWS CONFIGURATION
# =============================================================================
echo -e "${BLUE}AWS Configuration${NC}"
echo "-----------------"

if [[ -f ~/.aws/config ]]; then
    pass "AWS config exists"
else
    info "AWS config not found (optional)"
fi

if [[ -f ~/.aws/credentials ]] || [[ -n "$AWS_PROFILE" ]]; then
    pass "AWS credentials configured"
else
    info "AWS credentials not found (optional)"
fi

echo ""

# =============================================================================
# SUMMARY
# =============================================================================
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}     Summary${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "${GREEN}Passed:${NC}   $PASSED"
echo -e "${RED}Failed:${NC}   $FAILED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some checks failed. Please review above.${NC}"
    exit 1
fi
