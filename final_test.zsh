#!/usr/bin/env zsh
# Final test for dotfiles installation

echo "Testing dotfiles installation..."

# Source the dotfiles
source ~/.zshrc

# Test platform detection
echo "Platform: $PLATFORM"

# Test command/utility availability
echo "\nTesting utility functions:"
type -f brewup &>/dev/null && echo "✅ Homebrew functions loaded" || echo "❌ Homebrew functions not loaded"
type -f dotfiles &>/dev/null && echo "✅ Dotfiles management functions loaded" || echo "❌ Dotfiles management functions not loaded"
type -f theme &>/dev/null && echo "✅ Theme functions loaded" || echo "❌ Theme functions not loaded"
type -f platform &>/dev/null && echo "✅ Platform functions loaded" || echo "❌ Platform functions not loaded"

# Test platforms directory
if [[ -d ~/.zsh/platforms ]]; then
  echo "✅ Platforms directory exists"
  ls -la ~/.zsh/platforms
else
  echo "❌ Platforms directory missing"
fi

# Test if platform-specific file is loaded
echo "\nTesting platform-specific configuration:"
if [[ "$PLATFORM" == "mac" ]]; then
  type -f showfiles &>/dev/null && echo "✅ macOS functions loaded" || echo "❌ macOS functions not loaded"
fi

echo "\nTest complete"