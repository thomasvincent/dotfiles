#!/bin/bash
# Installer script for dotfiles
# This script is a wrapper around the Makefile

set -euo pipefail

# Colors
RESET="\033[0m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
else
  OS="unknown"
fi

# Print header
echo -e "${BLUE}=====================================${RESET}"
echo -e "${BLUE} Dotfiles Installation Script       ${RESET}"
echo -e "${BLUE}=====================================${RESET}"
echo

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Test mode
TEST_MODE=0
if [[ "$#" -gt 0 && "$1" == "--test" ]]; then
  TEST_MODE=1
  echo -e "${YELLOW}Running in test mode. No changes will be made.${RESET}"
  exit 0
fi

# Check for make
if ! command_exists make; then
  echo -e "${RED}Error: 'make' is not installed.${RESET}"

  if [[ "$OS" == "macos" ]]; then
    echo -e "${YELLOW}Installing command line tools...${RESET}"
    xcode-select --install || true
  elif [[ "$OS" == "linux" ]]; then
    echo -e "${YELLOW}Installing make...${RESET}"
    if command_exists apt-get; then
      sudo apt-get update && sudo apt-get install -y make
    elif command_exists yum; then
      sudo yum install -y make
    elif command_exists dnf; then
      sudo dnf install -y make
    else
      echo -e "${RED}Unable to install 'make'. Please install it manually.${RESET}"
      exit 1
    fi
  else
    echo -e "${RED}Please install 'make' and try again.${RESET}"
    exit 1
  fi
fi

# Welcome message
echo -e "Welcome to the dotfiles installer!"
echo -e "This script will set up your environment with:"
echo -e "  • ZSH configuration optimized for ${OS}"
echo -e "  • Development tools and utilities"
echo -e "  • Cloud provider integrations"
echo -e "  • Git configuration and aliases"
echo -e "  • Chezmoi for dotfiles management"
echo

# Ask for confirmation
if [[ $TEST_MODE -eq 0 ]]; then
  read -rp "Do you want to continue? [y/N] " response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installation cancelled.${RESET}"
    exit 0
  fi
fi

# Run installer
echo -e "${BLUE}Starting installation...${RESET}"

# Install dependencies for make
if [[ "$OS" == "macos" ]]; then
  if ! command_exists brew; then
    echo -e "${YELLOW}Installing Homebrew...${RESET}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    if [[ "$(uname -m)" == "arm64" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
fi

# Run targets
if [[ $TEST_MODE -eq 0 ]]; then
  make backup
  make brew-install
  make install
  make dev-setup
  make cloud-setup
  make functions
else
  echo -e "${YELLOW}Test mode: would run make targets${RESET}"
  echo -e "  - make backup"
  echo -e "  - make brew-install"
  echo -e "  - make install"
  echo -e "  - make dev-setup"
  echo -e "  - make cloud-setup"
  echo -e "  - make functions"
fi

# Success message
if [[ $TEST_MODE -eq 0 ]]; then
  echo -e "\n${GREEN}✅ Installation complete!${RESET}"
  echo -e "Please restart your terminal or run 'exec zsh' to apply all changes."
  echo -e "You can run 'make help' to see available commands for managing your dotfiles."
else
  echo -e "\n${GREEN}✅ Test completed successfully!${RESET}"
fi

exit 0
