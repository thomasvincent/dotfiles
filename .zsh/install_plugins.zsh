#!/usr/bin/env zsh
# install_plugins.zsh - Install required plugins and tools
# Run this script to ensure all development tools are available

# Load colors for pretty output
autoload -U colors && colors

# Helper function for output
print_info() {
  print -P "%F{blue}===%f %F{white}$1%f"
}

print_success() {
  print -P "%F{green}✓%f %F{white}$1%f"
}

print_warning() {
  print -P "%F{yellow}!%f %F{white}$1%f"
}

print_error() {
  print -P "%F{red}✗%f %F{white}$1%f"
}

# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install Homebrew if not exists
ensure_homebrew() {
  if ! command_exists brew; then
    print_info "Installing Homebrew..."
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
}

# Function to install package with Homebrew
install_brew_package() {
  local package=$1
  local package_name=${2:-$package}

  if ! command_exists "$package"; then
    print_info "Installing $package_name..."
    brew install "$package"
    print_success "$package_name installed"
  else
    print_success "$package_name already installed"
  fi
}

# Function to install ASDF plugin
install_asdf_plugin() {
  local plugin=$1
  local version=${2:-latest}

  if ! command_exists asdf; then
    print_warning "ASDF not found. Installing it first..."
    install_brew_package asdf
  fi

  # Add the plugin if not already added
  if ! asdf plugin list | grep -q "$plugin"; then
    print_info "Adding ASDF plugin: $plugin..."
    asdf plugin add "$plugin"
    print_success "Added $plugin plugin"
  else
    print_success "$plugin plugin already added"
  fi

  # Install the specified version
  if [[ "$version" == "latest" ]]; then
    version=$(asdf latest "$plugin")
  fi

  if ! asdf list "$plugin" | grep -q "$version"; then
    print_info "Installing $plugin $version..."
    asdf install "$plugin" "$version"
    asdf global "$plugin" "$version"
    print_success "Installed $plugin $version"
  else
    print_success "$plugin $version already installed"
  fi
}

# Function to install Zinit if not exists
ensure_zinit() {
  ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

  if [[ ! -d "$ZINIT_HOME" ]]; then
    print_info "Installing Zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    print_success "Zinit installed"
  else
    print_success "Zinit already installed"
  fi
}

# Function to create directory if it doesn't exist
ensure_dir() {
  local dir=$1
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
    print_success "Created directory: $dir"
  fi
}

# Main installation function
install_all_plugins() {
  print_info "Starting installation of required tools and plugins..."

  # Ensure Homebrew is installed
  ensure_homebrew

  # Ensure Zinit is installed
  ensure_zinit

  # Ensure important directories exist
  ensure_dir "${ZDOTDIR:-$HOME}/.zsh/completions"
  ensure_dir "${ZDOTDIR:-$HOME}/.zsh/cache"
  ensure_dir "${ZDOTDIR:-$HOME}/.zsh/functions.d"

  # Install core tools with Homebrew
  print_info "Installing core development tools..."
  install_brew_package git
  install_brew_package gh "GitHub CLI"
  install_brew_package fzf
  install_brew_package ripgrep
  install_brew_package jq
  install_brew_package bat
  install_brew_package fd
  install_brew_package eza "Modern ls replacement"
  install_brew_package zoxide "Smart cd command"
  install_brew_package direnv

  # Install language-specific tools
  print_info "Installing language tools..."

  # ASDF as version manager
  install_brew_package asdf

  # PHP
  if ! command_exists php; then
    install_brew_package php
    install_brew_package composer
  fi

  # Java
  if ! command_exists java; then
    install_asdf_plugin java "temurin-17.0.9+9"
  fi

  # Rust
  if ! command_exists rustc; then
    print_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    print_success "Rust installed"
  fi

  # Ruby
  if ! command_exists ruby; then
    install_asdf_plugin ruby
  fi

  # Python
  if ! command_exists python3; then
    install_asdf_plugin python
  fi

  # Node.js
  if ! command_exists node; then
    install_asdf_plugin nodejs
  fi

  # Cloud tools
  print_info "Installing cloud tools..."

  # AWS CLI
  if ! command_exists aws; then
    install_brew_package awscli "AWS CLI"
  fi

  # DigitalOcean CLI
  if ! command_exists doctl; then
    install_brew_package doctl "DigitalOcean CLI"

    # Generate doctl completions
    if command_exists doctl; then
      doctl completion zsh > "${ZDOTDIR:-$HOME}/.zsh/completions/_doctl"
      print_success "Generated doctl completions"
    fi
  fi

  # Generate GitHub CLI completions
  if command_exists gh; then
    gh completion -s zsh > "${ZDOTDIR:-$HOME}/.zsh/completions/_gh"
    print_success "Generated GitHub CLI completions"
  fi

  print_success "All plugins and tools have been installed!"
  print_info "Please restart your shell or run 'source ~/.zshrc' to apply changes"
}

# Run the installation
install_all_plugins
