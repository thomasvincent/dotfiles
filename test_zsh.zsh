#!/usr/bin/env zsh
# Test ZSH configuration loading

echo "Testing ZSH configuration..."

# Platform detection
OS=$(uname)
echo "OS detected: $OS"

if [[ "$OS" == "Darwin" ]]; then
  echo "This is macOS"
  PLATFORM="mac"
elif [[ "$OS" == "Linux" ]]; then
  echo "This is Linux"
  PLATFORM="linux"
else
  echo "Unknown OS"
  PLATFORM="unknown"
fi

echo "Platform set to: $PLATFORM"

# Print environment
echo "\nEnvironment variables:"
echo "HOME: $HOME"
echo "ZDOTDIR: $ZDOTDIR"
echo "PATH: $PATH"

# Check if key files exist
echo "\nChecking key files:"
[[ -f ~/.zshrc ]] && echo "~/.zshrc exists" || echo "~/.zshrc missing"
[[ -f ~/.zsh/platform.zsh ]] && echo "~/.zsh/platform.zsh exists" || echo "~/.zsh/platform.zsh missing"
[[ -f ~/.zsh/platforms/mac.zsh ]] && echo "~/.zsh/platforms/mac.zsh exists" || echo "~/.zsh/platforms/mac.zsh missing"

echo "\nTest complete"