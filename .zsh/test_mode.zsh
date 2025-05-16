#\!/usr/bin/env zsh
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
