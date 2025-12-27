#!/usr/bin/env zsh
# =============================================================================
# Shell Aliases and Simple Functions
# =============================================================================
#
# File: ~/.zsh/aliases.zsh
# Purpose: Aliases, shortcuts, and simple functions for common operations
# Optimized for: macOS (with Linux compatibility)
#
# This file is organized into sections:
#   1. General Shell Aliases (navigation, files, directories)
#   2. System Operations (processes, disk, network)
#   3. Development Tools (git, docker, kubernetes)
#   4. Networking
#   5. Quick Edits (config file shortcuts)
#   6. Search & Find
#   7. macOS Specific
#   8. Suffix Aliases (open files by extension)
#   9. Global Aliases (pipe shortcuts)
#   10. Function Aliases (complex operations)
#
# =============================================================================

# =============================================================================
# 1. GENERAL SHELL ALIASES
# =============================================================================
#
# These aliases make everyday shell operations faster.
# Most save just a few keystrokes, but they add up!
#
# =============================================================================

# -----------------------------------------------------------------------------
# Navigation - Moving around the filesystem
# -----------------------------------------------------------------------------
# These use '..' for parent directories, which is muscle memory for most
alias ..='cd ..'                        # Up one level
alias ...='cd ../..'                    # Up two levels
alias ....='cd ../../..'                # Up three levels
alias .....='cd ../../../..'            # Up four levels
alias ~='cd ~'                          # Go to home directory
alias -- -='cd -'                       # Go to previous directory (use just -)

# -----------------------------------------------------------------------------
# Directory Listing - Using exa if available (modern ls replacement)
# -----------------------------------------------------------------------------
# exa provides better output, git integration, and colors
# Falls back to standard ls if exa isn't installed
if command -v exa &>/dev/null; then
  alias ls='exa'                        # Modern ls replacement
  alias l='exa -l'                      # Long format
  alias ll='exa -lah'                   # Long format with hidden files
  alias lsa='exa -la'                   # List all files
  alias la='exa -la'                    # Same as lsa
  alias lt='exa -T'                     # Tree view (great for seeing structure)
  alias lr='exa -R'                     # Recursive view
else
  # Standard ls with macOS color flag (-G)
  alias ls='ls -G'                      # Colorized ls
  alias l='ls -lh'                      # Long format, human-readable sizes
  alias ll='ls -lah'                    # Long format with hidden files
  alias la='ls -lAh'                    # Long format, almost all (no . and ..)
  alias lt='ls -lth'                    # Sort by time, newest first
  alias lr='ls -lR'                     # Recursive listing
fi

# -----------------------------------------------------------------------------
# Directory Operations - Creating and removing directories
# -----------------------------------------------------------------------------
alias mkdir='mkdir -p'                  # Create parent directories as needed
alias md='mkdir -p'                     # Shortcut for mkdir -p
alias rd='rmdir'                        # Remove directory (must be empty)

# -----------------------------------------------------------------------------
# Safe File Operations - Prevent accidental deletions
# -----------------------------------------------------------------------------
# The -i flag prompts before overwriting/deleting
alias rm='rm -i'                        # Ask before deleting
alias cp='cp -i'                        # Ask before overwriting
alias mv='mv -i'                        # Ask before overwriting

# -----------------------------------------------------------------------------
# Quick Directory Access - Jump to common locations
# -----------------------------------------------------------------------------
alias cdc='cd && clear'                 # Go home and clear screen
alias cdp='cd ~/Projects'               # Jump to Projects directory
alias cdd='cd ~/Downloads'              # Jump to Downloads
alias cddoc='cd ~/Documents'            # Jump to Documents
alias showf='open .'                    # Open current directory in Finder (macOS)
alias o='open'                          # Quick open (macOS)

# -----------------------------------------------------------------------------
# File Viewing - Using bat if available (modern cat replacement)
# -----------------------------------------------------------------------------
# bat provides syntax highlighting, line numbers, and git integration
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'        # Use bat without paging
fi
alias diff='diff -u'                    # Unified diff format (easier to read)

