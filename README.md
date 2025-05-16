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
- **Templating System** - Configuration files adapt to different environments
- **Cloud Support** - AWS, Azure, GCP, DigitalOcean, Oracle Cloud, and Linode
- **Kubernetes Tools** - Full Kubernetes workflow with kubectl, helm, and more
- **Security Features** - GPG, SSH agent, YubiKey, and 1Password integration
- **Makefile Automation** - Simple commands for common operations
- **CI/CD Integration** - GitHub Actions and Jenkins pipelines
- **Quality Assurance** - Pre-commit hooks and linting for all files

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

## Using Makefile Commands

After installation, you can use make commands to manage your dotfiles:

```bash
# Show available commands
make help

# Update dotfiles
make update

# Set up development environment
make dev-setup

# Set up cloud tools
make cloud-setup

# Run tests
make test

# Run linters
make lint
```

## Components

- **Templates** - Chezmoi templates for different environments
- **.zsh/** - ZSH configuration modules
- **.config/** - XDG configuration files
- **bin/** - Executable scripts
- **lib/** - Shared functions and utilities
- **.github/** - GitHub configuration (workflows, CODEOWNERS)

## Cloud Provider Support

This dotfiles configuration supports multiple cloud providers:

- **AWS** - AWS CLI, aws-vault, aws-iam-authenticator
- **Azure** - Azure CLI, Azure Terraform tools
- **Google Cloud** - GCP SDK, Terraform validator
- **DigitalOcean** - doctl CLI
- **Oracle Cloud** - OCI CLI
- **Linode** - Linode CLI

Each cloud provider has its own set of functions and aliases configured in `~/.zsh/cloud.zsh`.

## Security Features

Enhanced security features can be enabled in the chezmoi.toml configuration:

```toml
[data.security]
    gpg_signing = true
    use_ssh_agent = true
    use_keychain = true  # macOS only
    use_1password = false
    use_yubikey = false
```

These settings enable/disable various security features such as:

- GPG commit signing
- SSH agent management
- 1Password integration
- YubiKey integration

## Customization

Chezmoi uses a config file to customize dotfiles for different environments:

```toml
# ~/.config/chezmoi/chezmoi.toml
[data]
    name = "Your Name" 
    email = "your.email@example.com"
    github_username = "yourusername"
    
    # Feature toggles
    enable_cloud = true
    enable_containers = true
    enable_kubernetes = true
    
    # Cloud providers to configure
    [data.cloud]
        aws = true
        azure = true
        gcp = true
        digitalocean = true
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

## CI/CD Integration

This repository includes:

- **GitHub Actions** - Automated testing and linting
- **Jenkinsfile** - Jenkins pipeline configuration
- **Pre-commit hooks** - Local code quality checks

## Testing

```bash
# Test shell startup for errors
make test

# Run linters
make lint
```

## Contributing

Please see [CONTRIBUTING.md](.github/CONTRIBUTING.md) for details on how to contribute to this project.

## License

MIT