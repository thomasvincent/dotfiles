#!/usr/bin/env zsh
# ~/.zsh/functions.d/700_macos.zsh - macOS-specific functions
#
# This file contains functions that interact with macOS-specific features.
# These functions are optimized for improving macOS workflows.
#

# ====================================
# 1. FINDER AND FILE MANAGEMENT
# ====================================
# Show/hide hidden files in Finder
showhidden() {
  defaults write com.apple.finder AppleShowAllFiles -bool true
  killall Finder
  echo "Hidden files are now visible in Finder"
}

hidehidden() {
  defaults write com.apple.finder AppleShowAllFiles -bool false
  killall Finder
  echo "Hidden files are now hidden in Finder"
}

# Show/hide desktop icons
hidedesktop() {
  defaults write com.apple.finder CreateDesktop -bool false
  killall Finder
  echo "Desktop icons are now hidden"
}

showdesktop() {
  defaults write com.apple.finder CreateDesktop -bool true
  killall Finder
  echo "Desktop icons are now visible"
}

# Clean up .DS_Store files
cleanup_ds_store() {
  find "${1:-.}" -type f -name ".DS_Store" -delete
  echo "Removed .DS_Store files from ${1:-.}"
}

# Show current Finder directory in terminal
cdf() {
  local target=$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
  if [[ "$target" != "" ]]; then
    cd "$target"
    echo "Changed to Finder's directory: $target"
  else
    echo "No Finder window found"
  fi
}

# Open current terminal directory in Finder
f() {
  open -a Finder .
}

# Create a new directory and change to it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ====================================
# 2. SYSTEM OPERATIONS
# ====================================
# Lock screen immediately
lock() {
  pmset displaysleepnow
}

# Put computer to sleep
sleep() {
  pmset sleepnow
}

