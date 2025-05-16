#!/bin/bash
set -euo pipefail

# Dotfiles installation script
# This script installs chezmoi and uses it to apply dotfiles

echo "==> Starting dotfiles installation"

# Installation directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if running on a supported OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "Warning: Unsupported OS. Some features may not work correctly."
    OS="unknown"
fi

# Install dependencies based on OS
install_dependencies() {
    echo "==> Installing dependencies for $OS"

    if [[ "$OS" == "macos" ]]; then
        # Check if Homebrew is installed
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        # Install chezmoi using Homebrew
        if ! command -v chezmoi &> /dev/null; then
            brew install chezmoi
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Install chezmoi directly
        if ! command -v chezmoi &> /dev/null; then
            echo "Installing chezmoi..."
            sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
            export PATH="$HOME/.local/bin:$PATH"
        fi
    fi
}

# Ask for user data for templating
configure_user_data() {
    echo "==> Configuring user data"

    # Create chezmoi config directory
    mkdir -p "$HOME/.config/chezmoi"

    # Start with template configuration
    cp "$DOTFILES_DIR/chezmoi.toml" "$HOME/.config/chezmoi/chezmoi.toml"

    # Get user input for personalization
    read -p "Enter your full name: " USER_NAME
    read -p "Enter your email: " USER_EMAIL
    read -p "Enter your GitHub username: " GITHUB_USERNAME

    # Update configuration file
    if [[ "$OS" == "macos" ]]; then
        sed -i '' "s/name = \".*\"/name = \"$USER_NAME\"/" "$HOME/.config/chezmoi/chezmoi.toml"
        sed -i '' "s/email = \".*\"/email = \"$USER_EMAIL\"/" "$HOME/.config/chezmoi/chezmoi.toml"
        sed -i '' "s/github_username = \".*\"/github_username = \"$GITHUB_USERNAME\"/" "$HOME/.config/chezmoi/chezmoi.toml"
    else
        sed -i "s/name = \".*\"/name = \"$USER_NAME\"/" "$HOME/.config/chezmoi/chezmoi.toml"
        sed -i "s/email = \".*\"/email = \"$USER_EMAIL\"/" "$HOME/.config/chezmoi/chezmoi.toml"
        sed -i "s/github_username = \".*\"/github_username = \"$GITHUB_USERNAME\"/" "$HOME/.config/chezmoi/chezmoi.toml"
    fi

    echo "User data configured"
}

# Apply dotfiles using chezmoi
apply_dotfiles() {
    echo "==> Applying dotfiles with chezmoi"

    # Initialize chezmoi with the dotfiles repository
    chezmoi init "$DOTFILES_DIR"

    # Apply the dotfiles
    chezmoi apply -v

    echo "Dotfiles applied successfully"
}

# Install additional tools and applications
install_additional_tools() {
    echo "==> Installing additional tools"

    if [[ "$OS" == "macos" ]]; then
        # Install packages from Brewfile
        if [ -f "$HOME/Brewfile" ]; then
            echo "Installing packages from Brewfile..."
            brew bundle --file="$HOME/Brewfile"
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Install common packages
        echo "Installing common packages on Linux..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y git zsh curl wget ripgrep fd-find bat tmux neovim
        elif command -v yum &> /dev/null; then
            sudo yum install -y git zsh curl wget ripgrep fd tmux neovim
        fi
    fi

    # Install Oh-My-Zsh if needed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Change default shell to zsh
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Changing default shell to zsh..."
        chsh -s "$(which zsh)"
    fi
}

# Main installation process
main() {
    echo "Starting dotfiles installation..."

    install_dependencies
    configure_user_data
    apply_dotfiles
    install_additional_tools

    echo "==> Installation complete!"
    echo "Please restart your terminal for all changes to take effect."
    echo "To update your dotfiles in the future, run: chezmoi update"
}

# Run the main function
main
