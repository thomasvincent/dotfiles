#!/usr/bin/env zsh
# compatibility.zsh - Fix common compatibility issues

# Fix common ZLE issues
if [[ -o interactive ]]; then
  # In interactive shells, enable normal behavior
  zmodload zsh/zle 2>/dev/null || true
  setopt zle 2>/dev/null
  setopt monitor 2>/dev/null
else
  # In non-interactive mode (scripts), disable these features
  unsetopt zle 2>/dev/null
  unsetopt monitor 2>/dev/null
fi

# Fix for powerlevel10k gitstatus
export GITSTATUS_LOG_LEVEL=ERROR

# Declare function to suppress warnings
function __p9k_suppress_warning() {
  true
}
