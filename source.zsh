#!/usr/bin/env zsh
# Source all configuration files for testing

# Set environment variables
export DOTFILES_DIR="$HOME/dotfiles"
export ZDOTDIR="$HOME/.zsh"

# Source configuration files
source "$DOTFILES_DIR/.zshrc"

# Print information about the environment
echo "\nEnvironment Information:"
echo "Platform: $PLATFORM"
echo "Shell: $SHELL"
echo "Home: $HOME"
echo "Dotfiles: $DOTFILES_DIR"