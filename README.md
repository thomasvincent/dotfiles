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
├── home/                    # Chezmoi source directory
│   ├── dot_zshrc.tmpl       # Zsh configuration template
│   ├── dot_zshenv.tmpl      # Environment variables template
│   └── dot_zsh/             # Zsh module templates
├── scripts/                 # Utility scripts
│   ├── health-check.sh      # Verify installation
│   ├── backup-dotfiles.sh   # Create backups
│   └── macos-defaults.sh    # macOS system preferences
├── tests/                   # Test suite
├── Brewfile                 # Core packages
├── Brewfile.dev             # Development tools
├── Brewfile.devops          # DevOps tools
├── chezmoi.toml             # Chezmoi configuration
├── Makefile                 # Automation commands
└── install.sh               # One-line installer
```

---

## Make Commands

```bash
make help              # Show all commands
make install           # Install dotfiles
make update            # Update from repo
make dev-setup         # Set up dev environment
make cloud-setup       # Configure cloud tools
make test              # Test shell startup
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
