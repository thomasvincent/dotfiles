#!/bin/bash
#
# Setup Git hooks for the repository
# This installs pre-commit hooks to ensure code quality before commits

set -euo pipefail

# Install pre-commit if not already installed
if ! command -v pre-commit &>/dev/null; then
  echo "Installing pre-commit..."
  if command -v pip3 &>/dev/null; then
    pip3 install pre-commit
  elif command -v pip &>/dev/null; then
    pip install pre-commit
  else
    echo "Error: pip not found. Please install Python and pip first."
    exit 1
  fi
fi

# Install the pre-commit hooks
echo "Installing pre-commit hooks..."
pre-commit install

# Update the hooks to the latest version
echo "Updating pre-commit hook versions..."
pre-commit autoupdate

echo "Git hooks setup complete!"
echo "Run 'pre-commit run --all-files' to verify all files pass the checks."
