#!/usr/bin/env zsh
# macOS Specific Configuration

# Path adjustments for macOS
if [[ -d "/opt/homebrew/bin" ]]; then
  # Apple Silicon Mac
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)"
elif [[ -d "/usr/local/bin" ]]; then
  # Intel Mac
  path=(/usr/local/bin /usr/local/sbin $path)
  eval "$(/usr/local/bin/brew shellenv 2>/dev/null)"
fi

# macOS tools and utilities
if (( ${+commands[defaults]} )); then
  # Show/hide hidden files
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"

  # Show/hide desktop icons
  alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
  alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
fi

# Clipboard support
alias pbp="pbpaste"
alias pbc="pbcopy"

# macOS-specific aliases
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user"
