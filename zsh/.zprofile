#!/usr/bin/env zsh

# .zprofile
# Author: Thomas Vincent
# GitHub: https://github.com/thomasvincent/dotfiles
#
# This file is loaded at login.
# It should contain commands that should be executed only once
# and environment variables that should be available to all shells and graphical applications.

# Set PATH, MANPATH, etc., for Homebrew.
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Set default editor
if command -v nvim &> /dev/null; then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

# Set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set XDG Base Directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Set DOTFILES directory
export DOTFILES="$HOME/Documents/Projects/dotfiles"

# Set GOPATH
export GOPATH="$HOME/go"

# Set JAVA_HOME
if [[ -x /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
fi

# Set ANDROID_HOME
export ANDROID_HOME="$HOME/Library/Android/sdk"

# Set PYTHON_USER_BASE
export PYTHONUSERBASE="$HOME/.local"

# Set RUBY_USER_DIR
if command -v ruby &> /dev/null; then
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
fi

# Set NODE_PATH
export NODE_PATH="$HOME/.node_modules"

# Set NVM_DIR
export NVM_DIR="$HOME/.nvm"

# Set COMPOSER_HOME
export COMPOSER_HOME="$HOME/.composer"

# Set CARGO_HOME
export CARGO_HOME="$HOME/.cargo"

# Set RUSTUP_HOME
export RUSTUP_HOME="$HOME/.rustup"

# Set HOMEBREW_NO_ANALYTICS to disable Homebrew's analytics
export HOMEBREW_NO_ANALYTICS=1

# Set HOMEBREW_NO_AUTO_UPDATE to disable automatic updates
# export HOMEBREW_NO_AUTO_UPDATE=1

# Set HOMEBREW_CASK_OPTS to install applications to /Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Set HOMEBREW_BUNDLE_FILE to use a specific Brewfile
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"

# Set LESS options
export LESS="-F -X -R -i -g -M -W -z-4"

# Set PAGER
export PAGER="less"

# Set BAT_THEME
export BAT_THEME="Dracula"

# Set FZF_DEFAULT_COMMAND to use fd
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
fi

# Set FZF_DEFAULT_OPTS
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Set RIPGREP_CONFIG_PATH
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# Set AWS_CONFIG_FILE and AWS_SHARED_CREDENTIALS_FILE
export AWS_CONFIG_FILE="$HOME/.aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"

# Set DOCKER_CONFIG
export DOCKER_CONFIG="$HOME/.docker"

# Set KUBECONFIG
export KUBECONFIG="$HOME/.kube/config"

# Set TERRAFORM_CONFIG
export TERRAFORM_CONFIG="$HOME/.terraform.d"

# Set PATH
# Add custom bin directories to PATH
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Add Homebrew's sbin to PATH
export PATH="/usr/local/sbin:$PATH"

# Add Visual Studio Code to PATH
if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
  export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# Add Composer's bin to PATH
if [[ -d "$HOME/.composer/vendor/bin" ]]; then
  export PATH="$PATH:$HOME/.composer/vendor/bin"
fi

# Add Go binaries to PATH
if [[ -d "$HOME/go/bin" ]]; then
  export PATH="$PATH:$HOME/go/bin"
fi

# Add Rust's cargo binaries to PATH
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

# Add Python user-site binaries to PATH
if command -v python3 &> /dev/null; then
  export PATH="$PATH:$(python3 -m site --user-base)/bin"
fi

# Add Ruby gems to PATH
if command -v ruby &> /dev/null && command -v gem &> /dev/null; then
  export PATH="$PATH:$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

# Add Yarn global binaries to PATH
if command -v yarn &> /dev/null; then
  export PATH="$PATH:$(yarn global bin)"
fi

# Add Android SDK tools to PATH
if [[ -d "$ANDROID_HOME" ]]; then
  export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
fi

# Add custom scripts to PATH
if [[ -d "$DOTFILES/bin" ]]; then
  export PATH="$PATH:$DOTFILES/bin"
fi

# Remove duplicate entries from PATH
typeset -U path
