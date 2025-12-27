# Installation Guide

> **TL;DR**: One-liner install at the bottom of this page.

This guide covers multiple installation methods for different scenarios.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Install](#quick-install)
- [Manual Install](#manual-install)
- [Post-Install Setup](#post-install-setup)
- [Updating](#updating)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required

- **macOS 12+** or **Linux** (Ubuntu 20.04+, Debian 11+)
- **Zsh 5.8+** (default on macOS)
- **Git 2.30+**
- **curl** or **wget**

### Recommended

- **Homebrew** (macOS) - Package manager
- **Terminal** - iTerm2, Alacritty, or Kitty for best experience
- **Nerd Font** - For Powerlevel10k icons (e.g., MesloLGS NF)

---

## Quick Install

### One-Liner (Recommended)

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/thomasvincent/dotfiles/main/install.sh)"
```

This script will:
1. Install Homebrew (if on macOS and not present)
2. Install chezmoi
3. Clone and apply dotfiles
4. Install core packages from Brewfile

---

## Manual Install

### Step 1: Clone the Repository

```bash
# Clone to ~/dotfiles (recommended location)
git clone https://github.com/thomasvincent/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Step 2: Install Chezmoi

**macOS (Homebrew):**
```bash
brew install chezmoi
```

**Linux:**
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"
```

### Step 3: Initialize and Apply

```bash
# Initialize chezmoi with this repo
chezmoi init ~/dotfiles

# Preview changes (optional but recommended)
chezmoi diff

# Apply the dotfiles
chezmoi apply -v
```

### Step 4: Install Packages

```bash
# Core packages
brew bundle install --file=~/dotfiles/Brewfile

# Development tools (optional)
brew bundle install --file=~/dotfiles/Brewfile.dev

# Recommended extras (optional)
brew bundle install --file=~/dotfiles/Brewfile.recommended
```

---

## Post-Install Setup

### 1. Configure Powerlevel10k

On first shell launch, the p10k configuration wizard will start automatically.
Alternatively, run:

```bash
p10k configure
```

### 2. Install a Nerd Font

```bash
# Using Homebrew
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

Then set your terminal font to "MesloLGS NF".

### 3. Set Up Cloud Tools (Optional)

```bash
make cloud-setup
```

### 4. Set Up Development Environment (Optional)

```bash
make dev-setup
```

---

## Updating

### Update Dotfiles

```bash
# Using chezmoi (recommended)
chezmoi update -v

# Or using make
make update
```

### Update Packages

```bash
# Update Homebrew packages
brew update && brew upgrade

# Update chezmoi
brew upgrade chezmoi
```

---

## Troubleshooting

### Shell Startup Errors

```bash
# Test shell startup
make test

# Or manually
zsh -i -c 'exit'
```

### Chezmoi Conflicts

```bash
# See what would change
chezmoi diff

# Force apply (overwrites local changes)
chezmoi apply --force

# Re-add a modified file
chezmoi add ~/.zshrc
```

### Missing Commands

```bash
# Reinstall packages
brew bundle install --file=~/dotfiles/Brewfile

# Check if tool is installed
command -v <tool-name>
```

### Slow Shell Startup

```bash
# Profile startup time
time zsh -i -c 'exit'

# Should be under 500ms. If slow, check:
# 1. Network-dependent tools (nvm, rbenv loading)
# 2. Heavy plugins
# 3. Disk I/O issues
```

---

## Uninstall

To remove the dotfiles:

```bash
# Remove chezmoi state
chezmoi purge

# Remove dotfiles repo
rm -rf ~/dotfiles

# Optionally remove chezmoi
brew uninstall chezmoi
```

This won't remove the config files chezmoi placed - you'll need to manually delete those or restore from backup.
