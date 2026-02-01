#!/usr/bin/env bash
# test_functions.sh - Test workflow functions for syntax and basic functionality
#
# Tests:
# 1. Shell syntax validation
# 2. Function definition validation
# 3. No duplicate function names

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
WORKFLOW_DIR="$REPO_DIR/home/dot_zsh"

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

echo "=== Function Validation Tests ==="
echo ""

# Test 1: Syntax check all workflow files
echo "Checking shell syntax..."
for file in "$WORKFLOW_DIR"/*.zsh.tmpl; do
    [[ -f "$file" ]] || continue
    basename="${file##*/}"

    # Create temp file without template markers for syntax check
    temp_file=$(mktemp)
    # Remove chezmoi template syntax for shell parsing
    sed 's/{{[^}]*}}//g' "$file" > "$temp_file"

    if zsh -n "$temp_file" 2>/dev/null; then
        log_pass "Syntax OK: $basename"
    else
        log_fail "Syntax error: $basename"
    fi

    rm -f "$temp_file"
done

echo ""
echo "=== Duplicate Function Detection ==="
echo ""

# Test 2: Check for duplicate function names across all files
ALL_FUNCTIONS=$(mktemp)
for file in "$WORKFLOW_DIR"/*.zsh.tmpl; do
    [[ -f "$file" ]] || continue
    basename="${file##*/}"

    # Extract function names
    grep -oE "^function [a-zA-Z_][a-zA-Z0-9_]*|^[a-zA-Z_][a-zA-Z0-9_]*\(\)" "$file" 2>/dev/null | \
        sed 's/function //' | sed 's/()//' | \
        while read -r func; do
            echo "$func:$basename"
        done
done > "$ALL_FUNCTIONS"

# Find duplicates
DUPLICATES=$(cut -d: -f1 "$ALL_FUNCTIONS" | sort | uniq -d)
if [[ -n "$DUPLICATES" ]]; then
    echo "Duplicate functions found:"
    for dup in $DUPLICATES; do
        files=$(grep "^$dup:" "$ALL_FUNCTIONS" | cut -d: -f2 | tr '\n' ', ' | sed 's/,$//')
        log_warn "Function '$dup' defined in: $files"
    done
else
    log_pass "No duplicate function names found"
fi

rm -f "$ALL_FUNCTIONS"

echo ""
echo "=== Function Count by Module ==="
echo ""

total_functions=0
for file in "$WORKFLOW_DIR"/*.zsh.tmpl; do
    [[ -f "$file" ]] || continue
    basename="${file##*/}"
    name="${basename%.zsh.tmpl}"

    count=$(grep -cE "^function [a-zA-Z_]|^[a-zA-Z_][a-zA-Z0-9_]*\(\)" "$file" 2>/dev/null || echo 0)
    total_functions=$((total_functions + count))
    printf "  %-30s %3d functions\n" "$name" "$count"
done

echo ""
echo "Total functions: $total_functions"

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
