#!/usr/bin/env zsh
# Cross-platform compatibility settings and functions

# ====================================
# Platform Detection
# ====================================

# Simple platform detection that works consistently
if [[ "$(uname)" == "Darwin" ]]; then
  export PLATFORM="mac"
  export PLATFORM_MAC=1
  export PLATFORM_LINUX=0
  export PLATFORM_BSD=0
  export PLATFORM_WSL=0
elif [[ "$(uname)" == "Linux" ]]; then
  export PLATFORM="linux"
  export PLATFORM_MAC=0
  export PLATFORM_LINUX=1
  export PLATFORM_BSD=0
  
  # Check for WSL
  if grep -q -i microsoft /proc/version 2>/dev/null; then
    export PLATFORM="wsl"
    export PLATFORM_WSL=1
  else
    export PLATFORM_WSL=0
  fi
elif [[ "$(uname)" =~ "BSD" || "$(uname)" == "DragonFly" ]]; then
  export PLATFORM="bsd"
  export PLATFORM_MAC=0
  export PLATFORM_LINUX=0
  export PLATFORM_BSD=1
  export PLATFORM_WSL=0
else
  export PLATFORM="unknown"
  export PLATFORM_MAC=0
  export PLATFORM_LINUX=0
  export PLATFORM_BSD=0
  export PLATFORM_WSL=0
fi

# Debug output (uncomment for debugging)
# echo "Detected platform: $PLATFORM"

# Detect if we're running in a container
if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup 2>/dev/null; then
  export PLATFORM_CONTAINER=1
else
  export PLATFORM_CONTAINER=0
fi

# ====================================
# Platform-specific Settings
# ====================================

# Load platform-specific configuration
if [[ "$PLATFORM" != "unknown" ]]; then
  PLATFORM_FILE="${ZDOTDIR:-$HOME}/.zsh/platforms/${PLATFORM}.zsh"
  [[ -f "$PLATFORM_FILE" ]] && source "$PLATFORM_FILE"
fi

# Create platform-specific directories
# Ensure platform files directory exists
mkdir -p "${ZDOTDIR:-$HOME}/.zsh/platforms"

# Create macOS config if it doesn't exist
if [[ ! -f "${ZDOTDIR:-$HOME}/.zsh/platforms/mac.zsh" ]]; then
  cat > "${ZDOTDIR:-$HOME}/.zsh/platforms/mac.zsh" << 'EOL'
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

# Override system commands for colored output
if (( ${+commands[gls]} )); then
  alias ls="gls --color=auto"
fi

if (( ${+commands[gdircolors]} )); then
  eval "$(gdircolors)"
fi

# Override for less with color support in macOS
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
EOL
fi

# Create Linux config if it doesn't exist
if [[ ! -f "${ZDOTDIR:-$HOME}/.zsh/platforms/linux.zsh" ]]; then
  cat > "${ZDOTDIR:-$HOME}/.zsh/platforms/linux.zsh" << 'EOL'
# Linux Specific Configuration

# Set LS_COLORS
if (( ${+commands[dircolors]} )); then
  eval "$(dircolors -b)"
fi

# Linux aliases
alias open="xdg-open"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

# Use apt, dnf, or pacman based on availability
if (( ${+commands[apt]} )); then
  alias apts="apt search"
  alias aptsh="apt show"
  alias apti="sudo apt install"
  alias aptr="sudo apt remove"
  alias aptu="sudo apt update && sudo apt upgrade"
  alias aptc="sudo apt autoclean && sudo apt autoremove"
elif (( ${+commands[dnf]} )); then
  alias apts="dnf search"
  alias aptsh="dnf info"
  alias apti="sudo dnf install"
  alias aptr="sudo dnf remove"
  alias aptu="sudo dnf update"
  alias aptc="sudo dnf clean all"
elif (( ${+commands[pacman]} )); then
  alias apts="pacman -Ss"
  alias aptsh="pacman -Si"
  alias apti="sudo pacman -S"
  alias aptr="sudo pacman -R"
  alias aptu="sudo pacman -Syu"
  alias aptc="sudo pacman -Sc"
fi
EOL
fi

# Create WSL config if it doesn't exist
if [[ ! -f "${ZDOTDIR:-$HOME}/.zsh/platforms/wsl.zsh" ]]; then
  cat > "${ZDOTDIR:-$HOME}/.zsh/platforms/wsl.zsh" << 'EOL'
# Windows Subsystem for Linux (WSL) Configuration

# Source the regular Linux configuration first
source "${ZDOTDIR:-$HOME}/.zsh/platforms/linux.zsh"

# WSL-specific aliases
alias explorer="explorer.exe"
alias cmd="cmd.exe /c"
alias powershell="powershell.exe -Command"
alias winget="powershell.exe -Command winget"

# Windows paths
export WINHOME="/mnt/c/Users/$USER"
export WINDOCS="$WINHOME/Documents"
export WINDOWNLOADS="$WINHOME/Downloads"

