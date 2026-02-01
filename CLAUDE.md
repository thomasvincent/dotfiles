# CLAUDE.md

## Purpose
Production-ready dotfiles for DevOps engineers, macOS-optimized with Chezmoi management.

## Stack
- Chezmoi for dotfiles management (chezmoi.toml)
- Zsh shell configuration
- Homebrew (Brewfile, Brewfile.dev, Brewfile.devops, Brewfile.minimal)
- Makefile for common tasks
- GitHub Actions CI
- Shell (Bash/Zsh) scripts

## Build & Test
```bash
make test
shellcheck scripts/*.sh
```

## Conventions
- Shell scripts: `set -euo pipefail`, shellcheck clean, shfmt formatted
- Chezmoi templates (`.tmpl`) for conditional configs
- Profile-based installation (minimal, recommended, dev, devops)
- Scripts in `scripts/`, tests in `tests/`
