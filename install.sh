#!/bin/bash
# Dotfiles installation script
# Creates symbolic links from the dotfiles repository to the home directory

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for pretty output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
RESET="\033[0m"

# Print a pretty header
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║                    Dotfiles Installation                       ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Backup existing files and create symbolic links
link_file() {
    local src="$1"
    local dst="$2"
    
    # Create the parent directory if it doesn't exist
    mkdir -p "$(dirname "$dst")"
    
    # Backup existing file if it exists and is not a symlink
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}Backing up ${dst} to ${BACKUP_DIR}/${RESET}"
        mv "$dst" "$BACKUP_DIR/"
    fi
    
    # Remove existing symlink
    if [[ -L "$dst" ]]; then
        rm "$dst"
    fi
    
    # Create symlink
    echo -e "${GREEN}Linking ${src} to ${dst}${RESET}"
    ln -sf "$src" "$dst"
}

# Create directories
echo -e "${BLUE}Creating necessary directories...${RESET}"
mkdir -p "$HOME/.zsh"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.cache"

# Link main dotfiles
echo -e "${BLUE}Linking main configuration files...${RESET}"
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
link_file "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"

# Link ZSH directory contents
echo -e "${BLUE}Linking ZSH configuration files...${RESET}"
for zshfile in "$DOTFILES_DIR/.zsh/"*; do
    if [[ -f "$zshfile" ]]; then
        filename=$(basename "$zshfile")
        link_file "$zshfile" "$HOME/.zsh/$filename"
    fi
done

# Link ZSH functions directory and contents
echo -e "${BLUE}Linking ZSH functions...${RESET}"
mkdir -p "$HOME/.zsh/functions.d"
for funcfile in "$DOTFILES_DIR/.zsh/functions.d/"*; do
    if [[ -f "$funcfile" ]]; then
        filename=$(basename "$funcfile")
        link_file "$funcfile" "$HOME/.zsh/functions.d/$filename"
    fi
done

# Link config directory contents
echo -e "${BLUE}Linking config directories...${RESET}"
for config in "$DOTFILES_DIR/.config/"*; do
    if [[ -d "$config" ]]; then
        dirname=$(basename "$config")
        link_file "$config" "$HOME/.config/$dirname"
    fi
done

# Create local ZSH files if they don't exist
echo -e "${BLUE}Creating local configuration files...${RESET}"
if [[ ! -f "$HOME/.zsh/local.zsh" ]]; then
    cat > "$HOME/.zsh/local.zsh" <<EOL
#!/usr/bin/env zsh
# This file is for machine-specific configurations
# It should not be committed to version control
EOL
    echo -e "${GREEN}Created $HOME/.zsh/local.zsh${RESET}"
fi

if [[ ! -f "$HOME/.zsh/secrets.zsh" ]]; then
    cat > "$HOME/.zsh/secrets.zsh" <<EOL
#!/usr/bin/env zsh
# This file is for private API keys and tokens
# It should not be committed to version control
EOL
    chmod 600 "$HOME/.zsh/secrets.zsh"
    echo -e "${GREEN}Created $HOME/.zsh/secrets.zsh${RESET}"
fi

echo -e "${GREEN}Dotfiles installation complete!${RESET}"
echo -e "${CYAN}Your old dotfiles have been backed up to ${BACKUP_DIR}${RESET}"
echo -e "${CYAN}New configuration is now in place.${RESET}"
echo ""
echo -e "${YELLOW}Next steps:${RESET}"
echo -e "1. Start a new terminal session or run 'source ~/.zshrc'"
echo -e "2. Customize your local settings in ~/.zsh/local.zsh"