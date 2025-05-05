# Modern macOS Dotfiles Setup

This repository contains a modern, modular dotfiles configuration optimized for macOS development.

## Features

- **Modular ZSH configuration** - Organized, easy to maintain configuration files
- **XDG Base Directory support** - Cleaner home directory with proper organization
- **Optimized PATH management** - Well-structured path configuration for all tools
- **Enhanced Git configuration** - Modern Git settings optimized for macOS
- **Powerful shell aliases** - Productivity-enhancing shortcuts and functions
- **macOS-specific tooling** - Functions tailored for macOS development
- **Improved performance** - Optimized shell startup and completion system
- **Clean and consistent syntax** - Well-documented configuration files
- **Easy to customize** - Simple structure for modifications

## Installation

1. Clone this repository to your machine:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Run the setup script:

```bash
chmod +x setup-dotfiles.sh
./setup-dotfiles.sh
```

3. Start a new terminal session to apply the changes.

## Directory Structure

```
$HOME/
├── .zshenv                  # Global environment variables
├── .zshrc                   # Main ZSH configuration
├── .zprofile                # Login shell configuration
├── .zsh/                    # ZSH configuration directory
│   ├── path.zsh             # PATH management
│   ├── env.zsh              # Environment variables
│   ├── aliases.zsh          # Aliases
│   ├── completions.zsh      # Completion configuration
│   ├── functions.d/         # ZSH functions
│   ├── local.zsh            # Machine-specific settings
│   └── secrets.zsh          # Private tokens/keys
├── .config/                 # XDG config directory
│   ├── git/                 # Git configuration
│   ├── vim/                 # Vim configuration
│   └── ...                  # Other tool configs
└── .local/bin/              # User executables
```

## Customization

### Add your own aliases

Edit `~/.zsh/aliases.zsh` to add your personal aliases.

### Add custom functions

Create new function files in `~/.zsh/functions.d/` directory. Files are loaded in order, so use numerical prefixes (e.g., `100_myfunctions.zsh`) to control load order.

### Machine-specific configuration

Add machine-specific settings to `~/.zsh/local.zsh`. This file is not tracked in version control.

### Private tokens and API keys

Store API keys and tokens in `~/.zsh/secrets.zsh`. This file is not tracked in version control.

## Key Features

### Enhanced Git Workflow

The Git configuration includes numerous aliases and settings to improve your Git workflow:

```bash
# See status in compact form
g s

# Create and push a new branch
g new feature/awesome-feature
g publish

# Interactive rebase last 5 commits
g reb 5
```

### macOS-Specific Tools

Several macOS-specific functions are included:

```bash
# Lock your screen
lock

# Clean up .DS_Store files
cleanup_ds_store

# Show/hide hidden files
showhidden
hidehidden

# See system information
sysinfo

# Convert image formats
convertimg input.png output.jpg
```

### Development Helpers

Shortcuts for common development tasks:

```bash
# Start a simple HTTP server
serve 8080

# Create and activate Python virtual environment
venv && act

# Homebrew updates
brewup
```

## Credit

These dotfiles were crafted by [Thomas Vincent](https://github.com/thomasvincent) with assistance from Claude AI.

## License

MIT License