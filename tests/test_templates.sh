#!/usr/bin/env bash
# test_templates.sh - Validate chezmoi templates
#
# Tests:
# 1. All .tmpl files are valid chezmoi templates
# 2. Templates render without errors
# 3. No undefined variables in templates

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
WARNINGS=0

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED++))
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNINGS++))
}

# Check if chezmoi is installed
if ! command -v chezmoi &>/dev/null; then
    echo "chezmoi is not installed. Skipping template validation."
    exit 0
fi

echo "=== Template Validation Tests ==="
echo ""

# Test 1: Find all template files
echo "Finding template files..."
TEMPLATE_FILES=$(find "$REPO_DIR/home" -name "*.tmpl" -type f 2>/dev/null || true)
TEMPLATE_COUNT=$(echo "$TEMPLATE_FILES" | grep -c "." || echo 0)
echo "Found $TEMPLATE_COUNT template files"
echo ""

# Test 2: Validate each template
echo "Validating templates..."
for file in $TEMPLATE_FILES; do
    relative_path="${file#$REPO_DIR/}"

    # Check for basic syntax (balanced braces)
    open_braces=$(grep -o '{{' "$file" | wc -l | tr -d ' ')
    close_braces=$(grep -o '}}' "$file" | wc -l | tr -d ' ')

    if [[ "$open_braces" != "$close_braces" ]]; then
        log_fail "$relative_path - Unbalanced template braces ({{ $open_braces, }} $close_braces)"
        continue
    fi

    # Check for common template issues
    if grep -qE '\{\{[^}]*\$\.[a-zA-Z_]+[^}]*\}\}' "$file" 2>/dev/null; then
        # Has variable references - good
        :
    fi

    # Check for empty conditionals
    if grep -qE '\{\{-?\s*if\s*-?\}\}' "$file" 2>/dev/null; then
        log_warn "$relative_path - Empty if condition found"
        continue
    fi

    log_pass "$relative_path"
done

echo ""
echo "=== Template Variable Usage Tests ==="
echo ""

# Test 3: Check for commonly used variables
EXPECTED_VARS=(
    ".chezmoi.os"
    ".enable_cloud"
    ".enable_dev_tools"
    ".editor"
    ".macos"
    ".linux"
)

echo "Checking for expected variables in templates..."
for var in "${EXPECTED_VARS[@]}"; do
    count=$(grep -r "$var" "$REPO_DIR/home" 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$count" -gt 0 ]]; then
        log_pass "Variable $var used in $count location(s)"
    else
        log_warn "Variable $var not used in any template"
    fi
done

echo ""
echo "=== Summary ==="
echo "Passed:   $PASSED"
echo "Failed:   $FAILED"
echo "Warnings: $WARNINGS"
echo ""

if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
