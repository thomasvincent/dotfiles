#!/bin/bash
#
# Fix common code style issues in the repository
# - Remove trailing whitespace
# - Ensure files end with a newline

# Set strict mode
set -euo pipefail

# Find all files with trailing whitespace and remove it
echo "Removing trailing whitespace from files..."
find . -type f \( -name "*.sh" -o -name "*.tmpl" -o -name "*.zsh" -o -name "*.yml" -o -name "*.md" \) | \
  while read file; do
    if [ -f "$file" ]; then
      sed -i '' -E 's/[[:space:]]+$//' "$file"
    fi
  done

# Ensure all files end with a newline
echo "Ensuring files end with a newline..."
find . -type f \( -name "*.sh" -o -name "*.tmpl" -o -name "*.zsh" -o -name "*.yml" -o -name "*.md" \) | \
  while read file; do
    if [ -f "$file" ] && [ -s "$file" ] && [ "$(tail -c 1 "$file" | wc -l)" -eq 0 ]; then
      echo "" >> "$file"
      echo "Fixed newline: $file"
    fi
  done

echo "Code style fixes complete!"
