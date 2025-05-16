# Contributing to Dotfiles

Thank you for considering contributing to this dotfiles repository!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR-USERNAME/dotfiles.git`
3. Create a branch: `git checkout -b your-feature-branch`
4. Install pre-commit hooks: `pre-commit install`
5. Make your changes
6. Run linting checks: `make lint`
7. Test your changes: `make test`
8. Commit your changes: `git commit -m "Description of changes"`
9. Push to your fork: `git push origin your-feature-branch`
10. Open a pull request

## Repository Structure

- `home/` - Chezmoi template source directory
- `.github/` - GitHub workflows and configs
- `.zsh/` - ZSH configuration modules
- `bin/` - Executable scripts
- `lib/` - Shared functions and utilities
- `Makefile` - Commands for common operations

## Makefile Commands

The repository includes a Makefile for common operations:

```bash
# Show available commands
make help

# Install dotfiles
make install

# Update dotfiles
make update

# Set up development environment
make dev-setup

# Run tests
make test

# Run linters
make lint
```

## Code Standards

- Shell scripts should pass ShellCheck
- YAML files should pass yamllint
- Template files should contain valid template variables
- Maintain consistent style with existing code
- Document new functions and features
- Test your changes before submitting

## Pre-commit Hooks

This repository uses pre-commit hooks to ensure code quality. To install:

```bash
# Install pre-commit
brew install pre-commit

# Set up the hooks
pre-commit install

# Run hooks manually
pre-commit run --all-files
```

## Adding New Cloud Provider Support

If you're adding support for a new cloud provider:

1. Update `chezmoi.toml` with the new provider toggle
2. Add provider-specific configuration to `home/dot_zsh/cloud.zsh.tmpl`
3. Add provider-specific packages to `home/Brewfile.cloud.tmpl`
4. Update the README with the new provider details
5. Add appropriate tests for the new configuration

## Adding New Features

When adding new features:

1. Create a template file in the `home/` directory if needed
2. Update the `chezmoi.toml` with any new configuration options
3. Document the feature in the README
4. Add appropriate tests for the new feature

## Testing

Test any shell changes:

```bash
# Test shell startup
make test

# Test a specific file
shellcheck path/to/file.sh
```

## Pull Request Process

1. Update the README.md with details of changes if appropriate
2. Update any relevant documentation
3. The PR should work on macOS and Linux
4. PRs require approval from repository maintainers
5. Ensure all CI checks pass

## Code of Conduct

Please be respectful and constructive when contributing to this project.