# -----------------------------------------------------------------------------
# Path Inspection - See what's in your PATH
# -----------------------------------------------------------------------------
alias path='echo $PATH | tr ":" "\n"'   # Show PATH, one entry per line
alias fpath='echo $FPATH | tr " " "\n"' # Show function path

# =============================================================================
# 2. SYSTEM OPERATIONS
# =============================================================================
#
# Aliases for system information, process management, and maintenance.
#
# =============================================================================

# -----------------------------------------------------------------------------
# Network Information
# -----------------------------------------------------------------------------
alias ip="ipconfig getifaddr en0"       # Get internal IP (WiFi on Mac)
alias pubip="curl -s https://api.ipify.org"  # Get external/public IP
alias myip="echo 'Internal: ' && ip && echo 'External: ' && pubip"

# -----------------------------------------------------------------------------
# System Operations (macOS)
# -----------------------------------------------------------------------------
alias afk="pmset displaysleepnow"       # Lock screen / turn off display
alias logout="osascript -e 'tell application \"System Events\" to log out'"
alias restart="sudo shutdown -r now"    # Restart computer
alias sleep="pmset sleepnow"            # Put Mac to sleep

# -----------------------------------------------------------------------------
# Cleanup - Remove cruft and flush caches
# -----------------------------------------------------------------------------
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"  # Flush DNS
alias cleanup="find . -type f -name '*.DS_Store' -delete"  # Remove .DS_Store files
# Clean everything: Trash, logs, quarantine database
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# -----------------------------------------------------------------------------
# Process Management
# -----------------------------------------------------------------------------
alias psa="ps aux"                      # Show all processes
alias psg="ps aux | grep -v grep | grep -i"  # Search processes
alias psr="ps -ef | grep"               # Another process search
alias ports="sudo lsof -iTCP -sTCP:LISTEN -n -P"  # Show listening ports

# -----------------------------------------------------------------------------
# Disk Usage
# -----------------------------------------------------------------------------
alias dud='du -d 1 -h'                  # Disk usage, depth 1, human-readable
alias duf='du -sh *'                    # Disk usage of current directory items
alias df='df -h'                        # Disk free, human-readable

# -----------------------------------------------------------------------------
# Memory Information
# -----------------------------------------------------------------------------
alias meminfo='top -l 1 -s 0 | grep PhysMem'  # Quick memory summary
alias top_mem='ps -axm -o pid,%mem,command | sort -nr | head -20'  # Top memory users

# =============================================================================
# 3. DEVELOPMENT TOOLS
# =============================================================================
#
# Git, Docker, Kubernetes, and programming language shortcuts.
# These are the most frequently used in daily development work.
#
# =============================================================================

# -----------------------------------------------------------------------------
# Git Shortcuts
# -----------------------------------------------------------------------------
# These complement your .gitconfig aliases - use whatever feels natural
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gst='git status'                  # Muscle memory from oh-my-zsh
alias gcl='git clone'

# -----------------------------------------------------------------------------
# Docker Shortcuts
# -----------------------------------------------------------------------------
if command -v docker &>/dev/null; then
  alias d='docker'
  alias dc='docker-compose'             # Note: docker compose (v2) is built-in now
  alias dps='docker ps'                 # List running containers
  alias di='docker images'              # List images
  alias dlogs='docker logs'             # View container logs
  alias dexec='docker exec -it'         # Exec into container interactively
  alias dstop='docker stop $(docker ps -q)'  # Stop all running containers
  alias dprune='docker system prune -a' # Clean up everything unused
fi

# -----------------------------------------------------------------------------
# Kubernetes Shortcuts (basic - more in kubernetes.zsh)
# -----------------------------------------------------------------------------
# See .zsh/dev/kubernetes.zsh for comprehensive k8s tooling
if command -v kubectl &>/dev/null; then
  alias k='kubectl'
  alias kg='kubectl get'
  alias kgp='kubectl get pods'
  alias kdp='kubectl describe pod'
  alias kl='kubectl logs'
  alias kx='kubectl exec -it'
