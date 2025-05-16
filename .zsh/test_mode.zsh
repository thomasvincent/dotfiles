#!/usr/bin/env zsh
# test_mode.zsh - Special configuration for test environments
# This file is loaded by the test framework directly

# Basic, minimal zsh configuration for test environments
unsetopt zle
unsetopt monitor

# Basic prompt
PS1="%# "

# Report back with minimal success message
echo "ZSH Test Mode Active - Using simplified configuration"

# Return immediately
return 0
