# Dotfiles

My personal dotfiles optimized for macOS development.

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

## Components

- `.zsh/` - ZSH configuration modules
  - `lib/` - Shared library functions and utilities
  - `functions.d/` - Individual function files 
  - `dev/` - Development environment configurations
- `.config/` - XDG configuration files
- `bin/` - Executable scripts
- `lib/` - Shared functions and utilities
- `Brewfile` - Homebrew dependencies
- `.github/` - GitHub configuration (workflows, CODEOWNERS)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/thomasvincent/dotfiles.git ~/dotfiles

# Run the setup script
cd ~/dotfiles && ./setup-dotfiles.sh
```

## Using with Chezmoi

Chezmoi provides a more robust way to manage dotfiles across multiple machines:

```bash
# Migrate existing dotfiles to chezmoi
./migrate-to-chezmoi.sh

# After migration, use chezmoi commands
chezmoi edit ~/.zshrc    # Edit zshrc
chezmoi apply            # Apply changes
chezmoi update           # Pull and apply latest changes
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

## Customization

Local configurations that shouldn't be in version control:
- `.zsh/local.zsh` - Local aliases and functions
- `.zsh/secrets.zsh` - API keys and other secrets

## Contributing

Please see [CONTRIBUTING.md](.github/CONTRIBUTING.md) for details on how to contribute to this project.

## License

MIT