# Open Windows applications
wslopen() {
  local file="$1"
  
  if [[ -z "$file" ]]; then
    echo "Usage: wslopen <file|url>"
    return 1
  fi
  
  # Convert path to Windows format if it's a file
  if [[ -f "$file" ]]; then
    # Convert /mnt/c/... to C:\...
    local winpath=$(wslpath -w "$file")
    cmd "start \"\" \"$winpath\""
  else
    # Treat as URL or command
    cmd "start \"\" \"$file\""
  fi
}

# Helper function to convert paths between WSL and Windows
winpath() {
  local path="$1"
  wslpath -w "$path"
}

unixpath() {
  local path="$1"
  wslpath -u "$path"
}

# Set clipboard to work with both Linux and Windows
alias clip="clip.exe"
alias win-pbcopy="clip.exe"
alias win-pbpaste="powershell.exe -Command 'Get-Clipboard' | tr -d '\r'"

# If using X11 forwarding, ensure DISPLAY is set
if [[ -z "$DISPLAY" ]]; then
  export DISPLAY=:0
fi
EOL
fi

# Create BSD config if it doesn't exist
if [[ ! -f "${ZDOTDIR:-$HOME}/.zsh/platforms/bsd.zsh" ]]; then
  cat > "${ZDOTDIR:-$HOME}/.zsh/platforms/bsd.zsh" << 'EOL'
# BSD Specific Configuration

# BSD-specific aliases and settings
alias ls="ls -G"
alias top="top -a"

# Set LSCOLORS for BSD ls
export LSCOLORS="Exfxcxdxbxegedabagacad"

# BSD specific package management
if [[ -f "/usr/local/sbin/pkg" ]]; then
  alias pkgs="pkg search"
  alias pkgi="sudo pkg install"
  alias pkgr="sudo pkg remove"
  alias pkgu="sudo pkg update && sudo pkg upgrade"
  alias pkgc="sudo pkg clean"
fi
EOL
fi

# ====================================
# Cross-Platform Functions
# ====================================

# Cross-platform open command
xopen() {
  local file="$1"
  
  if [[ -z "$file" ]]; then
    echo "Usage: xopen <file|url>"
    return 1
  fi
  
  case "$PLATFORM" in
    mac)
      open "$file"
      ;;
    linux)
      xdg-open "$file" &> /dev/null &
      ;;
    wsl)
      wslopen "$file"
      ;;
    cygwin)
      cygstart "$file"
      ;;
    bsd)
      open "$file" || xdg-open "$file" &> /dev/null &
      ;;
    *)
      echo "Platform not supported for open command"
      return 1
      ;;
  esac
}

# Cross-platform clipboard copy
xcopy() {
  case "$PLATFORM" in
    mac)
      pbcopy
      ;;
    linux)
      if (( ${+commands[xclip]} )); then
        xclip -selection clipboard
      elif (( ${+commands[xsel]} )); then
        xsel --clipboard --input
      else
        echo "No clipboard command found. Install xclip or xsel."
        return 1
      fi
      ;;
    wsl)
      clip.exe
      ;;
    cygwin)
      cat > /dev/clipboard
      ;;
    *)
      echo "Platform not supported for clipboard operations"
      return 1
      ;;
  esac
}

# Cross-platform clipboard paste
xpaste() {
  case "$PLATFORM" in
    mac)
      pbpaste
      ;;
    linux)
      if (( ${+commands[xclip]} )); then
        xclip -selection clipboard -o
      elif (( ${+commands[xsel]} )); then
        xsel --clipboard --output
      else
        echo "No clipboard command found. Install xclip or xsel."
        return 1
      fi
      ;;
    wsl)
      powershell.exe -Command 'Get-Clipboard' | tr -d '\r'
      ;;
    cygwin)
      cat /dev/clipboard
      ;;
    *)
      echo "Platform not supported for clipboard operations"
      return 1
      ;;
  esac
}

