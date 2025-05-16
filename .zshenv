#!/usr/bin/env zsh
# ~/.zshenv - Global ZSH environment configuration
#
# This file is always sourced, for all shells (login, interactive, non-interactive).
# Keep it minimal and focused on setting environment variables and paths.
# Don't include interactive shell configuration here.
#

# ====================================
# XDG BASE DIRECTORY SPECIFICATION
# ====================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ====================================
# ZSH CONFIGURATION DIRECTORY
# ====================================
export ZDOTDIR="${ZDOTDIR:-$HOME}"
export ZSH_CONFIG_DIR="${ZDOTDIR}/.zsh"

# ====================================
# ESSENTIAL ENVIRONMENT VARIABLES
# ====================================
# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Editor
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

# Less
export LESS="-F -R -X --tabs=4"
export LESSCHARSET="utf-8"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
[[ ! -d "$XDG_CACHE_HOME/less" ]] && mkdir -p "$XDG_CACHE_HOME/less"

# ====================================
# MINIMAL PATH CONFIGURATION
# ====================================
# Ensure path arrays don't contain duplicates
typeset -U PATH path

# Set a minimal PATH to be expanded later in .zsh/path.zsh
path=(
  # Homebrew paths (Apple Silicon first, then Intel for backwards compatibility)
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  /usr/local/sbin

  # System directories
  /usr/bin
  /bin
  /usr/sbin
  /sbin
)

# Export PATH
export PATH

# ====================================
# DO NOT PUT INTERACTIVE SHELL CONFIGURATION HERE
# ====================================
# Additional configuration should go in:
# - ~/.zshrc for interactive shell settings
# - ~/.zsh/path.zsh for complete PATH configuration
# - ~/.zsh/env.zsh for additional environment variables
# - ~/.zprofile for login shell settings
