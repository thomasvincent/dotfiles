#!/bin/bash
# Script to install/update Homebrew and packages from Brewfile
# Run this script to keep your system up to date

set -e  # Exit on error

DOTFILES_DIR="$HOME/dotfiles"
BREWFILE="$DOTFILES_DIR/Brewfile"

# Colors for pretty output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
RESET="\033[0m"

# Print a step header
print_step() {
  echo -e "\n${BLUE}=== $1 ===${RESET}\n"
}

# Check if Homebrew is installed
check_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    print_step "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    print_step "Homebrew already installed"
  fi
}

# Update Homebrew
update_brew() {
  print_step "Updating Homebrew"
  brew update
}

# Install packages from Brewfile
install_packages() {
  if [[ ! -f "$BREWFILE" ]]; then
    echo -e "${RED}Brewfile not found at $BREWFILE${RESET}"
    exit 1
  fi

  print_step "Installing packages from Brewfile"
  brew bundle install --file="$BREWFILE"
}

# Cleanup old versions
cleanup() {
  print_step "Cleaning up old versions"
  brew cleanup
}

# Check for outdated packages
check_outdated() {
  print_step "Checking for outdated packages"
  brew outdated
}

# Upgrade all packages
upgrade() {
  print_step "Upgrading all packages"
  brew upgrade
}

# Main function
main() {
  echo -e "${CYAN}╔════════════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}║        Homebrew Package Management             ║${RESET}"
  echo -e "${CYAN}╚════════════════════════════════════════════════╝${RESET}"

  check_brew
  update_brew

  # Check if we need to install packages
  if [[ "$1" == "--install" ]]; then
    install_packages
  else
    echo -e "${YELLOW}Run with --install to install packages from Brewfile${RESET}"
  fi

  check_outdated

  # Ask if user wants to upgrade
  echo -ne "${YELLOW}Do you want to upgrade all packages? [y/N] ${RESET}"
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    upgrade
  fi

  # Ask if user wants to cleanup
  echo -ne "${YELLOW}Do you want to clean up old versions? [y/N] ${RESET}"
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    cleanup
  fi

  echo -e "\n${GREEN}Homebrew update complete!${RESET}"
}

# Run the main function
main "$@"
