#!/bin/bash
# test_shell_startup.sh - Test shell startup for errors
# This script will launch a new zsh shell and check for errors

# Set test mode environment variable
export ZSH_TEST_MODE=1

# Color definitions
RESET="\033[0m"
BLUE="\033[0;34m"
# Other colors defined but not used currently
# Keeping them commented for future use
# GREEN="\033[0;32m"
# RED="\033[0;31m"
# YELLOW="\033[0;33m"

echo -e "${BLUE}Testing ZSH startup...${RESET}"
echo "This will launch a new ZSH shell and check for errors."
echo

# Create test mode setup
mkdir -p .zsh
if [ ! -f ".zsh/test_mode.zsh" ]; then
  cat > ".zsh/test_mode.zsh" << 'EOF'
#!/usr/bin/env zsh
# test_mode.zsh - Configuration for running ZSH in test mode

# Skip certain tasks/plugins in test mode
export ZSH_TEST_MODE=1

# Prevent any interactive prompts
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Keep test output cleaner
setopt NO_BEEP

# Skip loading plugins that might cause errors in test environment
export ZSH_TEST_SKIP_PLUGINS=1

# Disable terminal title updates
export ZSH_DISABLE_TITLE_UPDATE=1

# Override certain functions for testing
function brew() { echo "Brew command stubbed in test mode"; }
EOF
  chmod +x ".zsh/test_mode.zsh"
fi

# Create a temporary script to capture errors
TMP_SCRIPT=$(mktemp /tmp/zsh_test_XXXXXX.zsh)
cat > "$TMP_SCRIPT" << 'EOF'
# Redirect stderr to a file
STDERR_LOG=$(mktemp /tmp/zsh_stderr_XXXXXX.log)
exec 2>"$STDERR_LOG"

# Set up minimal environment for testing
export ZDOTDIR="$PWD"
export ZSH_TEST_MODE=1
export TERM=dumb

# Source .zshrc if it exists, otherwise try dot_zshrc.tmpl
if [[ -f "$ZDOTDIR/.zshrc" ]]; then
  source "$ZDOTDIR/.zshrc" || echo "Error sourcing .zshrc"
elif [[ -f "$ZDOTDIR/home/dot_zshrc.tmpl" ]]; then
  # For CI environment, try to use template directly
  source "$ZDOTDIR/home/dot_zshrc.tmpl" || echo "Error sourcing dot_zshrc.tmpl"
else
  echo "No zshrc file found to test"
  exit 1
fi

# Check for errors
if [[ -s "$STDERR_LOG" ]]; then
  echo ""
  echo "❌ Errors detected during startup:"
  echo "============================"
  cat "$STDERR_LOG"
  echo "============================"
  echo "Please fix these errors in your ZSH configuration."
  exit 1
else
  echo ""
  echo "✅ No errors detected during ZSH startup! Your configuration is working correctly."
fi

# Clean up
rm -f "$STDERR_LOG"
EOF

# Make the script executable
chmod +x "$TMP_SCRIPT"

# Run zsh with the test script
echo "Running test..."
ZSH_TEST_MODE=1 TERM=dumb zsh "$TMP_SCRIPT"
EXIT_CODE=$?

# Clean up
rm -f "$TMP_SCRIPT"

exit $EXIT_CODE
