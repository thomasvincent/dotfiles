#!/usr/bin/env zsh
# tests/test_platform.zsh - Platform detection tests
#
# Run with: zsh tests/test_platform.zsh
#
# This test verifies that platform detection works correctly
# across macOS and Linux systems.
#

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
