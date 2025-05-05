#!/usr/bin/env zsh
# Test platform detection

SYSTEM=$(uname)
echo "System is: $SYSTEM"

if [[ "$SYSTEM" == "Darwin" ]]; then
  PLATFORM="mac"
  echo "Set platform to: $PLATFORM"
else
  PLATFORM="other"
  echo "Set platform to: $PLATFORM"
fi

echo "Final platform value: $PLATFORM"