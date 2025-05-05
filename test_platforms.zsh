#!/usr/bin/env zsh
# Test platform detection

export PLATFORM=""

# Simple platform detection
case "$(uname)" in
  Darwin)
    export PLATFORM="mac"
    echo "Detected macOS"
    ;;
  Linux)
    export PLATFORM="linux"
    echo "Detected Linux"
    ;;
  *)
    export PLATFORM="unknown"
    echo "Detected unknown platform"
    ;;
esac

echo "Platform set to: $PLATFORM"

# Create platform directory if it doesn't exist
PLATFORMS_DIR="$HOME/.zsh/platforms"
[[ ! -d "$PLATFORMS_DIR" ]] && mkdir -p "$PLATFORMS_DIR"

# Create macOS platform file if it doesn't exist
if [[ "$PLATFORM" == "mac" && ! -f "$PLATFORMS_DIR/mac.zsh" ]]; then
  echo "Creating macOS platform file"
  cat > "$PLATFORMS_DIR/mac.zsh" << 'EOL'
# macOS specific settings
export MACOS_VERSION=$(sw_vers -productVersion)
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
echo "Loaded macOS specific settings"
EOL
fi

# Source platform-specific file
PLATFORM_FILE="$PLATFORMS_DIR/$PLATFORM.zsh"
if [[ -f "$PLATFORM_FILE" ]]; then
  echo "Sourcing platform file: $PLATFORM_FILE"
  source "$PLATFORM_FILE"
  echo "Platform file loaded successfully"
else
  echo "No platform file found at: $PLATFORM_FILE"
fi