# Empty trash and cleanup system logs
emptytrash() {
  sudo rm -rfv /Volumes/*/.Trashes
  sudo rm -rfv ~/.Trash
  sudo rm -rfv /private/var/log/asl/*.asl
  sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
  echo "Trash and system logs emptied"
}

# Flush DNS cache
flushdns() {
  dscacheutil -flushcache && killall -HUP mDNSResponder
  echo "DNS cache flushed"
}

# Get macOS version information
macosversion() {
  sw_vers
}

# Restart computer
restart() {
  osascript -e 'tell app "System Events" to restart'
}

# Shutdown computer
shutdown() {
  osascript -e 'tell app "System Events" to shut down'
}

# ====================================
# 3. NETWORK AND CONNECTIVITY
# ====================================
# Show all active network interfaces
shownetwork() {
  ifconfig | grep "inet " | grep -v 127.0.0.1
}

# Get internal IP address
localip() {
  ipconfig getifaddr en0
}

# Get external IP address
externalip() {
  curl -s https://api.ipify.org
}

# Show all listening ports
ports() {
  sudo lsof -iTCP -sTCP:LISTEN -n -P
}

# ====================================
# 4. APPLICATION MANAGEMENT
# ====================================
# Open applications
chrome() { open -a "Google Chrome" $@ }
safari() { open -a "Safari" $@ }
firefox() { open -a "Firefox" $@ }
vscode() { open -a "Visual Studio Code" $@ }
code() { open -a "Visual Studio Code" $@ }
sublime() { open -a "Sublime Text" $@ }
photoshop() { open -a "Adobe Photoshop" $@ }
preview() { open -a "Preview" $@ }
mail() { open -a "Mail" $@ }
notes() { open -a "Notes" $@ }
reminders() { open -a "Reminders" $@ }
calendar() { open -a "Calendar" $@ }
terminal() { open -a "Terminal" $@ }
iterm() { open -a "iTerm" $@ }

# Kill application by name
killapp() {
  local app_name="$1"
  killall "$app_name" 2>/dev/null || echo "No process matching '$app_name' found"
}

# ====================================
# 5. DOCUMENT MANAGEMENT
# ====================================
# Convert image to different format
convertimg() {
  local input="$1"
  local output="$2"
  local format="${output##*.}"

  if command -v sips >/dev/null; then
    sips -s format "$format" "$input" --out "$output"
    echo "Converted $input to $output"
  else
    echo "sips command not found"
  fi
}

# Combine PDFs
combinepdf() {
  local output="$1"
  shift
  /System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py -o "$output" "$@"
  echo "Combined PDFs into $output"
}

# Create a screenshot and save to specific location
sshot() {
  local filename="$HOME/Desktop/screenshot_$(date +%Y%m%d_%H%M%S).png"
  if [[ -n "$1" ]]; then
    filename="$1"
  fi
  screencapture -i "$filename"
  echo "Screenshot saved to $filename"
}

# ====================================
# 6. DEVELOPMENT TOOLS
# ====================================
# Open current directory in VSCode
vs() {
  open -a "Visual Studio Code" .
}

# Start a simple HTTP server
serve() {
  local port="${1:-8000}"
  open "http://localhost:${port}/" && python3 -m http.server "$port"
}

# Start a PHP server
phpserve() {
  local port="${1:-8000}"
  open "http://localhost:${port}/" && php -S "localhost:${port}"
}

# ====================================
# 7. HOMEBREW HELPERS
# ====================================
# Update Homebrew and all packages
brewup() {
  brew update && brew upgrade && brew cleanup
  echo "Homebrew packages updated and cleaned up"
}

# List all installed Homebrew packages
brewlist() {
  brew list --formula
}

# List all installed Homebrew casks
casklist() {
  brew list --cask
}

# Find out what depends on a Homebrew package
brewdeps() {
  brew deps --installed --tree "$@"
}

# Check for Homebrew issues
brewdoctor() {
  brew doctor
}

# ====================================
# 8. QUICKLOOK HELPERS
# ====================================
# Quick Look a file (space bar in Finder)
ql() {
  qlmanage -p "$@" &>/dev/null
}

# View metadata for a file
meta() {
  mdls "$1"
}

# ====================================
# 9. SPOTLIGHT MANAGEMENT
# ====================================
# Disable Spotlight indexing
spotoff() {
  sudo mdutil -a -i off
  echo "Spotlight indexing disabled"
}

# Enable Spotlight indexing
spoton() {
  sudo mdutil -a -i on
  echo "Spotlight indexing enabled"
}

# Search with Spotlight from terminal
spot() {
  mdfind "kMDItemDisplayName == '*$@*'c || kMDItemTextContent == '*$@*'c"
}

# ====================================
# 10. SYSTEM INFORMATION
# ====================================
# Show system information summary
sysinfo() {
  echo "===== System Information ====="
  echo "OS Version: $(sw_vers -productVersion)"
  echo "Computer Name: $(scutil --get ComputerName)"
  echo "Host Name: $(scutil --get HostName 2>/dev/null || echo 'Not Set')"
  echo "Local Host Name: $(scutil --get LocalHostName)"
  echo "----------------------------"
  echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
  echo "Memory: $(system_profiler SPHardwareDataType | grep "Memory:" | awk '{print $2, $3}')"
  echo "Disk Space: $(df -h / | tail -1 | awk '{print "Total: "$2", Used: "$3", Available: "$4}')"
  echo "----------------------------"
  echo "IP Address: $(ipconfig getifaddr en0 || echo 'Not connected')"
  echo "----------------------------"
  echo "Battery Status: $(pmset -g batt | grep -o '[0-9]*%' || echo 'No battery')"
}

# Show disk usage by directory
diskusage() {
  du -sh "${1:-.}"/*
}

# Show memory usage
memoryusage() {
  top -l 1 -s 0 | grep PhysMem
}

# Show CPU usage
cpuusage() {
  top -l 1 -n 0 | grep "CPU usage"
}