# Cross-platform package manager
xpm() {
  local action="$1"
  shift
  
  if [[ -z "$action" ]]; then
    echo "Usage: xpm <action> [packages]"
    echo "Actions: search, install, remove, update, clean"
    return 1
  fi
  
  case "$PLATFORM" in
    mac)
      if (( ${+commands[brew]} )); then
        case "$action" in
          search)
            brew search "$@"
            ;;
          install)
            brew install "$@"
            ;;
          remove)
            brew uninstall "$@"
            ;;
          update)
            brew update && brew upgrade "$@"
            ;;
          clean)
            brew cleanup
            ;;
          *)
            echo "Unknown action: $action"
            return 1
            ;;
        esac
      else
        echo "Homebrew not installed"
        return 1
      fi
      ;;
    linux)
      if (( ${+commands[apt]} )); then
        case "$action" in
          search)
            apt search "$@"
            ;;
          install)
            sudo apt install "$@"
            ;;
          remove)
            sudo apt remove "$@"
            ;;
          update)
            sudo apt update && sudo apt upgrade "$@"
            ;;
          clean)
            sudo apt autoclean && sudo apt autoremove
            ;;
          *)
            echo "Unknown action: $action"
            return 1
            ;;
        esac
      elif (( ${+commands[dnf]} )); then
        case "$action" in
          search)
            dnf search "$@"
            ;;
          install)
            sudo dnf install "$@"
            ;;
          remove)
            sudo dnf remove "$@"
            ;;
          update)
            sudo dnf update "$@"
            ;;
          clean)
            sudo dnf clean all
            ;;
          *)
            echo "Unknown action: $action"
            return 1
            ;;
        esac
      elif (( ${+commands[pacman]} )); then
        case "$action" in
          search)
            pacman -Ss "$@"
            ;;
          install)
            sudo pacman -S "$@"
            ;;
          remove)
            sudo pacman -R "$@"
            ;;
          update)
            sudo pacman -Syu
            ;;
          clean)
            sudo pacman -Sc
            ;;
          *)
            echo "Unknown action: $action"
            return 1
            ;;
        esac
      else
        echo "No supported package manager found"
        return 1
      fi
      ;;
    bsd)
      if (( ${+commands[pkg]} )); then
        case "$action" in
          search)
            pkg search "$@"
            ;;
          install)
            sudo pkg install "$@"
            ;;
          remove)
            sudo pkg remove "$@"
            ;;
          update)
            sudo pkg update && sudo pkg upgrade
            ;;
          clean)
            sudo pkg clean
            ;;
          *)
            echo "Unknown action: $action"
            return 1
            ;;
        esac
      else
        echo "No supported package manager found"
        return 1
      fi
      ;;
    *)
      echo "Platform not supported for package management"
      return 1
      ;;
  esac
}

# Show system information
xsysinfo() {
  echo "System Information:"
  echo "-------------------"
  echo "Platform: $PLATFORM"
  
  case "$PLATFORM" in
    mac)
      system_profiler SPSoftwareDataType SPHardwareDataType | grep -v "Serial\|UUID"
      ;;
    linux|wsl)
      echo "Kernel: $(uname -r)"
      echo "Distribution: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
      echo "CPU: $(grep "model name" /proc/cpuinfo | head -n1 | cut -d: -f2 | sed 's/^[ \t]*//')"
      echo "Memory: $(free -h | grep Mem | awk '{print $2}')"
      echo "Uptime: $(uptime -p)"
      ;;
    bsd)
      uname -a
      sysctl hw.model hw.machine hw.physmem
      ;;
    *)
      uname -a
      ;;
  esac
}

# Cross-platform process management
xps() {
  case "$PLATFORM" in
    mac)
      ps -ax | grep -i "$@"
      ;;
    linux|wsl|bsd)
      ps -aux | grep -i "$@"
      ;;
    *)
      ps | grep -i "$@"
      ;;
  esac
}

# Cross-platform kill process
xkill() {
  local pattern="$1"
  
  if [[ -z "$pattern" ]]; then
    echo "Usage: xkill <process_pattern>"
    return 1
  fi
  
  local pids
  
  case "$PLATFORM" in
    mac)
      pids=$(ps -ax | grep -i "$pattern" | grep -v grep | awk '{print $1}')
      ;;
    linux|wsl|bsd)
      pids=$(ps -aux | grep -i "$pattern" | grep -v grep | awk '{print $2}')
      ;;
    *)
      pids=$(ps | grep -i "$pattern" | grep -v grep | awk '{print $1}')
      ;;
  esac
  
  if [[ -z "$pids" ]]; then
    echo "No processes found matching '$pattern'"
    return 1
  fi
  
  echo "Found processes:"
  
  for pid in $pids; do
    if [[ "$PLATFORM" == "mac" ]]; then
      ps -p "$pid" -o pid,command
    else
      ps -p "$pid" -o pid,comm,args
    fi
  done
  
  echo -n "Kill these processes? (y/n) "
  read -q response
  echo
  
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "$pids" | xargs kill -9
    echo "Processes killed"
  else
    echo "Operation canceled"
  fi
}

# Display platform information
platform() {
  echo "Current platform: $PLATFORM"
  case "$PLATFORM" in
    mac)
      echo "macOS: $(sw_vers -productVersion) ($(uname -m))"
      ;;
    linux)
      if [[ -f /etc/os-release ]]; then
        echo "$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
      else
        echo "Linux: $(uname -r)"
      fi
      ;;
    wsl)
      echo "Windows Subsystem for Linux"
      if [[ -f /etc/os-release ]]; then
        echo "$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
      fi
      ;;
    bsd)
      echo "BSD: $(uname -sr)"
      ;;
    cygwin)
      echo "Cygwin/MinGW on Windows"
      ;;
    *)
      echo "Unknown platform: $(uname -s)"
      ;;
  esac
}