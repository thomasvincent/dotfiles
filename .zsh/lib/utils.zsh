#!/usr/bin/env bash
# utils.sh - Common utility functions for shell scripts
# Source this file to get utility functions for your scripts

# Import paths if not already imported
# shellcheck source=paths.sh
if [ -z "$DOTFILES_DIR" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/paths.sh" ]; then
  source "$(dirname "${BASH_SOURCE[0]}")/paths.sh"
fi

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Get the absolute path of a file
get_abs_path() {
  local path="$1"
  if [ -d "$path" ]; then
    (cd "$path" && pwd)
  elif [ -f "$path" ]; then
    if [[ $path == /* ]]; then
      echo "$path"
    else
      echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
    fi
  else
    error "Path does not exist: $path"
    return 1
  fi
}

# Check if a function exists
function_exists() {
  declare -f -F "$1" > /dev/null
  return $?
}

# Run a command with stdout and stderr captured to a log file
# Usage: log_command "Installing packages" "apt-get install -y package" "/tmp/install.log"
log_command() {
  local description="$1"
  local cmd="$2"
  local log_file="${3:-/tmp/command_$(date +%Y%m%d%H%M%S).log}"
  
  info "$description..."
  eval "$cmd" > "$log_file" 2>&1
  local status=$?
  
  if [ $status -eq 0 ]; then
    success "$description completed successfully"
  else
    error "$description failed (see $log_file for details)"
  fi
  
  return $status
}

# Check if script is being run as root
is_root() {
  [ "$(id -u)" -eq 0 ]
}

# Ask for confirmation before proceeding
confirm() {
  local prompt="${1:-Are you sure?}"
  local default="${2:-y}"
  
  local options="y/n"
  if [ "$default" = "y" ]; then
    options="[Y/n]"
  else
    options="[y/N]"
  fi
  
  local answer
  read -r -p "$(echo -e "${BOLD_YELLOW}$prompt $options${RESET} ")" answer
  
  [ -z "$answer" ] && answer="$default"
  
  case "$answer" in
    [yY][eE][sS]|[yY]) 
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Safe source a file (doesn't fail if file doesn't exist)
safe_source() {
  [ -f "$1" ] && source "$1"
}

# Get a machine-friendly version of a string (lowercase, no spaces)
slugify() {
  echo "$1" | tr -cd '[:alnum:][:space:]' | tr '[:upper:]' '[:lower:]' | tr '[:space:]' '-'
}

# Parse key=value pairs from a file
# Usage: parse_config_file "/path/to/config"
parse_config_file() {
  local config_file="$1"
  
  if [ ! -f "$config_file" ]; then
    error "Config file does not exist: $config_file"
    return 1
  fi
  
  while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
    
    # Trim whitespace
    key="$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    value="$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    
    # Remove quotes if present
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
    
    # Export the variable
    export "$key"="$value"
  done < "$config_file"
}

# Check if current terminal is interactive
is_interactive() {
  [ -t 0 ] && [ -t 1 ]
}

# Get the current script name
get_script_name() {
  basename "${BASH_SOURCE[0]:-$0}"
}

# Check if a value exists in an array
# Usage: if array_contains "value" "${array[@]}"; then ...
array_contains() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    [ "$item" = "$needle" ] && return 0
  done
  return 1
}

# Join array elements with a delimiter
# Usage: join_by "," "${array[@]}"
join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

# Get the timestamp for logging
get_timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# Log with timestamp and level
log() {
  local level="$1"
  shift
  echo "$(get_timestamp) [$level] $*"
}

# Wait for a process to finish with a nice spinner
# Usage: spinner $! "Loading..." && echo "Done!"
spinner() {
  local pid="$1"
  local message="$2"
  local spin='-\|/'
  local i=0
  
  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\r${BOLD_BLUE}%s${RESET} ${spin:$i:1}" "$message"
    sleep .1
  done
  printf "\r${BOLD_GREEN}%s${RESET} Done!     \n" "$message"
}

# Create a temporary file that will be deleted on exit
create_temp_file() {
  local prefix="${1:-tmp}"
  local temp_file
  
  temp_file="$(mktemp "/tmp/${prefix}.XXXXXX")"
  
  # Register cleanup handler
  trap 'rm -f "$temp_file"' EXIT
  
  echo "$temp_file"
}