fi

# -----------------------------------------------------------------------------
# Python Development
# -----------------------------------------------------------------------------
alias py='python3'
alias python='python3'                  # Always use Python 3
alias pip='pip3'                        # Always use pip3
alias serve='python3 -m http.server'    # Quick HTTP server
alias venv='python3 -m venv .venv'      # Create virtual environment
alias act='source .venv/bin/activate'   # Activate virtual environment

# -----------------------------------------------------------------------------
# Node.js / npm Shortcuts
# -----------------------------------------------------------------------------
if command -v npm &>/dev/null; then
  alias ni='npm install'
  alias nid='npm install --save-dev'
  alias nig='npm install -g'
  alias ns='npm start'
  alias nt='npm test'
  alias nb='npm run build'
  alias nr='npm run'
  alias nout='npm outdated'
fi

# =============================================================================
# 4. NETWORKING
# =============================================================================

alias ping='ping -c 5'                  # Ping with 5 packets (don't run forever)
alias wget='wget -c'                    # Resume downloads by default

# Use mtr instead of traceroute if available (better visualization)
if command -v mtr &>/dev/null; then
  alias traceroute='mtr'
fi

# HTTP helpers
alias check_http='curl -Is'             # Check HTTP status
alias check_https='curl -Is https://'   # Check HTTPS status
alias headers='curl -I'                 # Show response headers

# Get current week number
alias week='date +%V'

# =============================================================================
# 5. QUICK EDITS
# =============================================================================
#
# Fast access to frequently edited configuration files.
# Uses $EDITOR, which should be set in your env.zsh.
#
# =============================================================================

alias ez='$EDITOR ~/.zshrc'             # Edit main zsh config
alias ep='$EDITOR ~/.zsh/path.zsh'      # Edit PATH config
alias ea='$EDITOR ~/.zsh/aliases.zsh'   # Edit this file!
alias ee='$EDITOR ~/.zsh/env.zsh'       # Edit environment variables
alias eg='$EDITOR ~/.gitconfig'         # Edit git config
alias ev='$EDITOR ~/.vimrc'             # Edit vim config
alias et='$EDITOR ~/.tmux.conf'         # Edit tmux config

# Reload zsh config without restarting
alias sz='source ~/.zshrc'

# =============================================================================
# 6. SEARCH & FIND
# =============================================================================
#
# Modern alternatives to find and grep when available.
# fd is faster than find, rg (ripgrep) is faster than grep.
#
# =============================================================================

# Use fd if available (faster, respects .gitignore)
if command -v fd &>/dev/null; then
  alias f='fd -t f'                     # Find files
  alias ff='fd -t f'                    # Same as f
  alias fdir='fd -t d'                  # Find directories (renamed from df to avoid conflict)
else
  alias f='find . -name'
  alias ff='find . -type f -name'
  alias fdir='find . -type d -name'
fi

# Use ripgrep if available (faster, respects .gitignore)
if command -v rg &>/dev/null; then
  alias grep='rg'                       # Replace grep with ripgrep
  alias rgi='rg -i'                     # Case insensitive search
  alias rgf='rg -F'                     # Fixed strings (literal match)
else
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
fi

# =============================================================================
# 7. MACOS SPECIFIC
# =============================================================================
#
# macOS-only features and Finder integration.
#
# =============================================================================

# Show/hide hidden files in Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

# Show/hide desktop icons (useful for presentations)
alias hidedesktop="defaults write com.apple.finder CreateDesktop false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop true && killall Finder"

# Spotlight on/off (disable during heavy disk operations)
alias spotlight_on="sudo mdutil -a -i on"
alias spotlight_off="sudo mdutil -a -i off"

# Hide/unhide files in Finder
alias hide='setfile -a V'               # Hide file/folder
alias unhide='setfile -a v'             # Unhide file/folder

# Screenshots
alias ssclear="rm -rf ~/Desktop/*.png"  # Clear screenshot files

