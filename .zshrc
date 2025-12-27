#!/usr/bin/env zsh
# vim: ft=zsh ts=2 sw=2 sts=2 et
#
# ~/.zshrc - Zsh configuration optimized for macOS
#
# Features:
# - Clear separation of concerns (environment, aliases, functions, etc.)
# - Powerlevel10k with instant prompt for fast startup
# - Efficient plugin management with Zinit
# - Optimized for developer workflows on macOS
# - XDG Base Directory Specification compliance where possible
#

# ====================================
# 1. PERFORMANCE SETUP
# ====================================
# Record startup time and enable performance monitoring
ZSHRC_START_TIME=$EPOCHREALTIME
EPOCHREALTIME_AT_STARTUP=$EPOCHREALTIME

# Load compatibility layer first to prevent errors
[[ -f "${ZDOTDIR:-$HOME}/.zsh/compatibility.zsh" ]] && source "${ZDOTDIR:-$HOME}/.zsh/compatibility.zsh"

# Load performance optimization tools early
[[ -f "${ZDOTDIR:-$HOME}/.zsh/performance.zsh" ]] && source "${ZDOTDIR:-$HOME}/.zsh/performance.zsh"

# ====================================
# 2. INITIALIZATION
# ====================================

# Skip if non-interactive
[[ -o interactive ]] || return 0

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" 2>/dev/null
fi

# ====================================
# 3. CONFIGURATION DIRECTORIES
# ====================================
ZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}/.zsh"

# ====================================
# 4. ZSH OPTIONS
# ====================================
# Load core ZSH settings and options
[[ -f "$ZSH_CONFIG_DIR/core.zsh" ]] && source "$ZSH_CONFIG_DIR/core.zsh"

# ====================================
# 5. PLUGIN MANAGEMENT
# ====================================
# Load enhanced plugin management
[[ -f "$ZSH_CONFIG_DIR/plugins.zsh" ]] && source "$ZSH_CONFIG_DIR/plugins.zsh"

# ====================================
# 6. LOAD CONFIGURATION FILES
# ====================================

# Create directory structure if it doesn't exist
[[ -d "$ZSH_CONFIG_DIR" ]] || mkdir -p "$ZSH_CONFIG_DIR"/{functions.d,completions,cache}

# Load modules in a specific order
typeset -a config_modules=(
  "$ZSH_CONFIG_DIR/platform.zsh"      # Platform detection
  "$ZSH_CONFIG_DIR/homebrew.zsh"      # Homebrew configuration
  "$ZSH_CONFIG_DIR/path.zsh"          # Path configuration
  "$ZSH_CONFIG_DIR/env.zsh"           # Environment variables
  "$ZSH_CONFIG_DIR/aliases.zsh"       # Aliases
  "$ZSH_CONFIG_DIR/completions.zsh"   # Completion system
  "$ZSH_CONFIG_DIR/themes.zsh"        # Terminal themes
  "$ZSH_CONFIG_DIR/backup.zsh"        # Backup and sync
  "$ZSH_CONFIG_DIR/dev/index.zsh"     # Developer environments
)

# Source configuration modules
for module in "${config_modules[@]}"; do
  [[ -r "$module" ]] && source "$module"
done

# Load all custom function files from functions.d
if [[ -d "$ZSH_CONFIG_DIR/functions.d" ]]; then
  # Add to fpath
  fpath=("$ZSH_CONFIG_DIR/functions.d" $fpath)

  # Load all function files dynamically (no hardcoded paths)
  for func_file in "$ZSH_CONFIG_DIR/functions.d/"*.zsh(N); do
    [[ -r "$func_file" ]] && source "$func_file"
  done
fi

# ====================================
# 7. POWERLEVEL10K CONFIGURATION
# ====================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ -f "${ZDOTDIR:-$HOME}/.p10k.zsh" ]] && source "${ZDOTDIR:-$HOME}/.p10k.zsh"

# ====================================
# 8. COMPLETION SYSTEM
# ====================================
# Completion system is now loaded in core.zsh

# ====================================
# Load FZF configuration
[[ -f "$ZSH_CONFIG_DIR/fzf.zsh" ]] && source "$ZSH_CONFIG_DIR/fzf.zsh"

# 9. KEY BINDINGS
# ====================================
# Key bindings are now configured in core.zsh

# FZF key bindings if installed (check both Apple Silicon and Intel paths)
if [[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
elif [[ -f "/usr/local/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
fi

# ====================================
# 10. TOOL INTEGRATIONS
# ====================================
# direnv - directory environment manager
if command -v direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi

# zoxide - smarter cd command
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

# asdf - version manager
if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
  source "$HOME/.asdf/asdf.sh"
elif command -v brew >/dev/null && [[ -f "$(brew --prefix asdf 2>/dev/null)/libexec/asdf.sh" ]]; then
  source "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# pyenv - Python version manager
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# iTerm2 integration
[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

# ====================================
# 11. LOCAL CUSTOMIZATIONS
# ====================================
# Load local settings that should not be committed to source control
[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"

# ====================================
# 12. FINISHING TOUCHES
# ====================================
# Ensure path arrays don't contain duplicates
typeset -U PATH path fpath

# Build BAT cache if needed
if command -v bat &>/dev/null && [[ ! -f "$HOME/.cache/bat/themes.bin" ]]; then
  bat cache --build &>/dev/null || true
fi

# Report startup time if taking longer than 0.5 seconds
if [[ -n "$ZSHRC_START_TIME" ]]; then
  ZSHRC_END_TIME=$EPOCHREALTIME
  ZSHRC_LOAD_TIME=$(( (ZSHRC_END_TIME - ZSHRC_START_TIME) * 1000 ))
  [[ $ZSHRC_LOAD_TIME -gt 500 ]] && echo "zshrc loaded in ${ZSHRC_LOAD_TIME}ms"
  unset ZSHRC_START_TIME ZSHRC_END_TIME ZSHRC_LOAD_TIME
fi

# Welcome message only (no error-prone reporting functions)
echo "👋 Welcome back, ${USER}! Running on $(uname) - Platform: ${PLATFORM:=unknown}"

# ====================================
# 13. BASH COMPLETIONS (Load once)
# ====================================
# Initialize bash completions system (only once)
autoload -U +X bashcompinit && bashcompinit 2>/dev/null

# Add Terraform completion if available
if command -v terraform >/dev/null 2>&1; then
  complete -o nospace -C terraform terraform 2>/dev/null || true
fi

# Add npm global bin to path if exists
[[ -d "$HOME/.npm/bin" ]] && export PATH="$HOME/.npm/bin:$PATH"
