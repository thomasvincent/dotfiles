#!/usr/bin/env zsh
# zle_fix.zsh - Fix ZLE module loading issues
# This needs to be loaded before anything that uses ZLE

# Load zle module properly
zmodload zsh/zle 2>/dev/null || true

# Make ZLE setting changes safer
function safe_zle_option() {
  setopt 2>/dev/null || true
}

# Prevent "can't change option: zle" errors
function bindkey_safe() {
  if [[ -o zle ]]; then
    bindkey "$@"
  fi
}

# Export these functions so they're available in the shell
export -f safe_zle_option
export -f bindkey_safe