# =============================================================================
# 8. SUFFIX ALIASES
# =============================================================================
#
# Zsh feature: automatically open files by extension.
# Example: typing "readme.md" opens it in Marked 2.
#
# =============================================================================

alias -s {md,markdown}='open -a Marked\ 2'
alias -s {html,htm}='open'
alias -s {jpg,jpeg,png,gif,webp}='open -a Preview'
alias -s {pdf,PDF}='open -a Preview'
alias -s {mp4,MP4,mov,MOV}='open -a QuickTime\ Player'
alias -s {doc,docx}='open -a Microsoft\ Word'
alias -s {xls,xlsx}='open -a Microsoft\ Excel'
alias -s {ppt,pptx}='open -a Microsoft\ PowerPoint'
alias -s gz='tar -xzvf'
alias -s zip='unzip'

# =============================================================================
# 9. GLOBAL ALIASES
# =============================================================================
#
# Zsh feature: these can be used anywhere in a command line.
# Example: ls | G pattern  (instead of ls | grep pattern)
#
# =============================================================================

alias -g G='| grep'                     # Pipe to grep
alias -g L='| less'                     # Pipe to less
alias -g H='| head'                     # Pipe to head
alias -g T='| tail'                     # Pipe to tail
alias -g C='| wc -l'                    # Count lines
alias -g S='| sort'                     # Sort output
alias -g SU='| sort | uniq'             # Sort and unique
alias -g SUC='| sort | uniq -c'         # Sort, unique, count
alias -g X='| xargs'                    # Pipe to xargs

# =============================================================================
# 10. FUNCTION ALIASES
# =============================================================================
#
# More complex operations that need shell function syntax.
# These provide additional functionality beyond simple aliases.
#
# =============================================================================

# -----------------------------------------------------------------------------
# extract: Extract any archive format
# -----------------------------------------------------------------------------
# Automatically detects archive type and uses correct tool.
# Usage: extract archive.tar.gz
# -----------------------------------------------------------------------------
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar e "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# -----------------------------------------------------------------------------
# mkcd: Create directory and cd into it
# -----------------------------------------------------------------------------
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# -----------------------------------------------------------------------------
# manpdf: Open man page as PDF in Preview (macOS)
# -----------------------------------------------------------------------------
manpdf() {
  man -t "$1" | open -f -a Preview
}

# -----------------------------------------------------------------------------
# genpass: Generate a secure password
# -----------------------------------------------------------------------------
# Usage: genpass 32    (generates 32 character password)
# -----------------------------------------------------------------------------
genpass() {
  local length=${1:-24}
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()-_=+[]{}|;:,.<>?' </dev/urandom | head -c $length
  echo
}

# -----------------------------------------------------------------------------
# backup: Create a timestamped backup of a file
# -----------------------------------------------------------------------------
# Usage: backup important-file.txt
# Creates: important-file.txt.bak-20251227-120000
# -----------------------------------------------------------------------------
backup() {
  cp "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)"
}

# -----------------------------------------------------------------------------
# killname: Kill process by name
# -----------------------------------------------------------------------------
# Usage: killname firefox
# -----------------------------------------------------------------------------
killname() {
  ps aux | grep "$1" | grep -v "grep" | awk '{print $2}' | xargs kill -9
}

# -----------------------------------------------------------------------------
# colors: Print terminal color palette
# -----------------------------------------------------------------------------
# Useful for testing terminal color support
# -----------------------------------------------------------------------------
colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}m%3d " "${i}"
    (((i+1) % 16)) || printf "\n"
  done
}

# -----------------------------------------------------------------------------
# weather: Get weather report
# -----------------------------------------------------------------------------
# Usage: weather "San Francisco"
# -----------------------------------------------------------------------------
weather() {
  local city="${1:-San Francisco}"
  curl -s "wttr.in/${city}?m1" | head -n 7
}

# -----------------------------------------------------------------------------
# Enhanced cd: Lists directory after changing
# -----------------------------------------------------------------------------
# Comment this out if you find it annoying
# -----------------------------------------------------------------------------
cd() {
  builtin cd "$@" && ls -la
}
