#!/bin/bash
# test_shell_startup.sh - Test shell startup for errors
# This script will launch a new zsh shell and check for errors

# Set test mode environment variable
export ZSH_TEST_MODE=1

# Color definitions
RESET="\033[0m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"

echo -e "${BLUE}Testing ZSH startup...${RESET}"
echo "This will launch a new ZSH shell and check for errors."
echo "Press Ctrl+D to exit the test shell once it starts."
echo

# Create a temporary script to capture errors
TMP_SCRIPT=$(mktemp /tmp/zsh_test_XXXXXX.zsh)
cat > "$TMP_SCRIPT" << 'EOF'
# Redirect stderr to a file
STDERR_LOG=$(mktemp /tmp/zsh_stderr_XXXXXX.log)
exec 2>"$STDERR_LOG"

# Source zshrc
source ~/.zshrc

# Check for errors
if [[ -s "$STDERR_LOG" ]]; then
  echo ""
  echo "❌ Errors detected during startup:"
  echo "============================"
  cat "$STDERR_LOG"
  echo "============================"
  echo "Please fix these errors in your ZSH configuration."
else
  echo ""
  echo "✅ No errors detected during ZSH startup! Your configuration is working correctly."
fi

# Clean up
rm -f "$STDERR_LOG"

# Show a message about exiting
echo ""
echo "Test shell started. Press Ctrl+D to exit and return to your regular shell."
echo ""
EOF

# Make the script executable
chmod +x "$TMP_SCRIPT"

# Run zsh with the test script
# Use a custom, minimal profile for tests
ZSH_TEST_MODE=1 ZDOTDIR=/Users/thomasvincent/dotfiles/.zsh TERM=dumb zsh -c 'source /Users/thomasvincent/dotfiles/.zsh/test_mode.zsh; echo "Running actual test..."; source "$TMP_SCRIPT"'

# Clean up
rm -f "$TMP_SCRIPT"