#!/usr/bin/env zsh
# colors.zsh - Shared color definitions for shell scripts
# Source this file to get common color definitions

# Reset
export RESET="\033[0m"

# Regular Colors
export BLACK="\033[0;30m"
export RED="\033[0;31m"
export GREEN="\033[0;32m"
export YELLOW="\033[0;33m"
export BLUE="\033[0;34m"
export PURPLE="\033[0;35m"
export CYAN="\033[0;36m"
export WHITE="\033[0;37m"

# Bold
export BOLD_BLACK="\033[1;30m"
export BOLD_RED="\033[1;31m"
export BOLD_GREEN="\033[1;32m"
export BOLD_YELLOW="\033[1;33m"
export BOLD_BLUE="\033[1;34m"
export BOLD_PURPLE="\033[1;35m"
export BOLD_CYAN="\033[1;36m"
export BOLD_WHITE="\033[1;37m"

# Underline
export UNDERLINE_BLACK="\033[4;30m"
export UNDERLINE_RED="\033[4;31m"
export UNDERLINE_GREEN="\033[4;32m"
export UNDERLINE_YELLOW="\033[4;33m"
export UNDERLINE_BLUE="\033[4;34m"
export UNDERLINE_PURPLE="\033[4;35m"
export UNDERLINE_CYAN="\033[4;36m"
export UNDERLINE_WHITE="\033[4;37m"

# Background
export BG_BLACK="\033[40m"
export BG_RED="\033[41m"
export BG_GREEN="\033[42m"
export BG_YELLOW="\033[43m"
export BG_BLUE="\033[44m"
export BG_PURPLE="\033[45m"
export BG_CYAN="\033[46m"
export BG_WHITE="\033[47m"

# Helper functions
color_echo() {
  local color="$1"
  shift
  echo -e "${color}$*${RESET}"
}

error() {
  color_echo "$BOLD_RED" "ERROR: $*" >&2
}

warning() {
  color_echo "$BOLD_YELLOW" "WARNING: $*" >&2
}

info() {
  color_echo "$BOLD_BLUE" "INFO: $*"
}

success() {
  color_echo "$BOLD_GREEN" "SUCCESS: $*"
}

# Detect if terminal supports colors
has_colors() {
  if [ -t 1 ] && [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
    return 0
  else
    return 1
  fi
}

# Disable colors if terminal doesn't support them
if ! has_colors; then
  # Reset all color variables to empty strings
  RESET=""
  BLACK=""
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  PURPLE=""
  CYAN=""
  WHITE=""
  BOLD_BLACK=""
  BOLD_RED=""
  BOLD_GREEN=""
  BOLD_YELLOW=""
  BOLD_BLUE=""
  BOLD_PURPLE=""
  BOLD_CYAN=""
  BOLD_WHITE=""
  UNDERLINE_BLACK=""
  UNDERLINE_RED=""
  UNDERLINE_GREEN=""
  UNDERLINE_YELLOW=""
  UNDERLINE_BLUE=""
  UNDERLINE_PURPLE=""
  UNDERLINE_CYAN=""
  UNDERLINE_WHITE=""
  BG_BLACK=""
  BG_RED=""
  BG_GREEN=""
  BG_YELLOW=""
  BG_BLUE=""
  BG_PURPLE=""
  BG_CYAN=""
  BG_WHITE=""
fi
