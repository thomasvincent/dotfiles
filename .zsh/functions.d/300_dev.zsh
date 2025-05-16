#!/usr/bin/env zsh
# Development utility functions

# Create and activate Python virtual environment (renamed to avoid conflict)
function create_venv() {
  local envdir=${1:-.venv}
  if [[ ! -d "$envdir" ]]; then
    echo "Creating virtual environment in $envdir"
    python3 -m venv "$envdir"
  fi
}
alias venv='create_venv'

# Activate Python virtual environment
function activate_venv() {
  local envdir=${1:-.venv}
  if [[ -f "$envdir/bin/activate" ]]; then
    source "$envdir/bin/activate"
  else
    echo "No virtual environment found in $envdir"
    return 1
  fi
}
alias act='activate_venv'

# Generate a secure random password
genpass() {
  local length=${1:-16}
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' < /dev/urandom | head -c "$length" | pbcopy
  echo "Generated a $length character password and copied to clipboard"
}

# Find and kill process by name
findkill() {
  local pattern=$1
  local pids=$(ps aux | grep -i "$pattern" | grep -v grep | awk '{print $2}')

  if [ -z "$pids" ]; then
    echo "No processes found matching '$pattern'"
    return 1
  fi

  echo "Found processes:"
  ps -p "$pids" -o pid,user,%cpu,%mem,command
  echo ""

  read -q "REPLY?Kill these processes? (y/n) "
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "$pids" | xargs kill -9
    echo "Processes killed"
  else
    echo "Operation cancelled"
  fi
}

# Run a command repeatedly
repeat_cmd() {
  local interval=${1:-2}
  local cmd=${@:2}

  if [ -z "$cmd" ]; then
    echo "Usage: repeat_cmd <interval_in_seconds> <command>"
    return 1
  fi

  while true; do
    clear
    date
    echo "Command: $cmd"
    echo "--------------------------------------------"
    eval "$cmd"
    sleep "$interval"
  done
}

# Generate a UUID
uuid() {
  if command -v uuidgen >/dev/null 2>&1; then
    uuidgen | tr '[:upper:]' '[:lower:]'
  else
    python3 -c 'import uuid; print(uuid.uuid4())' 2>/dev/null || \
    ruby -r securerandom -e 'puts SecureRandom.uuid' 2>/dev/null || \
    node -e 'console.log(require("crypto").randomUUID())' 2>/dev/null
  fi
}

# Watch command output with timestamps
timewait() {
  local cmd="$@"
  while true; do
    echo "$(date +%H:%M:%S) $(eval $cmd)"
    sleep 1
  done
}

# Get the size of a directory or file
sizeOf() {
  if [[ -d "$1" ]]; then
    du -sh "$1"
  elif [[ -f "$1" ]]; then
    ls -lh "$1" | awk '{print $5}'
  else
    echo "File or directory not found: $1"
  fi
}

# Search and replace in files
# Usage: greplace "search text" "replacement text" "*.js"
greplace() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: greplace 'search text' 'replacement text' ['file pattern']"
    return 1
  fi

  local search=$1
  local replace=$2
  local pattern=${3:-"*"}

  find . -name "$pattern" -type f -print0 | xargs -0 sed -i '' -e "s/$search/$replace/g"
}

# Encode URL
urlencode() {
  local data
  if [[ $# -eq 0 ]]; then
    data=$(cat)
  else
    data=$1
  fi

  python3 -c "import urllib.parse; print(urllib.parse.quote('''$data'''))"
}

# Decode URL
urldecode() {
  local data
  if [[ $# -eq 0 ]]; then
    data=$(cat)
  else
    data=$1
  fi

  python3 -c "import urllib.parse; print(urllib.parse.unquote('''$data'''))"
}

# Pretty-print JSON
json() {
  if [[ -z "$1" ]]; then
    echo "Usage: json <file.json>"
    return 1
  elif [[ -f "$1" ]]; then
    python3 -m json.tool < "$1" | pygmentize -l json 2>/dev/null || python3 -m json.tool < "$1"
  else
    echo "$1" | python3 -m json.tool | pygmentize -l json 2>/dev/null || echo "$1" | python3 -m json.tool
  fi
}
