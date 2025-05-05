#!/usr/bin/env zsh
# ~/.zsh/aliases.zsh - Aliases and simple functions
#
# This file contains aliases, simple functions, and shortcuts
# for common operations optimized for macOS.
#

# ====================================
# 1. GENERAL SHELL ALIASES
# ====================================
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'                   # Go to previous directory with -

# Directory listing (use exa if available)
if command -v exa &>/dev/null; then
  alias ls='exa'
  alias l='exa -l'
  alias ll='exa -lah'
  alias lsa='exa -la'
  alias la='exa -la'
  alias lt='exa -T'                 # Tree view
  alias lr='exa -R'                 # Recursive view
else
  alias ls='ls -G'                  # macOS colorized ls
  alias l='ls -lh'
  alias ll='ls -lah'
  alias la='ls -lAh'
  alias lt='ls -lth'
  alias lr='ls -lR'
fi

# Directory operations
alias mkdir='mkdir -p'              # Create parent directories
alias md='mkdir -p'
alias rd='rmdir'
alias rm='rm -i'                    # Interactive rm by default
alias cp='cp -i'                    # Interactive cp by default
alias mv='mv -i'                    # Interactive mv by default

# Navigation & Finder
alias cdc='cd && clear'
alias cdp='cd ~/Projects'
alias cdd='cd ~/Downloads'
alias cddoc='cd ~/Documents'
alias showf='open .'               # Show current directory in Finder
alias o='open'                     # Quick open files/directories
alias hide='setfile -a V'          # Hide file/folder in Finder
alias unhide='setfile -a v'        # Unhide file/folder in Finder

# File commands
alias cat='cat'                     # Replace with bat if you have it installed
alias diff='diff -u'               # Unified diff format
command -v bat &>/dev/null && alias cat='bat --paging=never'
alias path='echo $PATH | tr ":" "\n"'
alias fpath='echo $FPATH | tr " " "\n"'

# ====================================
# 2. SYSTEM OPERATIONS
# ====================================
# System information
alias ip="ipconfig getifaddr en0"   # Get internal IP
alias pubip="curl -s https://api.ipify.org"  # Get external IP
alias myip="echo 'Internal: ' && ip && echo 'External: ' && pubip"

# System operations
alias afk="pmset displaysleepnow"   # Lock screen
alias logout="osascript -e 'tell application \"System Events\" to log out'"
alias restart="sudo shutdown -r now"
alias sleep="pmset sleepnow"

# Clean up macOS
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"  # Flush DNS
alias cleanup="find . -type f -name '*.DS_Store' -delete"            # Delete .DS_Store files
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Process management
alias psa="ps aux"
alias psg="ps aux | grep -v grep | grep -i"
alias psr="ps -ef | grep"
alias ports="sudo lsof -iTCP -sTCP:LISTEN -n -P" # Show listening ports

# Disk usage
alias dud='du -d 1 -h'              # Disk usage with depth = 1 and human-readable
alias duf='du -sh *'                # Disk usage of files and folders (1 level)
alias df='df -h'                    # Human-readable disk free

# Memory usage
alias meminfo='top -l 1 -s 0 | grep PhysMem'
alias top_mem='ps -axm -o pid,%mem,command | sort -nr | head -20'

# ====================================
# 3. DEVELOPMENT TOOLS
# ====================================
# Git shortcuts (use on top of .gitconfig aliases)
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
alias gst='git status'
alias gcl='git clone'

# Docker shortcuts
if command -v docker &>/dev/null; then
  alias d='docker'
  alias dc='docker-compose'
  alias dps='docker ps'
  alias di='docker images'
  alias dlogs='docker logs'
  alias dexec='docker exec -it'
  alias dstop='docker stop $(docker ps -q)'
  alias dprune='docker system prune -a'
fi

# Kubernetes shortcuts
if command -v kubectl &>/dev/null; then
  alias k='kubectl'
  alias kg='kubectl get'
  alias kgp='kubectl get pods'
  alias kdp='kubectl describe pod'
  alias kl='kubectl logs'
  alias kx='kubectl exec -it'
