#!/bin/bash
# verify_fixes.sh - Verify that all the fixed issues have been resolved
# This script will check for the specific errors we fixed

# Color definitions
RESET="\033[0m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"

echo -e "${BLUE}Verifying fixes for shell startup errors...${RESET}"

# Create a temporary script to capture errors
TMP_SCRIPT=$(mktemp /tmp/zsh_test_XXXXXX.zsh)
TMP_ERR=$(mktemp /tmp/zsh_err_XXXXXX.log)

cat > "$TMP_SCRIPT" << 'EOF'
# Test script to verify shell startup
# Redirect stderr to temp file
exec 2>"$1"

# Source zshrc
source ~/.zshrc

# Exit immediately
exit 0
EOF

chmod +x "$TMP_SCRIPT"

# Run zsh with the script
zsh "$TMP_SCRIPT" "$TMP_ERR"

# Check for specific errors
echo -e "${BLUE}Checking for specific errors...${RESET}"

# Define our error patterns
ERROR_PATTERNS=(
  "unexpected argument '-m'"
  "defining function based on alias"
  "compdef: unknown command or service: docker-compose"
  "parse error near"
)

# Check for each error
for pattern in "${ERROR_PATTERNS[@]}"; do
  if grep -q "$pattern" "$TMP_ERR"; then
    echo -e "${RED}❌ Error still present:${RESET} $pattern"
    grep "$pattern" "$TMP_ERR"
  else
    echo -e "${GREEN}✅ Fixed:${RESET} $pattern"
  fi
done

# Check overall status
if [ -s "$TMP_ERR" ]; then
  echo -e "\n${YELLOW}There are still some errors or warnings in the shell startup:${RESET}"
  cat "$TMP_ERR"
  
  echo -e "\n${YELLOW}These may be warnings that can be safely ignored.${RESET}"
  echo -e "${YELLOW}If you want a completely clean startup, you might need to fix these as well.${RESET}"
else
  echo -e "\n${GREEN}✅ All errors fixed! Your shell now starts without any errors.${RESET}"
fi

# Clean up
rm -f "$TMP_SCRIPT" "$TMP_ERR"

echo -e "\n${BLUE}Done verifying fixes.${RESET}"
echo -e "${BLUE}To test your shell in interactive mode, run:${RESET} ./test_shell_startup.sh"