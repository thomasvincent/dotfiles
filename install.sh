#!/usr/bin/env bash

# install.sh
# Author: Thomas Vincent
# GitHub: https://github.com/thomasvincent/dotfiles
#
# This script installs and configures the dotfiles on the current system.

set -e

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
    echo -e "$COL_GREEN[OK]$COL_RESET $1"
}

function bot() {
    echo -e "\n$COL_GREEN\[._.]/$COL_RESET - $1"
}

function running() {
    echo -e "$COL_YELLOW ⇒ $COL_RESET $1"
}

function action() {
    echo -e "\n$COL_YELLOW[action]:$COL_RESET\n ⇒ $1"
}

function warn() {
    echo -e "$COL_YELLOW[warning]$COL_RESET $1"
}

function error() {
    echo -e "$COL_RED[error]$COL_RESET $1"
}

function check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Get the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if running in test mode
TEST_MODE=false
if [[ "$1" == "--test" ]]; then
    TEST_MODE=true
    bot "Running in test mode. No changes will be made."
fi

# Check if Homebrew is installed
bot "Checking for Homebrew installation..."
if ! check_command brew; then
    action "Installing Homebrew..."
    if [[ "$TEST_MODE" == "false" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    ok "Homebrew installed!"
else
    ok "Homebrew is already installed!"
fi

# Install packages from Brewfile
bot "Installing packages from Brewfile..."
if [[ "$TEST_MODE" == "false" ]]; then
    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        running "Installing packages from Brewfile..."
        brew bundle --file="$DOTFILES_DIR/Brewfile"
        ok "Packages installed!"
    else
        error "Brewfile not found!"
    fi
else
    ok "Skipping package installation in test mode."
fi

# Install Oh My Zsh
bot "Checking for Oh My Zsh installation..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    action "Installing Oh My Zsh..."
    if [[ "$TEST_MODE" == "false" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    ok "Oh My Zsh installed!"
else
    ok "Oh My Zsh is already installed!"
fi

# Install Starship prompt
bot "Checking for Starship prompt installation..."
if ! check_command starship; then
    action "Installing Starship prompt..."
    if [[ "$TEST_MODE" == "false" ]]; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
    ok "Starship prompt installed!"
else
    ok "Starship prompt is already installed!"
fi

# Create symbolic links for dotfiles
bot "Creating symbolic links for dotfiles..."
if [[ "$TEST_MODE" == "false" ]]; then
    # Create directories if they don't exist
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.vim/backup"
    mkdir -p "$HOME/.vim/swap"
    mkdir -p "$HOME/.vim/undo"
    
    # Zsh configuration
    running "Linking Zsh configuration files..."
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
    ln -sf "$DOTFILES_DIR/zsh/.aliases" "$HOME/.aliases"
    ln -sf "$DOTFILES_DIR/zsh/.functions" "$HOME/.functions"
    ln -sf "$DOTFILES_DIR/zsh/.exports" "$HOME/.exports"
    
    # Git configuration
    running "Linking Git configuration files..."
    ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
    
    # Vim configuration
    running "Linking Vim configuration files..."
    ln -sf "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
    
    # Starship configuration
    running "Linking Starship configuration files..."
    ln -sf "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
    
    ok "Symbolic links created!"
else
    ok "Skipping symbolic link creation in test mode."
fi

# Configure iTerm2
bot "Configuring iTerm2..."
if [[ "$TEST_MODE" == "false" ]]; then
    if check_command osascript; then
        running "Setting iTerm2 preferences..."
        
        # Check if iTerm2 is installed
        if [[ -d "/Applications/iTerm.app" ]]; then
            # Set iTerm2 preferences directory
            defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
            
            # Tell iTerm2 to use the custom preferences in the directory
            defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
            
            ok "iTerm2 configured!"
        else
            warn "iTerm2 is not installed. Skipping configuration."
        fi
    else
        warn "osascript not available. Skipping iTerm2 configuration."
    fi
else
    ok "Skipping iTerm2 configuration in test mode."
fi

# Apply macOS defaults
bot "Applying macOS defaults..."
if [[ "$TEST_MODE" == "false" ]]; then
    if [[ -f "$DOTFILES_DIR/macos/defaults.sh" ]]; then
        running "Applying macOS defaults..."
        source "$DOTFILES_DIR/macos/defaults.sh"
        ok "macOS defaults applied!"
    else
        warn "macOS defaults script not found. Skipping."
    fi
else
    ok "Skipping macOS defaults in test mode."
fi

# Set up SSH keys
bot "Checking SSH keys..."
if [[ ! -f "$HOME/.ssh/id_rsa" ]]; then
    action "SSH keys not found. Would you like to generate them? (y/n)"
    if [[ "$TEST_MODE" == "false" ]]; then
        read -r response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            ssh-keygen -t rsa -b 4096 -C "$(git config user.email)"
            ok "SSH keys generated!"
        else
            ok "Skipping SSH key generation."
        fi
    else
        ok "Skipping SSH key generation in test mode."
    fi
else
    ok "SSH keys already exist!"
fi

# Set up VS Code
bot "Setting up VS Code..."
if check_command code; then
    if [[ "$TEST_MODE" == "false" ]]; then
        running "Installing VS Code extensions..."
        if [[ -f "$DOTFILES_DIR/vscode/extensions.txt" ]]; then
            while IFS= read -r extension; do
                code --install-extension "$extension"
            done < "$DOTFILES_DIR/vscode/extensions.txt"
            ok "VS Code extensions installed!"
        else
            warn "VS Code extensions list not found. Skipping."
        fi
        
        running "Linking VS Code settings..."
        if [[ -f "$DOTFILES_DIR/vscode/settings.json" ]]; then
            mkdir -p "$HOME/Library/Application Support/Code/User"
            ln -sf "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
            ok "VS Code settings linked!"
        else
            warn "VS Code settings not found. Skipping."
        fi
        
        if [[ -f "$DOTFILES_DIR/vscode/keybindings.json" ]]; then
            ln -sf "$DOTFILES_DIR/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
            ok "VS Code keybindings linked!"
        else
            warn "VS Code keybindings not found. Skipping."
        fi
    else
        ok "Skipping VS Code setup in test mode."
    fi
else
    warn "VS Code not installed. Skipping setup."
fi

# Create .zshrc.local if it doesn't exist
bot "Checking for local configuration..."
if [[ ! -f "$HOME/.zshrc.local" ]]; then
    action "Creating .zshrc.local for local customizations..."
    if [[ "$TEST_MODE" == "false" ]]; then
        touch "$HOME/.zshrc.local"
        ok ".zshrc.local created!"
    else
        ok "Skipping .zshrc.local creation in test mode."
    fi
else
    ok ".zshrc.local already exists!"
fi

# Final steps
bot "Installation complete!"
echo ""
echo "  ____        _    __ _ _           "
echo " |  _ \  ___ | |_ / _(_) | ___  ___ "
echo " | | | |/ _ \| __| |_| | |/ _ \/ __|"
echo " | |_| | (_) | |_|  _| | |  __/\__ \\"
echo " |____/ \___/ \__|_| |_|_|\___||___/"
echo ""
echo "Your dotfiles have been installed and configured!"
echo ""
echo "To apply the changes to your current session, run:"
echo "  source ~/.zshrc"
echo ""
echo "Enjoy your new setup!"
