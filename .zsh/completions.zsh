#!/usr/bin/env zsh
# ~/.zsh/completions.zsh - ZSH completion configuration
#
# This file configures the ZSH completion system.
# It optimizes completion behavior for macOS and common tools.
#

# ====================================
# 1. COMPLETION SYSTEM INITIALIZATION
# ====================================
# Load and initialize the completion system
autoload -Uz compinit

# Optimize completion dump file regeneration
# Only rebuild the completion cache once per day
local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n ${ZDOTDIR} ]]; then
  zcompdump="${ZDOTDIR}/.zcompdump"
fi

# Check the last modification time of the dump file
if [[ -f "$zcompdump" && $(find "$zcompdump" -mtime +1) ]]; then
  # If older than 1 day, rebuild the dump file
  compinit -d "$zcompdump"
  # Touch the file to prevent slow loading
  touch "$zcompdump"
else
  # Otherwise, load with -C to avoid security checks
  compinit -C -d "$zcompdump"
fi

# Completion cache directory
local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ ! -d "$cache_dir" ]] && mkdir -p "$cache_dir"

# ====================================
# 2. COMPLETION STYLE CONFIGURATION
# ====================================
# Use caching for slow functions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$cache_dir/zcompcache"

# Set output format for completion
zstyle ':completion:*:descriptions' format '%F{yellow}%B--- %d ---%b%f'
zstyle ':completion:*:messages' format '%F{green}%B-- %d --%b%f'
zstyle ':completion:*:warnings' format '%F{red}%B-- No matches found --%b%f'

# Group matches and describe groups
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'

# Approximate matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Smart case completion (case-insensitive if no case specified)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Command completion order
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

# Auto-complete processes for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Use colors in file completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Display menu if more than 2 options
zstyle ':completion:*' menu select=2

# Rehash automatically (when new binaries are installed)
zstyle ':completion:*' rehash true

# Verbose completion results
zstyle ':completion:*' verbose true

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# Don't complete uninteresting files in less command
zstyle ':completion:*:*:less:*' ignored-patterns '*?.o' '*?.pyc' '*?.swp'

# ====================================
# 3. TOOL-SPECIFIC COMPLETIONS
# ====================================
# Git completions
if [[ -f /opt/homebrew/share/zsh/site-functions/_git ]]; then
  zstyle ':completion:*:*:git:*' script /opt/homebrew/share/zsh/site-functions/_git
elif [[ -f /usr/local/share/zsh/site-functions/_git ]]; then
  zstyle ':completion:*:*:git:*' script /usr/local/share/zsh/site-functions/_git
fi

# SSH completion - use hosts from ~/.ssh/config
if [[ -f ~/.ssh/config ]]; then
  zstyle -e ':completion:*:(ssh|scp|sftp|rsync):*' hosts 'reply=(${=${${(f)"$(cat ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null)"}%%\#*}##host(name)?[[:space:]]##})' 
fi

# Kubectl completion
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh 2>/dev/null)
  # kubectl aliases
  compdef k=kubectl
fi

# Docker completion
if command -v docker &>/dev/null; then
  zstyle ':completion:*:*:docker:*' option-stacking yes
  zstyle ':completion:*:*:docker-*:*' option-stacking yes
  # docker aliases
  compdef d=docker
fi

# Docker Compose completion
if command -v docker-compose &>/dev/null; then
  zstyle ':completion:*:*:docker-compose:*' option-stacking yes
  # docker-compose aliases
  compdef dc=docker-compose
fi

# Terraform completion
if command -v terraform &>/dev/null; then
  # Use zsh-compatible completion instead of the problematic complete command
  autoload -U +X bashcompinit && bashcompinit
  terraform -install-autocomplete 2>/dev/null || true
  # terraform aliases
  compdef tf=terraform 2>/dev/null || true
fi

# Homebrew completion
if command -v brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# ====================================
# 4. CUSTOM COMPLETIONS
# ====================================
# Load custom completions from ~/.zsh/completions
custom_completions="${ZDOTDIR:-$HOME}/.zsh/completions"
if [[ -d "$custom_completions" ]]; then
  fpath=("$custom_completions" $fpath)
  
  # Load custom completion files
  for file in "$custom_completions"/_*(N); do
    [[ -f "$file" ]] && compinit -C -d "$zcompdump"
  done
fi

# ====================================
# 5. COMPLETION BEHAVIOR SETTINGS
# ====================================
# Automatically complete directory names
setopt AUTO_PARAM_SLASH
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Disable inserting a tab character (default on macOS)
setopt NO_LIST_BEEP  # No beeping on ambiguous completions
unsetopt MENU_COMPLETE 

# Allow selection from completion menu using arrow keys
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift+Tab to go back in menu
bindkey -M menuselect '^P' up-line-or-history       # Ctrl+P for previous
bindkey -M menuselect '^N' down-line-or-history     # Ctrl+N for next
bindkey -M menuselect '^E' end-of-line              # Ctrl+E end of line
bindkey -M menuselect '^A' beginning-of-line        # Ctrl+A beginning of line