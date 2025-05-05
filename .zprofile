#!/usr/bin/env zsh
# ~/.zprofile - Login shell configuration
#
# This file is sourced only for login shells.
# Use it for environment setup that should happen once per session,
# such as running agents and setting up GUI-specific variables.
#

# ====================================
# START SSH AGENT IF NOT RUNNING
# ====================================
# Start SSH agent if it's not already running
if [[ -z "$SSH_AUTH_SOCK" && -z "$SSH_CONNECTION" ]]; then
  local ssh_agent_env="$HOME/.ssh/agent.env"
  
  if [[ -f "$ssh_agent_env" ]]; then
    source "$ssh_agent_env" > /dev/null
    
    # Check if the agent is still running
    if ! ps -p $SSH_AGENT_PID > /dev/null; then
      # Agent not running, start a new one
      ssh-agent | grep -v "echo" > "$ssh_agent_env"
      chmod 600 "$ssh_agent_env"
      source "$ssh_agent_env" > /dev/null
    fi
  else
    # No agent env file, start a new agent
    ssh-agent | grep -v "echo" > "$ssh_agent_env"
    chmod 600 "$ssh_agent_env"
    source "$ssh_agent_env" > /dev/null
  fi
fi

# ====================================
# HOMEBREW SETUP
# ====================================
# Set up Homebrew environment if available
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ====================================
# GPG AGENT SETUP
# ====================================
# Set up GPG agent for SSH authentication (if configured)
export GPG_TTY="$(tty)"
if command -v gpgconf >/dev/null; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  gpgconf --launch gpg-agent
fi

# ====================================
# SESSION CLEANUP
# ====================================
# Clean up temporary files on login
if [[ -d "$HOME/tmp" ]]; then
  find "$HOME/tmp" -type f -atime +7 -delete 2>/dev/null
fi