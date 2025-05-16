#!/bin/bash
# setup-dev-environment.sh - Set up the complete development environment
# This script sets up all tools needed for PHP, Java, Groovy, Python, Ruby, Rust, GitHub, and DigitalOcean

# Colors for output
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Helper functions
print_header() {
  echo -e "${BLUE}====== $1 ======${RESET}"
}

print_success() {
  echo -e "${GREEN}✓ $1${RESET}"
}

print_warning() {
  echo -e "${YELLOW}! $1${RESET}"
}

print_error() {
  echo -e "${RED}✗ $1${RESET}"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check for macOS
if [[ "$(uname)" != "Darwin" ]]; then
  print_error "This script is designed for macOS only."
  exit 1
fi

# Welcome message
print_header "Setting up your macOS Development Environment"
echo "This script will set up all the tools needed for your workflow with:"
echo "- PHP, Java, Groovy, Python, Ruby, Rust"
echo "- GitHub and DigitalOcean integration"
echo "- A complete dotfiles configuration"
echo

# Ask for confirmation
read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Setup cancelled."
  exit 0
fi

# 1. Install Homebrew if not already installed
print_header "Checking for Homebrew"
if ! command_exists brew; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH based on architecture
  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  print_success "Homebrew installed"
else
  print_success "Homebrew already installed"
fi

# 2. Install development tools with Brewfile
print_header "Installing development tools"
if [[ -f "${HOME}/dotfiles/Brewfile.dev" ]]; then
  echo "Installing development tools from Brewfile.dev..."
  brew bundle install --file="${HOME}/dotfiles/Brewfile.dev"
  print_success "Development tools installed"
else
  print_error "Brewfile.dev not found. Skipping tool installation."
fi

# 3. Set up ZSH configuration
print_header "Setting up ZSH configuration"

# Create symbolic links for dotfiles
echo "Creating symbolic links for dotfiles..."
# Link all .zsh files
mkdir -p "${HOME}/.zsh"
for file in "${HOME}/dotfiles/.zsh"/*; do
  if [[ -f "$file" ]]; then
    ln -sf "$file" "${HOME}/.zsh/$(basename "$file")"
  fi
done

# Link main dotfiles
ln -sf "${HOME}/dotfiles/.zshrc" "${HOME}/.zshrc"
ln -sf "${HOME}/dotfiles/.zshenv" "${HOME}/.zshenv"
ln -sf "${HOME}/dotfiles/.zprofile" "${HOME}/.zprofile"

print_success "ZSH configuration linked"

# 4. Install ASDF plugins for language version management
print_header "Setting up ASDF version manager"
if command_exists asdf; then
  echo "Installing ASDF plugins..."

  # Add plugins if they don't exist
  asdf plugin add nodejs || true
  asdf plugin add python || true
  asdf plugin add ruby || true
  asdf plugin add java || true
  asdf plugin add golang || true

  # Install latest versions
  asdf install nodejs latest
  asdf install python latest
  asdf install ruby latest
  asdf install java temurin-17.0.9+9
  asdf install golang latest

  # Set global versions
  asdf global nodejs latest
  asdf global python latest
  asdf global ruby latest
  asdf global java temurin-17.0.9+9
  asdf global golang latest

  print_success "ASDF plugins installed and configured"
else
  print_error "ASDF not found. Please install ASDF first."
fi

# 5. Set up Rust with rustup
print_header "Setting up Rust"
if ! command_exists rustc; then
  echo "Installing Rust with rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"

  # Install some useful Rust tools
  cargo install cargo-update
  cargo install cargo-edit

  print_success "Rust installed"
else
  print_success "Rust already installed"
fi

# 6. Install ZSH plugins
print_header "Setting up ZSH plugins"
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  echo "Installing Zinit..."
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  print_success "Zinit installed"
else
  print_success "Zinit already installed"
fi

# 7. Install cloud platform CLIs
print_header "Setting up cloud tools"

# DigitalOcean CLI completions
if command_exists doctl; then
  echo "Generating doctl completions..."
  mkdir -p "${HOME}/.zsh/completions"
  doctl completion zsh > "${HOME}/.zsh/completions/_doctl"
  print_success "DigitalOcean CLI configured"
fi

# GitHub CLI completions
if command_exists gh; then
  echo "Generating GitHub CLI completions..."
  mkdir -p "${HOME}/.zsh/completions"
  gh completion -s zsh > "${HOME}/.zsh/completions/_gh"

  # Configure GitHub CLI if not configured
  if ! gh auth status 2>/dev/null; then
    echo "Please authenticate with GitHub:"
    gh auth login
  fi

  print_success "GitHub CLI configured"
fi

# 8. Run the ZSH plugin installer
print_header "Running ZSH plugin installer"
if [[ -f "${HOME}/dotfiles/.zsh/install_plugins.zsh" ]]; then
  echo "Installing ZSH plugins..."
  zsh "${HOME}/dotfiles/.zsh/install_plugins.zsh"
  print_success "ZSH plugins installed"
else
  print_error "install_plugins.zsh not found. Skipping ZSH plugin installation."
fi

# 9. Final steps and cleanup
print_header "Final steps"

# Create required directories
mkdir -p "${HOME}/.zsh/completions"
mkdir -p "${HOME}/.zsh/cache"
mkdir -p "${HOME}/.zsh/functions.d"

# Ensure proper permissions
chmod +x "${HOME}/dotfiles/.zsh/install_plugins.zsh"
chmod +x "${HOME}/dotfiles/setup-dev-environment.sh"

# Reload ZSH configuration
echo "Reloading ZSH configuration..."
exec zsh -l

print_success "Development environment setup complete!"
echo "Please restart your terminal for all changes to take effect."
