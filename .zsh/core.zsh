#\!/usr/bin/env zsh
# Core ZSH settings and options

# History settings
HISTSIZE=50000
SAVEHIST=10000
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
setopt extended_history       # Record timestamp in history
setopt hist_expire_dups_first # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # Ignore duplicated commands history list
setopt hist_ignore_space      # Ignore commands that start with space
setopt hist_verify            # Show before executing history commands
setopt inc_append_history     # Add commands to HISTFILE in order of execution
setopt share_history          # Share command history data

# Input/output
setopt interactive_comments # Allow comments in interactive mode
setopt no_flow_control      # Disable start/stop characters
setopt auto_cd              # If a command is not found, and is a directory, cd to it
setopt extended_glob        # Use extended globbing
setopt no_case_glob         # Use case-insensitive globbing
setopt numeric_glob_sort    # Sort filenames numerically when it makes sense
setopt rc_quotes            # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
unsetopt beep               # No beep
unsetopt mail_warning       # Don't print warning if mail file is accessed

# Job control
unsetopt hup                # Don't kill background jobs when the shell exits
setopt long_list_jobs       # List jobs in the long format by default
setopt notify               # Report status of background jobs immediately

# Correction and prompt
setopt prompt_subst         # Enable parameter expansion, command substitution, and arithmetic expansion in prompts

# Completion
setopt auto_menu            # Show completion menu on successive tab press
setopt always_to_end        # Move cursor to end of word if completed in-word
setopt complete_in_word     # Allow completion from the middle of a word
setopt no_list_ambiguous    # List options on first ambiguous completion
unsetopt menu_complete      # Don't autoselect the first completion entry

# Directory stack
setopt auto_pushd           # Push the current dir onto the stack on cd
setopt pushd_ignore_dups    # Don't push multiple copies of the same dir onto the stack
setopt pushd_minus          # Exchanges +/- meanings in pushd

# Initialize completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Basic completion options
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Key bindings
bindkey -e  # Use emacs key bindings (default)

# Custom key bindings
bindkey '^[[H'  beginning-of-line  # Home
bindkey '^[[F'  end-of-line        # End
bindkey '^[[3~' delete-char        # Delete
bindkey '^[[1;5C' forward-word     # Ctrl + Right
bindkey '^[[1;5D' backward-word    # Ctrl + Left

# Allow safe ZLE operations even in scripts
zmodload zsh/zle 2>/dev/null || true

# Fix for error: "can't change option: monitor"
if [[ -o interactive ]]; then
  setopt monitor
else
  unsetopt monitor
fi

# Fix for error: "can't change option: zle"
if [[ -o interactive ]]; then
  setopt zle
else
  unsetopt zle
fi
