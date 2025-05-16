# Dotfiles

My personal dotfiles optimized for macOS and Linux development, managed with chezmoi.

## Features

- **DRY and SOLID** - Organized with clean separation of concerns
- **Performance-Optimized** - Fast startup with performance monitoring
- **Modular Architecture** - Each component is isolated and easily maintainable
- **ZSH Configuration** - Powerlevel10k with instant prompt for fast startup
- **Package Management** - Homebrew with Brewfile for easy dependency management
- **Version Management** - ASDF integration for managing multiple language versions
- **Error Handling** - Robust error handling with compatibility layer
- **Error-Free Testing** - Test framework for validating configuration
- **Plugin Management** - Zinit for efficient plugin management
- **Chezmoi Integration** - Dotfile management with chezmoi for cross-machine synchronization
- **Pre-commit Hooks** - Code quality checks before commits
- **Templating** - Configuration files adapt to different environments

## Quick Start

One-line installation:

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/thomasvincent/dotfiles/main/install.sh)"
```

Or clone and install manually:

```bash
# Clone the repository
git clone https://github.com/thomasvincent/dotfiles.git ~/dotfiles

# Run the installation script
cd ~/dotfiles && ./install.sh
```

## Components

- **Templates** - Chezmoi templates for different environments
- **.zsh/** - ZSH configuration modules
- **.config/** - XDG configuration files
- **bin/** - Executable scripts
- **lib/** - Shared functions and utilities
- **.github/** - GitHub configuration (workflows, CODEOWNERS)

## Using Chezmoi

After installation, manage your dotfiles with chezmoi:

```bash
# Edit a dotfile
chezmoi edit ~/.zshrc

# See changes before applying
chezmoi diff

# Apply changes
chezmoi apply

# Update from repository and apply
chezmoi update

# Add a new file to chezmoi
chezmoi add ~/.config/new-config-file
```

## Customization

Chezmoi uses a config file to customize dotfiles for different environments:

```toml
# ~/.config/chezmoi/chezmoi.toml
[data]
    name = "Your Name"
    email = "your.email@example.com"
    github_username = "yourusername"

    # Feature flags
    minimal = false  # Set to true for minimal installation

    # Work-specific settings
    work = true
    work_username = "username"
    work_email = "work.email@company.com"
```

## Development Workflow

This repository uses pre-commit hooks to ensure code quality:

```bash
# Install pre-commit
brew install pre-commit

# Set up the hooks
pre-commit install

# Run hooks manually
pre-commit run --all-files
```

## Key Tools

- **Shell**: ZSH with Powerlevel10k
- **Package Manager**: Homebrew
- **Version Manager**: ASDF
- **Prompt**: Powerlevel10k
- **Terminal**: iTerm2
- **Tools**: Git, fzf, ripgrep, bat, and more
- **Dotfile Manager**: Chezmoi

## Testing

```bash
# Test shell startup for errors
./test_shell_startup.sh
```

## Contributing

Please see [CONTRIBUTING.md](.github/CONTRIBUTING.md) for details on how to contribute to this project.

## License

MIT
