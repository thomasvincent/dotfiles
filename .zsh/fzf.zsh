#!/usr/bin/env zsh
# FZF custom configuration
# This overrides the default FZF configuration to ensure compatibility with fd

# Only setup FZF if it's installed
if command -v fzf >/dev/null 2>&1; then
  # Basic FZF configuration
  export FZF_DEFAULT_OPTS="--height 40% --reverse --border --inline-info"
  
  # Use fd for file search if available
  if command -v fd >/dev/null 2>&1; then
    # Use compatible syntax for fd
    export FZF_DEFAULT_COMMAND="fd -t f -H -E .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d -H -E .git"
  else
    # Fallback to find
    export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' -not -path '*/node_modules/*'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*' -not -path '*/node_modules/*'"
  fi
  
  # Use bat for preview if available
  if command -v bat >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {}'"
  else
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview 'cat {}'"
  fi
fi
