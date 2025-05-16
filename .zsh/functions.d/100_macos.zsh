#!/usr/bin/env zsh
# macOS-specific functions

# Lock the screen
lock() {
  /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
}

# Force empty trash (renamed to avoid conflict with alias)
function empty_trash() {
  rm -rf ~/.Trash/* && echo "Trash emptied"
}
alias emptytrash='empty_trash'

# Show/hide hidden files in Finder
showhidden() {
  defaults write com.apple.finder AppleShowAllFiles -bool true
  killall Finder
}

hidehidden() {
  defaults write com.apple.finder AppleShowAllFiles -bool false
  killall Finder
}

# Clean up LaunchServices to remove duplicates in the "Open With" menu
cleanupls() {
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
  echo "Open With menu has been rebuilt, Finder will restart..."
  killall Finder
}

# Clean up .DS_Store files from a directory
cleanup_ds_store() {
  local dir=${1:-"$PWD"}
  find "$dir" -type f -name ".DS_Store" -delete
  echo "Removed .DS_Store files from $dir"
}

# Show system information
sysinfo() {
  echo "Mac OS X Information"
  echo "-------------------"
  sw_vers
  echo
  echo "System Information"
  echo "-------------------"
  system_profiler SPSoftwareDataType SPHardwareDataType SPStorageDataType | grep -v "UUID\|Serial\|MAC Address"
}

# Flush DNS cache
function flush_dns_cache() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  echo "DNS cache flushed"
}
alias flushdns='flush_dns_cache'

# Show current network information
netinfo() {
  echo "Network Interfaces:"
  ifconfig | grep -e "^[a-z]" -e "inet "

  echo -e "\nIP Addresses:"
  ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'

  echo -e "\nDNS Servers:"
  scutil --dns | grep 'nameserver\[[0-9]*\]' | sort -u

  echo -e "\nExternal IP:"
  curl -s https://api.ipify.org
}

# Convert image to different format
# Usage: convertimg input.png output.jpg
convertimg() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: convertimg input.png output.jpg"
    return 1
  fi

  if ! command -v sips &> /dev/null; then
    echo "sips command not found, cannot convert image"
    return 1
  fi

  sips -s format "${2##*.}" "$1" --out "$2"
}

# Take a screenshot of an area and save it to the desktop
# Usage: screenshot filename.png
screenshot() {
  if [ -z "$1" ]; then
    echo "Usage: screenshot filename.png"
    return 1
  fi

  local output="$HOME/Desktop/$1"
  screencapture -i "$output"
  echo "Screenshot saved to $output"
}

# Start a simple HTTP server
# Usage: serve_http [port]
function serve_http() {
  local port=${1:-8000}
  echo "Starting HTTP server at http://localhost:$port/"
  python3 -m http.server "$port"
}
alias serve='serve_http'

# Homebrew update, upgrade, and cleanup
brewup() {
  brew update && brew upgrade && brew cleanup
  echo "Homebrew packages updated and cleaned"
}
