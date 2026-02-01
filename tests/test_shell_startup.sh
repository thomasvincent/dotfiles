#!/bin/bash
# tests/test_shell_startup.sh - Shell startup test
#
# Run with: bash tests/test_shell_startup.sh
#
# This script tests that the shell starts without errors.
# Used by CI/CD to verify dotfiles don't break shell startup.
#

set -e

echo "Testing shell startup..."

# Create a temporary error log
TMP_ERR=$(mktemp)

# Start zsh and capture any errors
if zsh -i -c 'exit 0' 2>"$TMP_ERR"; then
  if [[ -s "$TMP_ERR" ]]; then
    echo "Warning: Shell started but produced errors:"
    cat "$TMP_ERR"
    rm -f "$TMP_ERR"
    exit 1
  else
    echo "✅ Shell started successfully with no errors"
    rm -f "$TMP_ERR"
    exit 0
  fi
else
  echo "❌ Shell failed to start"
  cat "$TMP_ERR"
  rm -f "$TMP_ERR"
  exit 1
fi
