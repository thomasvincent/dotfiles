# Contributing to Dotfiles

Thank you for considering contributing! This document outlines the process.

## Quick Start

```bash
# Fork and clone
git clone https://github.com/YOUR-USERNAME/dotfiles.git
cd dotfiles

# Install pre-commit hooks
brew install pre-commit
pre-commit install

# Make your changes
git checkout -b feature/my-improvement

# Test
make test
make lint

# Commit with conventional commits
git commit -m "feat: add awesome feature"

# Push and create PR
git push origin feature/my-improvement
```

## Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting |
| `refactor` | Code restructuring |
| `test` | Tests |
| `chore` | Maintenance |

**Examples:**
```
feat: add kubectl fuzzy pod selection
fix(aws): correct profile switching logic
docs: update installation guide
chore: update pre-commit hooks
```

## Code Style

### Shell Scripts

- Use `#!/usr/bin/env zsh` for zsh scripts
- Use `#!/bin/bash` for portable scripts
- Include file header with purpose
- Add comments for complex logic
- Use meaningful variable names
- Quote variables: `"$var"` not `$var`

### Documentation

- Every function needs a description
- Include usage examples
- Document dependencies

## Testing

Before submitting:

```bash
# Test shell startup
make test

# Run linters
make lint

# Test on fresh shell
zsh -i -c 'exit'
```

## Pull Request Process

1. Update documentation if needed
2. Add entry to CHANGELOG.md
3. Ensure CI passes
4. Request review

## Questions?

Open an issue for discussion before major changes.
