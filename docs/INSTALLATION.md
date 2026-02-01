# Installation Guide

Complete guide for setting up these dotfiles on a fresh macOS or Linux system.

## Quick Start

```bash
# One-liner installation
curl -fsSL https://raw.githubusercontent.com/thomasvincent/dotfiles/main/install.sh | bash
```

## Prerequisites

### macOS
- macOS 12 (Monterey) or later
- Xcode Command Line Tools: `xcode-select --install`
- Admin access for Homebrew installation

### Linux
- Ubuntu 20.04+, Debian 11+, or Fedora 35+
- `sudo` access for package installation
- `curl` and `git` installed

## Step-by-Step Installation

### 1. Clone the Repository

```bash
git clone https://github.com/thomasvincent/dotfiles.git ~/Developer/github.com/thomasvincent/dotfiles
cd ~/Developer/github.com/thomasvincent/dotfiles
```

### 2. Choose Your Configuration Profile

Copy one of the example configurations:

```bash
# For personal use (full features)
cp chezmoi.toml.personal.example ~/.config/chezmoi/chezmoi.toml

# For work environment (enterprise focused)
cp chezmoi.toml.work.example ~/.config/chezmoi/chezmoi.toml

# For minimal setup (lightweight)
cp chezmoi.toml.minimal.example ~/.config/chezmoi/chezmoi.toml
```

Edit the configuration to customize:
```bash
$EDITOR ~/.config/chezmoi/chezmoi.toml
```

### 3. Run Installation

```bash
# Create backup first
make backup

# Full installation
make install

# Or for development environment
make dev-setup
```

### 4. Verify Installation

```bash
# Run health check
./scripts/health-check.sh

# Or via make
make test
```

## Installation Options

### Minimal Setup

For a lightweight installation with just essential tools:

```bash
# Install only core packages
brew bundle --file=Brewfile.minimal

# Apply minimal chezmoi config
cp chezmoi.toml.minimal.example ~/.config/chezmoi/chezmoi.toml
chezmoi init
chezmoi apply
```

### Development Setup

Full development environment with language support:

```bash
make dev-setup
```

This installs:
- All Brewfile.dev packages
- Language version managers (asdf)
- Development tools

### Cloud/DevOps Setup

For cloud and infrastructure work:

```bash
make cloud-setup
```

This installs:
- AWS, Azure, GCP CLIs
- Terraform, Ansible
- Kubernetes tools

## Make Targets

| Target | Description |
|--------|-------------|
| `make install` | Full installation with chezmoi |
| `make backup` | Create timestamped backup |
| `make update` | Pull and apply updates |
| `make dev-setup` | Development tools setup |
| `make cloud-setup` | Cloud provider tools |
| `make workflow-setup` | Workflow tools (GitHub CLI, tmux) |
| `make productivity-setup` | Task management setup |
| `make brew-install` | Install Homebrew packages |
| `make test` | Run tests |
| `make lint` | Run pre-commit hooks |
| `make clean` | Remove temporary files |

## Post-Installation

### 1. Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 2. Set Up SSH Keys

```bash
# Generate new key
ssh-keygen -t ed25519 -C "your@email.com"

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key
pbcopy < ~/.ssh/id_ed25519.pub
```

### 3. Configure GPG (optional)

```bash
# Generate GPG key
gpg --full-generate-key

# Add to git config
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```

### 4. Start New Shell

```bash
# Restart shell to load all configurations
exec zsh -l
```

## Updating

To update your dotfiles:

```bash
cd ~/Developer/github.com/thomasvincent/dotfiles
make update
```

Or manually:

```bash
git pull
chezmoi apply
```

## Uninstalling

To cleanly remove the dotfiles:

```bash
./scripts/uninstall.sh
```

Use `--dry-run` to preview changes:

```bash
./scripts/uninstall.sh --dry-run
```

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## Directory Structure After Installation

```
~
├── .zsh/                  # Zsh configuration modules
├── .zshrc                 # Main zsh config
├── .zshenv                # Environment variables
├── .zprofile              # Profile config
├── .config/
│   ├── git/               # Git configuration
│   ├── vim/               # Vim configuration
│   ├── tmux/              # Tmux configuration
│   └── ...                # Other tool configs
├── dotfiles -> ...        # Symlink to this repo
└── .local/
    └── bin/               # User scripts
```
