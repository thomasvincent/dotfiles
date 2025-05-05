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
mkdir -p "$HOME/.zsh/functions.d"
mkdir -p "$HOME/.zsh/dev"
mkdir -p "$HOME/.zsh/platforms"
mkdir -p "$HOME/.config/zsh/themes"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/dotfiles/backups"
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

# Link ZSH dev directory and contents
echo -e "${BLUE}Linking ZSH developer environments...${RESET}"
mkdir -p "$HOME/.zsh/dev"
for devfile in "$DOTFILES_DIR/.zsh/dev/"*; do
    if [[ -f "$devfile" ]]; then
        filename=$(basename "$devfile")
        link_file "$devfile" "$HOME/.zsh/dev/$filename"
    fi
done

# Create platform directories
echo -e "${BLUE}Creating platform directories...${RESET}"
mkdir -p "$HOME/.zsh/platforms"
for platform in "$DOTFILES_DIR/.zsh/platforms/"*; do
    if [[ -f "$platform" ]]; then
        filename=$(basename "$platform")
        link_file "$platform" "$HOME/.zsh/platforms/$filename"
    fi
done

# Create theme directories for terminal themes
echo -e "${BLUE}Creating theme directories...${RESET}"
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/themes"

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

# Link scripts directory
echo -e "${BLUE}Linking scripts...${RESET}"
mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES_DIR/scripts/"*; do
    if [[ -f "$script" && -x "$script" ]]; then
        filename=$(basename "$script")
        link_file "$script" "$HOME/.local/bin/$filename"
    fi
done

# Ask about Homebrew installation
if command -v brew >/dev/null 2>&1; then
    echo -e "${BLUE}Homebrew is already installed.${RESET}"
    echo -n "Would you like to install packages from the Brewfile? (y/n) "
    read -r install_brew
    
    if [[ "$install_brew" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installing packages from Brewfile...${RESET}"
        brew bundle --file="$DOTFILES_DIR/Brewfile"
        echo -e "${GREEN}Homebrew packages installed.${RESET}"
    fi
else
    echo -e "${YELLOW}Homebrew is not installed.${RESET}"
    echo -n "Would you like to install Homebrew? (y/n) "
    read -r install_brew
    
    if [[ "$install_brew" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installing Homebrew...${RESET}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for the current session
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        echo -n "Would you like to install packages from the Brewfile? (y/n) "
        read -r install_packages
        
        if [[ "$install_packages" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Installing packages from Brewfile...${RESET}"
            brew bundle --file="$DOTFILES_DIR/Brewfile"
            echo -e "${GREEN}Homebrew packages installed.${RESET}"
        fi
    fi
fi

# Create local backups directory
echo -e "${BLUE}Creating backups directory...${RESET}"
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/backups"

echo -e "${GREEN}Dotfiles installation complete!${RESET}"
echo -e "${CYAN}Your old dotfiles have been backed up to ${BACKUP_DIR}${RESET}"
echo -e "${CYAN}New configuration is now in place.${RESET}"
echo ""
echo -e "${YELLOW}Next steps:${RESET}"
echo -e "1. Start a new terminal session or run 'source ~/.zshrc'"
echo -e "2. Customize your local settings in ~/.zsh/local.zsh"
echo -e "3. Use 'theme' command to customize your terminal appearance"
echo -e "4. Run 'dotfiles help' to see available dotfiles management commands"