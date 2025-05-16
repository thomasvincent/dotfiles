#!/usr/bin/env bash
# paths.sh - Shared path definitions and directory management
# Source this file to get common path variables and functions

# Get the real path of this script
if [ -n "$BASH_SOURCE" ]; then
  THIS_SCRIPT="${BASH_SOURCE[0]}"
else
  THIS_SCRIPT="$0"
fi

# Resolve symlinks
while [ -L "$THIS_SCRIPT" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$THIS_SCRIPT")" && pwd)"
  THIS_SCRIPT="$(readlink "$THIS_SCRIPT")"
  [[ $THIS_SCRIPT != /* ]] && THIS_SCRIPT="$SCRIPT_DIR/$THIS_SCRIPT"
done

# Define key paths
export SCRIPT_DIR="$(cd -P "$(dirname "$THIS_SCRIPT")" && pwd)"
export DOTFILES_DIR="$(cd -P "$SCRIPT_DIR/.." && pwd)"
export BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZSH_CONFIG_DIR="$DOTFILES_DIR/.zsh"
export ZSH_FUNCTIONS_DIR="$ZSH_CONFIG_DIR/functions.d"

# Import color definitions for messaging
# shellcheck source=colors.sh
if [ -f "$SCRIPT_DIR/colors.sh" ]; then
  source "$SCRIPT_DIR/colors.sh"
fi

# Create directory if it doesn't exist
ensure_dir() {
  local dir_path="$1"
  if [ ! -d "$dir_path" ]; then
    mkdir -p "$dir_path"
    if [ $? -eq 0 ]; then
      info "Created directory: $dir_path"
      return 0
    else
      error "Failed to create directory: $dir_path"
      return 1
    fi
  fi
  return 0
}

# Backup a file if it exists
backup_file() {
  local file_path="$1"
  if [ -e "$file_path" ]; then
    ensure_dir "$BACKUP_DIR"
    local backup_path="$BACKUP_DIR/$(basename "$file_path").$(date +%Y%m%d_%H%M%S)"
    cp -RH "$file_path" "$backup_path"
    if [ $? -eq 0 ]; then
      info "Backed up $file_path to $backup_path"
      return 0
    else
      error "Failed to backup $file_path"
      return 1
    fi
  fi
  return 0
}

# Create a symlink with backup of the target if it exists
create_symlink() {
  local source_path="$1"
  local target_path="$2"
  
  if [ ! -e "$source_path" ]; then
    error "Source path does not exist: $source_path"
    return 1
  fi
  
  # Backup existing file
  if [ -e "$target_path" ]; then
    if [ -L "$target_path" ]; then
      # It's already a symlink, let's check if it points to our file
      local current_link="$(readlink "$target_path")"
      if [ "$current_link" = "$source_path" ]; then
        info "Symlink already exists and points to the correct location: $target_path -> $source_path"
        return 0
      fi
    fi
    
    # Backup the existing file/symlink
    backup_file "$target_path"
    rm -rf "$target_path"
  fi
  
  # Create parent directory if needed
  ensure_dir "$(dirname "$target_path")"
  
  # Create the symlink
  ln -sf "$source_path" "$target_path"
  if [ $? -eq 0 ]; then
    success "Created symlink: $target_path -> $source_path"
    return 0
  else
    error "Failed to create symlink: $target_path -> $source_path"
    return 1
  fi
}

# Create standard directory structure
create_standard_dirs() {
  local dirs=(
    "$XDG_CONFIG_HOME"
    "$XDG_DATA_HOME"
    "$XDG_CACHE_HOME"
    "$ZSH_CONFIG_DIR/functions.d"
    "$ZSH_CONFIG_DIR/completions"
    "$ZSH_CONFIG_DIR/cache"
    "$DOTFILES_DIR/bin"
    "$DOTFILES_DIR/.config"
    "$DOTFILES_DIR/.local/bin"
  )
  
  for dir in "${dirs[@]}"; do
    ensure_dir "$dir"
  done
}

# Check if we're on macOS
is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

# Check if we're on Linux
is_linux() {
  [[ "$(uname -s)" == "Linux" ]]
}

# Get OS name in lowercase
get_os() {
  echo "$(uname -s)" | tr '[:upper:]' '[:lower:]'
}

# Get platform identifier (more specific than OS)
get_platform() {
  local os="$(get_os)"
  
  case "$os" in
    darwin)
      echo "mac"
      ;;
    linux)
      if [ -f /etc/debian_version ]; then
        echo "debian"
      elif [ -f /etc/redhat-release ]; then
        echo "redhat"
      elif [ -f /etc/arch-release ]; then
        echo "arch"
      else
        echo "linux"
      fi
      ;;
    *)
      echo "$os"
      ;;
  esac
}