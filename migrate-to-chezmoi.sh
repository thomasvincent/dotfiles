#!/bin/bash
set -euo pipefail

echo "Setting up chezmoi for dotfiles management..."

# Check if chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
    echo "Installing chezmoi..."
    if command -v brew &> /dev/null; then
        brew install chezmoi
    else
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi

# Initialize chezmoi with the existing dotfiles
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Initializing chezmoi with dotfiles from: $DOTFILES_DIR"

# Create a source directory for chezmoi
mkdir -p "${HOME}/.local/share/chezmoi/home"

# Copy key dotfiles to chezmoi source directory
echo "Migrating dotfiles to chezmoi format..."
files_to_migrate=(
    ".zshrc"
    ".zprofile"
    ".zshenv"
    ".zsh"
    ".config"
    ".gitignore"
    ".tool-versions"
    "bin"
)

for file in "${files_to_migrate[@]}"; do
    if [ -e "$DOTFILES_DIR/$file" ]; then
        echo "Adding $file to chezmoi..."
        chezmoi add "$DOTFILES_DIR/$file"
    fi
done

# Copy chezmoi configuration
if [ -f "$DOTFILES_DIR/chezmoi.toml" ]; then
    mkdir -p "${HOME}/.config/chezmoi"
    cp "$DOTFILES_DIR/chezmoi.toml" "${HOME}/.config/chezmoi/chezmoi.toml"
    echo "Configured chezmoi with settings from chezmoi.toml"
fi

echo "Migration to chezmoi complete!"
echo "You can now use 'chezmoi' commands to manage your dotfiles:"
echo "  - chezmoi edit <file> : Edit a dotfile"
echo "  - chezmoi apply       : Apply changes"
echo "  - chezmoi update      : Pull and apply the latest changes"
echo "  - chezmoi cd          : Go to the source directory"