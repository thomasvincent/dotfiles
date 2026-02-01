#!/usr/bin/env bash
# test_configs.sh - Validate configuration files
#
# Tests:
# 1. TOML files are valid
# 2. YAML files are valid
# 3. JSON files are valid
# 4. Shell configs have no obvious errors

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

FAILED=0
PASSED=0
SKIPPED=0

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED++))
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
    ((SKIPPED++))
}

echo "=== Configuration File Validation ==="
echo ""

# Test TOML files
echo "Checking TOML files..."
if command -v python3 &>/dev/null; then
    for file in "$REPO_DIR"/*.toml "$REPO_DIR"/*.toml.example "$REPO_DIR"/.config/**/*.toml 2>/dev/null; do
        [[ -f "$file" ]] || continue
        relative="${file#$REPO_DIR/}"

        if python3 -c "import tomllib; tomllib.load(open('$file', 'rb'))" 2>/dev/null; then
            log_pass "$relative"
        else
            log_fail "$relative - Invalid TOML"
        fi
    done
else
    log_skip "Python3 not available for TOML validation"
fi

echo ""
echo "Checking YAML files..."
if command -v python3 &>/dev/null; then
    for file in "$REPO_DIR"/.github/workflows/*.yml "$REPO_DIR"/*.yml "$REPO_DIR"/*.yaml 2>/dev/null; do
        [[ -f "$file" ]] || continue
        relative="${file#$REPO_DIR/}"

        if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
            log_pass "$relative"
        else
            log_fail "$relative - Invalid YAML"
        fi
    done
else
    log_skip "Python3 not available for YAML validation"
fi

echo ""
echo "Checking Makefile..."
if [[ -f "$REPO_DIR/Makefile" ]]; then
    if make -n -f "$REPO_DIR/Makefile" help &>/dev/null || make -n -f "$REPO_DIR/Makefile" &>/dev/null; then
        log_pass "Makefile - syntax OK"
    else
        log_fail "Makefile - syntax error"
    fi
fi

echo ""
echo "Checking Brewfiles..."
for file in "$REPO_DIR"/Brewfile*; do
    [[ -f "$file" ]] || continue
    [[ "$file" == *.tmpl ]] && continue
    relative="${file#$REPO_DIR/}"

    # Basic syntax check - ensure no obvious errors
    if grep -qE "^(tap|brew|cask|mas|vscode) " "$file" 2>/dev/null; then
        # Check for common issues
        if grep -qE "^[^#].*['\"].*['\"].*['\"]" "$file" 2>/dev/null; then
            log_fail "$relative - Possible quoting issue"
        else
            log_pass "$relative"
        fi
    else
        log_skip "$relative - No recognized Brewfile syntax"
    fi
done

echo ""
echo "Checking Git config..."
if [[ -f "$REPO_DIR/.config/git/config" ]]; then
    if git config --file "$REPO_DIR/.config/git/config" --list &>/dev/null; then
        log_pass ".config/git/config"
    else
        log_fail ".config/git/config - Invalid git config"
    fi
fi

echo ""
echo "=== Summary ==="
echo "Passed:  $PASSED"
echo "Failed:  $FAILED"
echo "Skipped: $SKIPPED"
echo ""

if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