fi

# Python/development shortcuts
alias py='python3'
alias python='python3'
alias pip='pip3'
alias serve='python3 -m http.server'   # Simple HTTP server
alias venv='python3 -m venv .venv'     # Create virtual environment
alias act='source .venv/bin/activate'  # Activate virtual environment

# Node/npm shortcuts
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

# ====================================
# 4. NETWORKING
# ====================================
# Ping with 5 packets by default
alias ping='ping -c 5'

# Wget/cURL with resume by default
alias wget='wget -c'

# Enhanced traceroute (using mtr if available)
if command -v mtr &>/dev/null; then
  alias traceroute='mtr'
fi

# HTTP server status check
alias check_http='curl -Is'
alias check_https='curl -Is https://'
alias headers='curl -I'

# Get week number
alias week='date +%V'

# ====================================
# 5. QUICK EDITS
# ====================================
# Quick edits for config files
alias ez='$EDITOR ~/.zshrc'
alias ep='$EDITOR ~/.zsh/path.zsh'
alias ea='$EDITOR ~/.zsh/aliases.zsh'
alias ee='$EDITOR ~/.zsh/env.zsh'
alias eg='$EDITOR ~/.gitconfig'
alias ev='$EDITOR ~/.vimrc'
alias et='$EDITOR ~/.tmux.conf'

# Reload ZSH config
alias sz='source ~/.zshrc'

# ====================================
# 6. SEARCH & FIND
# ====================================
# Find aliases (use fd if available)
if command -v fd &>/dev/null; then
  alias find='fd'
else
  alias f='find . -name'
  alias ffind='find . -type f -name'
  alias dfind='find . -type d -name'
fi

# Grep aliases (use ripgrep if available)
if command -v rg &>/dev/null; then
  alias grep='rg'
  alias rgi='rg -i'  # Case insensitive
  alias rgf='rg -F'  # Fixed strings (literal match)
else
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
fi

# ====================================
# 7. MACOS SPECIFIC
# ====================================
# Show/hide hidden files in Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

# Show/hide desktop icons
alias hidedesktop="defaults write com.apple.finder CreateDesktop false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop true && killall Finder"

# Spotlight
alias spotlight_on="sudo mdutil -a -i on"
alias spotlight_off="sudo mdutil -a -i off"

# Screenshots
alias ssclear="rm -rf ~/Desktop/*.png"  # Clear screenshot files
alias ssfolder="open ~/Desktop/Screenshots"  # Open screenshot folder

# ====================================
# 8. SUFFIX ALIASES (Open files by type)
# ====================================
# Automatically open files with appropriate applications
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

# ====================================
# 9. GLOBAL ALIASES
# ====================================
# These can be used anywhere in the command line (not just at beginning)
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g C='| wc -l'
alias -g S='| sort'
alias -g SU='| sort | uniq'
alias -g SUC='| sort | uniq -c'
alias -g X='| xargs'

# ====================================
# 10. FUNCTION ALIASES
# ====================================
# Extract archive based on extension
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create a directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Open man page as PDF
manpdf() {
  man -t "$1" | open -f -a Preview
}

# Quick find file
ff() { find . -type f -name "*$1*" -ls; }

# Quick grep in files
grepf() { grep -r "$1" .; }

# Enhanced cd that lists directory after changing to it
cd() {
  builtin cd "$@"
  ls -la
}

# Generate a secure password
genpass() {
  local length=${1:-24}
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()-_=+[]{}|;:,.<>?' </dev/urandom | head -c $length
  echo
}

# Create a backup of a file with date stamp
backup() {
  cp "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)"
}

# Kill process by name
killname() {
  ps aux | grep "$1" | grep -v "grep" | awk '{print $2}' | xargs kill -9
}

# Print available colors
colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}m%3d " "${i}"
    (((i+1) % 16)) || printf "\n"
  done
}

# Weather function
weather() {
  local city="${1:-San Francisco}"
  curl -s "wttr.in/${city}?m1" | head -n 7
}

# Add other useful function aliases below