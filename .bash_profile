#!/usr/bin/env bash

# --- Path and Configuration ---

# Use the more standard way of adding to PATH
PATH="$HOME/bin:$PATH"

# Load dotfiles: Loop using a modern approach
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
  [[ -f "$file" ]] && source "$file"  # Double brackets for better readability
done

# --- Bash Options ---

# Use compound command for better grouping
shopt -s nocaseglob histappend cdspell

# Bash 4 features (no need for loop)
shopt -s autocd globstar 2>/dev/null  # Redirect errors directly

# --- Bash Completion ---

# Homebrew completion (simplified)
if brew --prefix &>/dev/null; then
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif [[ -f /etc/bash_completion ]]; then  # Use double brackets
  source /etc/bash_completion
fi

# Alias-based completion
# No need to explicitly enable tab completion if function _git exists
# Bash automatically completes based on the alias
alias g='git'


# SSH hostname completion (simplified and more robust)
if [[ -f "$HOME/.ssh/config" ]]; then
  complete -o default -o nospace -W "$(awk '/^Host[ \t]+[^*]/{print $2}' ~/.ssh/config)" scp sftp ssh
fi


# Other Completions
complete -W "NSGlobalDomain" defaults
complete -o nospace -W "Contacts Calendar Dock Finder Mail Safari Music SystemUIServer Terminal" killall  # Removed iTunes and Twitter since they're not standard macOS apps
