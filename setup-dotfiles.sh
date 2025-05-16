#!/bin/bash
# setup-dotfiles.sh - Create dotfiles directory structure
#
# This script creates the recommended dotfiles directory structure
# and moves existing configurations into the new structure.
#

set -e  # Exit on error

# Colors for pretty output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
RESET="\033[0m"

# Print a pretty header
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║                    Dotfiles Setup Script                       ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Base directories
HOME_DIR="$HOME"
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
ZSH_DIR="$HOME/.zsh"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN_DIR="$HOME/.local/bin"
LOCAL_SHARE_DIR="$HOME/.local/share"
CACHE_DIR="$HOME/.cache"

# Create backup directory
echo -e "${YELLOW}Creating backup directory at ${BACKUP_DIR}...${RESET}"
mkdir -p "$BACKUP_DIR"

# Create base directories
echo -e "${YELLOW}Creating directory structure...${RESET}"
mkdir -p "$ZSH_DIR"/{functions.d,completions,themes,cache,logs}
mkdir -p "$CONFIG_DIR"/{git,vim,tmux,bat,htop,ripgrep,alacritty}
mkdir -p "$LOCAL_BIN_DIR"
mkdir -p "$LOCAL_SHARE_DIR"
mkdir -p "$CACHE_DIR"

# Backup existing files
backup_file() {
    local file="$1"
    if [[ -f "$file" || -d "$file" ]]; then
        echo -e "${BLUE}Backing up ${file} to ${BACKUP_DIR}${RESET}"
        cp -R "$file" "$BACKUP_DIR/"
    fi
}

# Make directories if they don't exist
make_dir_if_missing() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo -e "${YELLOW}Creating directory ${dir}${RESET}"
        mkdir -p "$dir"
    fi
}

# Backup existing dotfiles
echo -e "${YELLOW}Backing up existing dotfiles...${RESET}"
backup_file "$HOME/.zshrc"
backup_file "$HOME/.zshenv"
backup_file "$HOME/.zprofile"
backup_file "$HOME/.bashrc"
backup_file "$HOME/.bash_profile"
backup_file "$HOME/.profile"
backup_file "$HOME/.gitconfig"
backup_file "$HOME/.gitignore_global"
backup_file "$HOME/.vimrc"
backup_file "$HOME/.vim"
backup_file "$HOME/.tmux.conf"
backup_file "$HOME/.p10k.zsh"

# Copy new ZSH configuration files
echo -e "${YELLOW}Setting up ZSH configuration...${RESET}"
cp "$HOME/Desktop/zshrc.new" "$HOME/.zshrc"
cp "$HOME/Desktop/zshenv.new" "$HOME/.zshenv"
cp "$HOME/Desktop/zprofile.new" "$HOME/.zprofile"
cp "$HOME/Desktop/path.zsh" "$ZSH_DIR/"
cp "$HOME/Desktop/env.zsh" "$ZSH_DIR/"
cp "$HOME/Desktop/aliases.zsh" "$ZSH_DIR/"
cp "$HOME/Desktop/completions.zsh" "$ZSH_DIR/"

# Copy existing configurations to new structure
echo -e "${YELLOW}Migrating existing configurations...${RESET}"

# Git
if [[ -f "$HOME/.gitconfig" ]]; then
    echo -e "${BLUE}Migrating Git configuration...${RESET}"
    cp "$HOME/.gitconfig" "$CONFIG_DIR/git/config"
fi

if [[ -f "$HOME/.gitignore_global" ]]; then
    cp "$HOME/.gitignore_global" "$CONFIG_DIR/git/ignore"
fi

# Vim
if [[ -f "$HOME/.vimrc" ]]; then
    echo -e "${BLUE}Migrating Vim configuration...${RESET}"
    cp "$HOME/.vimrc" "$CONFIG_DIR/vim/vimrc"
    if [[ -d "$HOME/.vim" ]]; then
        cp -R "$HOME/.vim/"* "$CONFIG_DIR/vim/"
    fi
fi

# Tmux
if [[ -f "$HOME/.tmux.conf" ]]; then
    echo -e "${BLUE}Migrating Tmux configuration...${RESET}"
    cp "$HOME/.tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"
fi

# Powerlevel10k
if [[ -f "$HOME/.p10k.zsh" ]]; then
    echo -e "${BLUE}Migrating Powerlevel10k configuration...${RESET}"
    cp "$HOME/.p10k.zsh" "$ZSH_DIR/themes/p10k.zsh"
    # Create symlink to where p10k expects it
    ln -sf "$ZSH_DIR/themes/p10k.zsh" "$HOME/.p10k.zsh"
fi

# Create empty local configuration files if they don't exist
echo -e "${YELLOW}Creating template files...${RESET}"
if [[ ! -f "$ZSH_DIR/local.zsh" ]]; then
    cat > "$ZSH_DIR/local.zsh" <<EOL
#!/usr/bin/env zsh
# This file is for machine-specific configurations
# It should not be committed to version control
EOL
fi

if [[ ! -f "$ZSH_DIR/secrets.zsh" ]]; then
    cat > "$ZSH_DIR/secrets.zsh" <<EOL
#!/usr/bin/env zsh
# This file is for private API keys and tokens
# It should not be committed to version control
EOL
    chmod 600 "$ZSH_DIR/secrets.zsh"
fi

