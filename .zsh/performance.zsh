#!/usr/bin/env zsh
# Performance optimizations for ZSH

# ====================================
# ZSH Startup Performance
# ====================================

# Setup terminal profiling
# Set to true to enable profiling
PROFILE_STARTUP=false

# Initialize profiler if enabled
if [[ "$PROFILE_STARTUP" == true ]]; then
  # https://esham.io/2018/02/zsh-profiling
  zmodload zsh/zprof

  # PS4 configuration for zsh script tracing with timestamps
  # Use with: zsh -xv
  PS4=$'%D{%M:%S.%6.} %N:%i> '

  # Start timer
  typeset -F SECONDS=0

  # Log loading steps
  zsh_log_start() {
    echo "[startup] $1..."
  }
else
  # No-op function when profiling is disabled
  zsh_log_start() {
    :
  }
fi

# ====================================
# Performance Optimizations
# ====================================

# Optimize for staring in a fraction of a second
# Compiling the completion dump to speed up startup
zsh_log_start "Optimizing completion system"
{
  # Use cached .zcompdump file if less than 24 hours old
  autoload -Uz compinit

  local zcd="${ZDOTDIR:-$HOME}/.zcompdump"
  local zcdc="$zcd.zwc"

  # Only regenerate cache once per day
  # Check if zcompdump exists and is not newer than one day
  if [[ -f "$zcd"(#qN.mh+24) ]]; then
    compinit -d "$zcd"
  else
    compinit -C -d "$zcd"
  fi

  # Compile dump file if needed
  if [[ -f "$zcd" && (! -f "$zcdc" || "$zcd" -nt "$zcdc") ]]; then
    zcompile "$zcd"
  fi
}

# ====================================
# Lazy Loading Functions
# ====================================

# Lazy load function generator
lazy_load() {
  local load_func="$1"
  local cmd="$2"

  eval "$cmd() {
    unfunction $cmd
    $load_func
    $cmd \"\$@\"
  }"
}

# Lazy load completions for commands that aren't needed immediately
lazy_load_completion() {
  local cmd="$1"
  local completion_file="$2"

  if (( $+commands[$cmd] )); then
    eval "
    function ${cmd}_completion_loader() {
      compdef -d $cmd
      source \"$completion_file\"
      return 0
    }
    "

    # Create stub function for the command
    eval "
    function $cmd() {
      unfunction $cmd
      ${cmd}_completion_loader
      $cmd \"\$@\"
    }
    "
  fi
}

# ====================================
# Command Caching
# ====================================

# Cache results of expensive commands
cached_cmd() {
  local cmd="$1"
  local cache_time="${2:-3600}"  # Default to 1 hour
  local cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/cmd_cache/${cmd//\//_}"

  mkdir -p "$(dirname "$cache_file")"

  if [[ ! -f "$cache_file" || $(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || date +%s))) -gt $cache_time ]]; then
    eval "$cmd" > "$cache_file"
  fi

  cat "$cache_file"
}

# ====================================
# Custom Functions for Performance
# ====================================

# --------- Memory usage tools ----------
# Show memory usage of commands
mem() {
  /usr/bin/time -l "$@"
}

# Show memory usage of running processes
memtop() {
  ps aux | sort -rn -k 4 | head -n 20
}

# --------- ZSH Performance -----------
# Benchmark ZSH startup time
zsh_benchmark() {
  local count="${1:-10}"
  local total_time=0
  local min_time=9999
  local max_time=0

  echo "Running ZSH startup benchmark ($count iterations)..."

  for i in $(seq 1 $count); do
    local start_time=$(/bin/date +%s.%N)
    /bin/zsh -i -c exit
    local end_time=$(/bin/date +%s.%N)
    local elapsed=$(echo "$end_time - $start_time" | bc)

    total_time=$(echo "$total_time + $elapsed" | bc)
    min_time=$(echo "$elapsed < $min_time" | bc -l)
    if [ "$min_time" -eq 1 ]; then
      min_time=$elapsed
    fi

    max_time=$(echo "$elapsed > $max_time" | bc -l)
    if [ "$max_time" -eq 1 ]; then
      max_time=$elapsed
    fi

    printf "  Run %2d: %0.3fs\n" $i $elapsed
  done

  local avg_time=$(echo "scale=3; $total_time / $count" | bc)

  echo ""
  echo "Results after $count iterations:"
  echo "  Average: ${avg_time}s"
  echo "  Min: ${min_time}s"
  echo "  Max: ${max_time}s"
}

# Analyze which part of shell init is slow
zsh_profile() {
  local logfile=$(mktemp)
  echo "Profiling ZSH startup..."
  echo "Outputting to: $logfile"

  # Run zsh with profiling
  ZPROF=1 zsh -i -c 'zprof > "$1" && exit' -- "$logfile"

  # Display results
  cat "$logfile"

  # Optionally open in editor
  echo -n "Open in editor? [y/N] "
  read -q response
  echo

  if [[ "$response" =~ ^[Yy]$ ]]; then
    ${EDITOR:-vim} "$logfile"
  else
    echo "Temporary file left at: $logfile"
  fi
}

# Print startup time since the start of shell initialization
zsh_startup_time() {
  local end_time=$EPOCHREALTIME
  local load_time=$(( (end_time - EPOCHREALTIME_AT_STARTUP) * 1000 ))
  echo "ZSH loaded in ${load_time}ms"
}

# ====================================
# Profile Report
# ====================================

# Show profiling info when profiling enabled
zsh_profile_report() {
  if [[ "$PROFILE_STARTUP" == true ]]; then
    # Show total startup time
    local startup_duration=$(( SECONDS * 1000 ))
    echo "ZSH loaded in ${startup_duration}ms"

    # Show profiling information
    zprof
  fi
}

# Register the profile report to run at the end (will only run if profiling enabled)
# Add this at the end of .zshrc:
# zsh_profile_report
