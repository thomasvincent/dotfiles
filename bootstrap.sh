#!/usr/bin/env bash

# Change to the script's directory (error handling for robustness)
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1  

# Pull latest changes from the 'main' branch (explicit and recommended)
git pull origin main

# Function to synchronize dotfiles
sync_dotfiles() {
    rsync \
        --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        -avh --no-perms . ~
    source ~/.bash_profile  # Re-source bash profile to apply changes
}

# Check for force flag
if [[ "$1" == "--force" || "$1" == "-f" ]]; then
    sync_dotfiles
else
    # User confirmation (improved prompt for clarity)
    read -r -p "This may overwrite files in your home directory. Are you sure? (y/n) " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        sync_dotfiles
    else
        echo "Synchronization aborted."
    fi
fi