# Create a basic functions file
if [[ ! -f "$ZSH_DIR/functions.d/000_core.zsh" ]]; then
    cat > "$ZSH_DIR/functions.d/000_core.zsh" <<EOL
#!/usr/bin/env zsh
# Core utility functions

# Reload ZSH configuration
reload() {
  source "\$HOME/.zshrc"
  echo "ZSH configuration reloaded"
}

# Manage dotfiles
dotfiles() {
  cd "\$HOME/dotfiles" 2>/dev/null || echo "Dotfiles directory not found"
}
EOL
fi

# Create basic Git functions
if [[ ! -f "$ZSH_DIR/functions.d/200_git.zsh" ]]; then
    cat > "$ZSH_DIR/functions.d/200_git.zsh" <<EOL
#!/usr/bin/env zsh
# Git utility functions

# Show git repository status in a compact format
gstat() {
  git status -sb
}

# Show git log with a pretty format
glog() {
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}
EOL
fi

# Update Git configuration to use XDG paths
if [[ -f "$CONFIG_DIR/git/config" ]]; then
    echo -e "${YELLOW}Updating Git configuration to use XDG paths...${RESET}"
    # Update core.excludesfile to point to the new location
    sed -i.bak "s|~/.gitignore_global|\$HOME/.config/git/ignore|g" "$CONFIG_DIR/git/config"
    rm "$CONFIG_DIR/git/config.bak" 2>/dev/null || true
fi

# Create a Git user configuration
if [[ ! -f "$CONFIG_DIR/git/credentials" ]]; then
    echo -e "${YELLOW}Creating Git credentials file...${RESET}"
    cat > "$CONFIG_DIR/git/credentials" <<EOL
# Git user configuration
# Include this file from your main git config with:
# [include]
#     path = ~/.config/git/credentials

[user]
    name = $(git config --get user.name 2>/dev/null || echo "Your Name")
    email = $(git config --get user.email 2>/dev/null || echo "your.email@example.com")
    # signingkey = YOUR_GPG_KEY_ID
EOL
    chmod 600 "$CONFIG_DIR/git/credentials"
fi

# Create a dotfiles repository if it doesn't exist
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW}Creating dotfiles repository...${RESET}"
    mkdir -p "$DOTFILES_DIR"
    cat > "$DOTFILES_DIR/README.md" <<EOL
# Dotfiles

My personal dotfiles configuration for macOS.

## Installation

\`\`\`bash
cd ~
git clone <your-repo-url> dotfiles
cd dotfiles
./install.sh
\`\`\`

## Structure

- \`.zsh/\`: ZSH configuration files
- \`.config/\`: XDG Base Directory configurations
- \`.local/bin/\`: User executables
EOL

    # Create a basic installation script
    cat > "$DOTFILES_DIR/install.sh" <<EOL
#!/bin/bash
# Dotfiles installation script
# Creates symbolic links from the dotfiles repository to the home directory

set -e  # Exit on error

DOTFILES_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="\$HOME/dotfiles_backup_\$(date +%Y%m%d_%H%M%S)"

# Backup existing files and create symbolic links
link_file() {
    local src="\$1"
    local dst="\$2"

    # Create the parent directory if it doesn't exist
    mkdir -p "\$(dirname "\$dst")"

    # Backup existing file if it exists and is not a symlink
    if [[ -e "\$dst" && ! -L "\$dst" ]]; then
        mkdir -p "\$BACKUP_DIR"
        mv "\$dst" "\$BACKUP_DIR/"
        echo "Backed up \$dst to \$BACKUP_DIR/"
    fi

    # Create symlink
    ln -sf "\$src" "\$dst"
    echo "Linked \$src to \$dst"
}

# Link main dotfiles
link_file "\$DOTFILES_DIR/.zshrc" "\$HOME/.zshrc"
link_file "\$DOTFILES_DIR/.zshenv" "\$HOME/.zshenv"
link_file "\$DOTFILES_DIR/.zprofile" "\$HOME/.zprofile"

# Link ZSH directory
link_file "\$DOTFILES_DIR/.zsh" "\$HOME/.zsh"

# Link config directory
for config in "\$DOTFILES_DIR/.config/"*; do
    if [[ -d "\$config" ]]; then
        dirname="\$(basename "\$config")"
        link_file "\$config" "\$HOME/.config/\$dirname"
    fi
done

echo "Dotfiles installation complete!"
EOL
    chmod +x "$DOTFILES_DIR/install.sh"
fi

echo -e "${GREEN}Dotfiles setup complete!${RESET}"
echo -e "${CYAN}Your old dotfiles have been backed up to ${BACKUP_DIR}${RESET}"
echo -e "${CYAN}New configuration files have been created at:${RESET}"
echo -e "${CYAN}  - $HOME/.zshrc, $HOME/.zshenv, $HOME/.zprofile${RESET}"
echo -e "${CYAN}  - $ZSH_DIR/ (ZSH configuration files)${RESET}"
echo -e "${CYAN}  - $CONFIG_DIR/ (XDG Base Directory configurations)${RESET}"
echo ""
echo -e "${YELLOW}Next steps:${RESET}"
echo -e "${YELLOW}1. Review the new configuration files${RESET}"
echo -e "${YELLOW}2. Start a new terminal session or run 'source ~/.zshrc'${RESET}"
echo -e "${YELLOW}3. Consider putting your dotfiles under version control:${RESET}"
echo -e "${YELLOW}   cd $DOTFILES_DIR && git init${RESET}"
