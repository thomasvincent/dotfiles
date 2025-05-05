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
# 1. INITIALIZATION
# ====================================
# Performance monitoring
ZSHRC_START_TIME=$EPOCHREALTIME

# Skip if non-interactive
[[ -o interactive ]] || return 0

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" 2>/dev/null
fi

# ====================================
# 2. ZSH OPTIONS
# ====================================
# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

setopt EXTENDED_HISTORY       # Record timestamp
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first
setopt HIST_IGNORE_DUPS       # Don't record duplicate commands
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt HIST_VERIFY            # Don't execute history expansion immediately
setopt SHARE_HISTORY          # Share history between sessions
setopt INC_APPEND_HISTORY     # Append as commands are executed

# Directory
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push dir to stack on cd
setopt PUSHD_IGNORE_DUPS    # No duplicate dirs in stack
setopt PUSHD_SILENT         # Don't print dir stack after push/pop

# Completion
setopt COMPLETE_IN_WORD     # Complete from cursor position
setopt ALWAYS_TO_END        # Move cursor to end after completion

# Globbing
setopt EXTENDED_GLOB        # Extended globbing syntax

# Job control
setopt LONG_LIST_JOBS       # List jobs in long format by default
setopt NOTIFY               # Report status of background jobs immediately

# General
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells
setopt PROMPT_SUBST         # Parameter expansion in prompts
setopt NO_BEEP              # No beep on error

# ====================================
# 3. ZINIT PLUGIN MANAGER
# ====================================
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" &>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "Warning: Failed to clone zinit. Some features will be disabled."
  fi
fi

if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.zsh"
  
  # Turbo mode - load plugins in the background
  zinit ice wait'0' lucid
  zinit light zsh-users/zsh-autosuggestions
  
  zinit ice wait'0' lucid
  zinit light zsh-users/zsh-syntax-highlighting
  
  zinit ice wait'0' lucid
  zinit light zsh-users/zsh-history-substring-search
  
  # Load prompt
  if [[ -n $P10K_LEAN ]]; then
    # Lean variant of P10K (faster for slow connections/machines)
    zinit ice depth=1
    zinit light romkatv/powerlevel10k
  else
    # Standard P10K (default)
    zinit ice depth=1
    zinit light romkatv/powerlevel10k
  fi
  
  # Additional useful plugins
  zinit ice wait'1' lucid
  zinit light zdharma-continuum/fast-syntax-highlighting
  
  zinit ice wait'1' lucid as"program" pick"fzf-git.sh"
  zinit light junegunn/fzf-git.sh
else
  # Fallback prompt if zinit failed to load
  PS1="%F{blue}%n@%m%f:%F{green}%~%f$ "
fi

# ====================================
# 4. LOAD CONFIGURATION FILES
# ====================================
ZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}/.zsh"

# Create directory structure if it doesn't exist
[[ -d "$ZSH_CONFIG_DIR" ]] || mkdir -p "$ZSH_CONFIG_DIR"/{functions.d,completions,cache}

# Load modules in a specific order
typeset -a config_modules=(
  "$ZSH_CONFIG_DIR/path.zsh"          # Path configuration
  "$ZSH_CONFIG_DIR/env.zsh"           # Environment variables
  "$ZSH_CONFIG_DIR/aliases.zsh"       # Aliases
  "$ZSH_CONFIG_DIR/completions.zsh"   # Completion system
)

# Source configuration modules
for module in "${config_modules[@]}"; do
  [[ -r "$module" ]] && source "$module"
done

# Load all custom function files from functions.d
if [[ -d "$ZSH_CONFIG_DIR/functions.d" ]]; then
  # Add to fpath
  fpath=("$ZSH_CONFIG_DIR/functions.d" $fpath)
  
  # Load functions with numeric prefix first, then others
  for func_file in "$ZSH_CONFIG_DIR"/functions.d/[0-9]*.zsh(N); do
    source "$func_file"
  done
  
  # Then load other function files (without numeric prefix)
  for func_file in "$ZSH_CONFIG_DIR"/functions.d/^[0-9]*.zsh(N); do
    source "$func_file"
  done
fi

# ====================================
# 5. POWERLEVEL10K CONFIGURATION
# ====================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ -f "${ZDOTDIR:-$HOME}/.p10k.zsh" ]] && source "${ZDOTDIR:-$HOME}/.p10k.zsh"

# ====================================
# 6. COMPLETION SYSTEM
# ====================================
# Load completion system if not already loaded
if ! whence -w compdef >/dev/null; then
  # Load zsh completions
  autoload -Uz compinit
  
  # Optimize compinit for faster startup
  # Only rebuild completion dump file once a day
  local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -n ${ZDOTDIR} ]]; then
    zcompdump="${ZDOTDIR}/.zcompdump"
  fi
  
  if [[ -f "$zcompdump" && $(find "$zcompdump" -mtime +1) ]]; then
    compinit -d "$zcompdump"
    touch "$zcompdump"
  else
    compinit -C -d "$zcompdump"
  fi
  
  # Configure completion styles
  # Use caching for slow functions
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
  
  # Settings for completion menu
  zstyle ':completion:*' menu select
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*' completer _expand _complete _ignored _approximate
  
  # Grouping and descriptions
  zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
  zstyle ':completion:*:messages' format '%F{purple} -- %d --%f'
  zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'
  
  # Colors for file types and process listing
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
fi

# ====================================
# 7. KEY BINDINGS
# ====================================
# Emacs key bindings
bindkey -e

# Fix home/end keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# FZF key bindings if installed
[[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]] && source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
[[ -f "/usr/local/opt/fzf/shell/key-bindings.zsh" ]] && source "/usr/local/opt/fzf/shell/key-bindings.zsh"

# ====================================
# 8. TOOL INTEGRATIONS
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

# iTerm2 integration
[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

# ====================================
# 9. LOCAL CUSTOMIZATIONS
# ====================================
# Load local settings that should not be committed to source control
[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"

# ====================================
# 10. FINISHING TOUCHES
# ====================================
# Ensure path arrays don't contain duplicates
typeset -U PATH path fpath

# Report startup time if taking longer than 0.5 seconds
if [[ -n "$ZSHRC_START_TIME" ]]; then
  ZSHRC_END_TIME=$EPOCHREALTIME
  ZSHRC_LOAD_TIME=$(( (ZSHRC_END_TIME - ZSHRC_START_TIME) * 1000 ))
  [[ $ZSHRC_LOAD_TIME -gt 500 ]] && echo "zshrc loaded in ${ZSHRC_LOAD_TIME}ms"
  unset ZSHRC_START_TIME ZSHRC_END_TIME ZSHRC_LOAD_TIME
fi

# Print welcome message (comment this out if you prefer a clean terminal on startup)
# echo "👋 Welcome back, ${USER}!"