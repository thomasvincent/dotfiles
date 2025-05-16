# Contributing to Dotfiles

Thank you for considering contributing to this dotfiles repository!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR-USERNAME/dotfiles.git`
3. Create a branch: `git checkout -b your-feature-branch`
4. Make your changes
5. Run pre-commit checks: `pre-commit run --all-files`
6. Commit your changes: `git commit -m "Description of changes"`
7. Push to your fork: `git push origin your-feature-branch`
8. Open a pull request

## Code Standards

- Shell scripts should pass ShellCheck
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
```

## Testing

Test any shell changes:

```bash
./test_shell_startup.sh
```

## Pull Request Process

1. Update the README.md with details of changes if appropriate
2. Update any relevant documentation
3. The PR should work on macOS (the primary supported platform)
4. PRs require approval from repository maintainers

## Code of Conduct

Please be respectful and constructive when contributing to this project.
