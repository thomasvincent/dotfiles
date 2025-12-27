# Dotfiles

[![CI](https://github.com/thomasvincent/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/thomasvincent/dotfiles/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Made with Chezmoi](https://img.shields.io/badge/Made%20with-Chezmoi-blue)](https://www.chezmoi.io/)
[![Shell: Zsh](https://img.shields.io/badge/Shell-Zsh-green)](https://www.zsh.org/)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey)]()

> 🚀 Production-ready dotfiles for DevOps engineers, optimized for macOS with Terraform, Kubernetes, AWS, and GitOps workflows.

---

## ✨ Features

| Category | Highlights |
|----------|------------|
| **DevOps Tooling** | Terraform, Kubernetes, Helm, ArgoCD, AWS CLI |
| **Shell** | Zsh + Powerlevel10k with <500ms startup |
| **Package Management** | Homebrew with organized Brewfiles |
| **Productivity** | GTD workflows, task management, note-taking |
| **Security** | GPG signing, SSH agent, 1Password integration |
| **CI/CD** | GitHub Actions, Jenkins pipelines |

---

## 📦 Quick Install

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/thomasvincent/dotfiles/main/install.sh)"
```

Or with chezmoi directly:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thomasvincent
```

📖 **[Full Installation Guide](docs/INSTALLATION.md)**

---

## 🛠️ DevOps Highlights

### Terraform

```bash
tf-project myinfra aws    # Scaffold new project
tf-check                   # Run tflint + tfsec + checkov
tf-cost prod               # Estimate costs with Infracost
```

### Kubernetes

```bash
kexec                      # Fuzzy pod selection → exec
klogs                      # Fuzzy pod selection → logs  
ksec-view                  # Decode and view secrets
devops-status              # Check all tool status
```

### AWS

```bash
aws-profile                # Fuzzy profile switching
ec2-ssm                    # SSM into instance
eks-config                 # Update kubeconfig for cluster
```

📖 **[Complete DevOps Reference](docs/DEVOPS.md)**

---

## 📁 Structure

```
dotfiles/
├── .zsh/                    # Zsh configuration modules
│   ├── dev/                 # Developer tool configs
│   │   ├── terraform.zsh    # Terraform workflows
│   │   ├── kubernetes.zsh   # K8s + Helm aliases
│   │   ├── aws.zsh          # AWS CLI shortcuts
│   │   ├── argocd.zsh       # GitOps workflows
│   │   └── ...              # More tool modules
│   ├── aliases.zsh          # Shell aliases
│   ├── completions.zsh      # Tab completions
│   └── ...                  # More modules
├── docs/                    # Documentation
│   ├── INSTALLATION.md      # Setup guide
│   ├── DEVOPS.md            # DevOps reference
│   ├── WORKFLOWS.md         # Dev workflows
│   ├── GTD.md               # GTD integration
│   └── CUSTOMIZATION.md     # Personalization
├── tests/                   # Test suite
├── Brewfile                 # Core packages
├── Brewfile.dev             # Dev tools
├── Makefile                 # Automation commands
└── install.sh               # One-line installer
```

---

## 🎯 Make Commands

```bash
make help              # Show all commands
make install           # Install dotfiles
make update            # Update from repo
make dev-setup         # Set up dev environment
make cloud-setup       # Configure cloud tools
make test              # Test shell startup
make lint              # Run linters
```

---

## 📚 Documentation

| Guide | Description |
|-------|-------------|
| [📥 Installation](docs/INSTALLATION.md) | Setup and configuration |
| [🛠️ DevOps Tools](docs/DEVOPS.md) | Terraform, K8s, AWS, ArgoCD |
| [⚙️ Workflows](docs/WORKFLOWS.md) | Development workflows |
| [📝 GTD](docs/GTD.md) | Getting Things Done integration |
| [🎨 Customization](docs/CUSTOMIZATION.md) | Personalization guide |
| [🗓️ Changelog](CHANGELOG.md) | Version history |

---

## 🔧 Customization

Machine-specific settings go in `~/.zsh/local.zsh` (not committed):

```bash
# Copy the example
cp ~/.zsh/dev/local.zsh.example ~/.zsh/local.zsh

# Add your customizations
vim ~/.zsh/local.zsh
```

📖 **[Full Customization Guide](docs/CUSTOMIZATION.md)**

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Run `make lint` before committing
4. Submit a pull request

See [CONTRIBUTING.md](.github/CONTRIBUTING.md) for details.

---

## 📄 License

[MIT](LICENSE) © Thomas Vincent
