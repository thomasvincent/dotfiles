# Dotfiles

[![CI](https://github.com/thomasvincent/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/thomasvincent/dotfiles/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Made with Chezmoi](https://img.shields.io/badge/Made%20with-Chezmoi-blue)](https://www.chezmoi.io/)
[![Shell: Zsh](https://img.shields.io/badge/Shell-Zsh-green)](https://www.zsh.org/)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey)]()

> Production-ready dotfiles for DevOps engineers, optimized for macOS with Chezmoi-based management.

---

## Features

| Category | Highlights |
|----------|------------|
| **Package Management** | Homebrew with organized Brewfiles |
| **Dotfiles Management** | Chezmoi templates with conditional features |
| **Security** | GPG signing, SSH agent integration |
| **CI/CD** | GitHub Actions, pre-commit hooks |

---

## Quick Install

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/thomasvincent/dotfiles/main/install.sh)"
```

Or with chezmoi directly:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thomasvincent
```

---

## Structure

```
dotfiles/
├── home/                       # Chezmoi source directory
│   ├── dot_zshrc.tmpl          # Main zsh configuration
│   ├── dot_zshenv.tmpl         # Environment variables
│   ├── dot_zsh/                # 28+ zsh module templates
│   ├── dot_gitconfig.tmpl      # Git configuration
│   ├── dot_config/             # App configurations (starship, etc.)
│   ├── dot_vscode/             # VS Code settings
│   ├── private_dot_ssh/        # SSH configuration (private)
│   └── private_dot_gnupg/      # GPG configuration (private)
├── scripts/                    # Utility scripts
├── tests/                      # Bats test suite
│   ├── test_helper/            # Shared test setup
│   ├── fixtures/               # Test config profiles
│   └── *.bats                  # Test files
├── docs/                       # Documentation
│   ├── ARCHITECTURE.md         # System architecture
│   ├── MODULES.md              # Zsh module reference
│   ├── VARIABLES.md            # Configuration variables
│   ├── INSTALLATION.md         # Installation guide
│   ├── CUSTOMIZATION.md        # Customization guide
│   └── TROUBLESHOOTING.md      # Troubleshooting
├── Brewfile                    # Core Homebrew packages
├── Brewfile.dev                # Development tools
├── Brewfile.devops             # DevOps tools
├── chezmoi.toml                # Chezmoi configuration
├── Makefile                    # Build automation
└── install.sh                  # One-line installer
```

---

## Make Commands

```bash
make help              # Show all commands
make install           # Install dotfiles
make update            # Update from repo
make dev-setup         # Set up dev environment
make cloud-setup       # Configure cloud tools
make test              # Run bats test suite
make test-quick        # Run fast syntax/config tests only
make test-shellcheck   # Run shellcheck on rendered templates
make lint              # Run linters
make backup            # Backup existing dotfiles
```

---

## Configuration

Chezmoi uses `chezmoi.toml` for configuration. Edit with:

```bash
chezmoi edit-config
```

Key settings:

```toml
[data]
    name = "Your Name"
    email = "your.email@example.com"
    github_username = "yourusername"

[data.cloud]
    aws = true
    gcp = false

[data.security]
    gpg_signing = true
    use_ssh_agent = true
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | Template flow, module loading, platform support |
| [Modules](docs/MODULES.md) | All 28+ zsh modules with toggles and functions |
| [Variables](docs/VARIABLES.md) | Complete chezmoi.toml variable reference |
| [Installation](docs/INSTALLATION.md) | Step-by-step setup guide |
| [Customization](docs/CUSTOMIZATION.md) | Feature toggles and adding modules |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common issues and solutions |

---

## Testing

Tests use [bats-core](https://github.com/bats-core/bats-core). Install with `brew install bats-core`.

```bash
make test        # Run full test suite
bats tests/      # Run all tests directly
```

See [tests/README.md](tests/README.md) for details.

---

## Updating

```bash
# Update dotfiles
chezmoi update

# Or via make
make update
```

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Run `make lint` before committing
4. Submit a pull request

---

## License

[MIT](LICENSE) © Thomas Vincent
