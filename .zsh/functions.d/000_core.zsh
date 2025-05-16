#!/usr/bin/env zsh
# Core utility functions

# Reload ZSH configuration
reload() {
  source "$HOME/.zshrc"
  echo "ZSH configuration reloaded"
}

# Manage dotfiles (function renamed to avoid conflict with alias)
function goto_dotfiles() {
  cd "$HOME/dotfiles" 2>/dev/null || echo "Dotfiles directory not found"
}
alias dotfiles='goto_dotfiles'

# Print the directory structure in a tree format
treedir() {
  local depth=${1:-2}
  find . -maxdepth "$depth" -type d -not -path "*/\.*" | sort | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"
}

# Create a directory and cd into it
mcd() {
  mkdir -p "$1" && cd "$1" || return
}

# Simple countdown function
countdown() {
  local seconds=${1:-10}
  local start=$(($(date +%s) + seconds))
  while [ "$start" -ge $(date +%s) ]; do
    echo -ne "$(date -u --date @$((start - $(date +%s))) +%H:%M:%S)\r"
    sleep 0.1
  done
  echo "Countdown finished!"
}

# Print the current directory path with each directory on a new line
dirpath() {
  echo -e "${PWD//\//\\n/}"
}

# Quick backup file
bak() {
  cp "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)"
  echo "Backup created: $1.bak-$(date +%Y%m%d-%H%M%S)"
}

# Extract most archive formats
extract() {
  if [ -f "$1" ] ; then
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

# Display disk usage of current directory, sorted
function disk_usage_dir() {
  du -d ${1:-1} -h | sort -hr
}
alias dud='disk_usage_dir'
