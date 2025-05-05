#!/usr/bin/env zsh
# ~/.zsh/env.zsh - Environment variables configuration
#
# This file sets environment variables for applications and tools.
# It follows macOS best practices for environment configuration.
#

# ====================================
# 1. CORE ENVIRONMENT
# ====================================
# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="/tmp/runtime-$USER"
[[ ! -d "$XDG_RUNTIME_DIR" ]] && mkdir -p "$XDG_RUNTIME_DIR" && chmod 0700 "$XDG_RUNTIME_DIR"

# Default programs
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
export BROWSER="open"  # macOS-specific default browser command

# ====================================
# 2. SHELL BEHAVIOR
# ====================================
# Less
export LESS="-F -R -X --tabs=4"
export LESSCHARSET="utf-8"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
[[ ! -d "$XDG_CACHE_HOME/less" ]] && mkdir -p "$XDG_CACHE_HOME/less"

# Default options for common commands
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"
export CLICOLOR=1
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"  # macOS ls colors
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34"

# ====================================
# 3. DEVELOPMENT TOOLS
# ====================================
# Node.js
export NODE_ENV="development"

# Python
export PYTHONDONTWRITEBYTECODE=1  # Don't create .pyc files
export PYTHONUNBUFFERED=1         # Unbuffered output for Python apps
export VIRTUAL_ENV_DISABLE_PROMPT=1  # Use shell prompt instead
export PYTHON_HISTORY="$XDG_CACHE_HOME/python/history"
[[ ! -d "$XDG_CACHE_HOME/python" ]] && mkdir -p "$XDG_CACHE_HOME/python"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"

# Ruby/Gems
export GEM_HOME="$HOME/.gem/ruby"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
[[ ! -d "$XDG_CACHE_HOME/gem" ]] && mkdir -p "$XDG_CACHE_HOME/gem"

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
[[ ! -d "$XDG_CONFIG_HOME/docker" ]] && mkdir -p "$XDG_CONFIG_HOME/docker"

# AWS
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
[[ ! -d "$XDG_CONFIG_HOME/aws" ]] && mkdir -p "$XDG_CONFIG_HOME/aws"

# ====================================
# 4. HISTORY SETTINGS
# ====================================
# History file location
export HISTFILE="$HOME/.zsh_history"  # Can be changed to $XDG_DATA_HOME/zsh/history if preferred
export HISTSIZE=50000                 # Number of commands to keep in memory
export SAVEHIST=50000                 # Number of commands to save to disk

# ====================================
# 5. MACOS SPECIFIC
# ====================================
# Homebrew
export HOMEBREW_NO_ANALYTICS=1        # Disable Homebrew's analytics
export HOMEBREW_NO_ENV_HINTS=1        # Disable environment hints
export HOMEBREW_NO_AUTO_UPDATE=1      # Disable auto-update (you control when to update)
export HOMEBREW_AUTOREMOVE=1          # Remove unused dependencies on upgrade

# macOS app defaults
export SCREENSHOTS_DIR="$HOME/Desktop/Screenshots"  # macOS screenshot directory
[[ ! -d "$SCREENSHOTS_DIR" ]] && mkdir -p "$SCREENSHOTS_DIR"

# Security
export GPG_TTY=$(tty)                 # Required for GPG

# ====================================
# 6. APPLICATION SPECIFIC
# ====================================
# FZF Configuration
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --reverse --border --inline-info --preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# Bat (cat alternative)
export BAT_THEME="Monokai Extended"
export BAT_STYLE="numbers,changes,header"
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config"

# Ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
[[ ! -d "$XDG_CONFIG_HOME/ripgrep" ]] && mkdir -p "$XDG_CONFIG_HOME/ripgrep"

# ====================================
# 7. CUSTOM USER VARIABLES
# ====================================
# Add your custom environment variables here
export PROJECTS_DIR="$HOME/Projects"  # Personal projects directory

# Check if we're running on a remote host via SSH
[[ -n "$SSH_CONNECTION" ]] && export IS_REMOTE_HOST=1

# Load any secret/private environment variables from a separate file
[[ -f "$HOME/.zsh/secrets.zsh" ]] && source "$HOME/.zsh/secrets.zsh"