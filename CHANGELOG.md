# Changelog

All notable changes to this dotfiles repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

#### DevOps Modules
- **terraform.zsh** - Comprehensive Terraform workflows
  - `tf-project` - Scaffold new Terraform projects with best-practice structure
  - `tf-module` - Create reusable Terraform modules
  - `tf-check` - Run validation, tflint, tfsec, and checkov
  - `tf-cost` - Estimate costs with Infracost
  - `tf-destroy-safe` - Double confirmation for destroy operations
  - Environment-aware plan/apply functions

- **kubernetes.zsh** - Kubernetes and Helm tooling
  - Extensive kubectl aliases (40+)
  - Helm aliases for chart management
  - `kexec`, `klogs`, `kdesc` - Fuzzy pod selection
  - `kctx-switch`, `kns-switch` - Interactive context/namespace switching
  - `kdebug` - Launch debug containers
  - `ksec-view` - Decode and view secrets
  - `krestart` - Restart deployments with status

- **aws.zsh** - AWS CLI workflows
  - Profile management with fuzzy selection
  - SSO authentication helpers
  - `ec2-ssm` - Interactive SSM session
  - `eks-config` - Update kubeconfig for EKS
  - `cw-logs`, `lambda-logs` - CloudWatch log tailing
  - `aws-cost` - Cost explorer summary

- **argocd.zsh** - ArgoCD GitOps workflows
  - Application management aliases
  - `argo-sync-select` - Fuzzy app selection
  - `argo-dashboard` - Summary view
  - `argo-rollback` - Interactive rollback
  - `argo-out-of-sync`, `argo-unhealthy` - Problem detection

- **docker.zsh** - Docker and container management
  - Container lifecycle aliases
  - `docker-shell` - Interactive container selection
  - `docker-clean` - Full cleanup with confirmation
  - `docker-run-here` - Run with current directory mounted

- **network.zsh** - Network debugging and API utilities
  - `myip` - Internal and external IP addresses
  - `http-headers`, `http-status`, `http-time` - HTTP debugging
  - `api-get`, `api-post`, `api-put`, `api-delete` - API testing
  - `ssl-check`, `ssl-expiry` - Certificate inspection
  - `dns-lookup`, `flush-dns` - DNS utilities
  - `jwt-decode` - JWT token decoding

- **git-extras.zsh** - Advanced Git workflows
  - `git-branch-clean` - Delete merged branches
  - Conventional commit helpers (`gcf`, `gcx`, `gci`)
  - `git-pr-create`, `git-pr-checkout` - PR workflows
  - `git-stats`, `git-standup`, `git-fame` - Repository statistics
  - `git-sync`, `git-undo`, `git-amend` - Workflow helpers

#### Documentation
- **docs/INSTALLATION.md** - Comprehensive installation guide
- **docs/DEVOPS.md** - Complete DevOps tools reference
- **docs/WORKFLOWS.md** - Development workflow documentation
- **docs/GTD.md** - Getting Things Done integration guide
- **docs/CUSTOMIZATION.md** - Personalization guide
- **SECURITY.md** - Security policy and best practices

#### Scripts
- **scripts/macos-defaults.sh** - macOS system preferences for developers
- **scripts/backup-dotfiles.sh** - Backup script with rotation
- **scripts/health-check.sh** - Verify all tools are installed

#### Configuration Templates
- **.ssh/config.example** - Secure SSH configuration
- **.config/starship.toml.example** - Starship prompt configuration
- **.tmux.conf.example** - Tmux configuration
- **.zsh/dev/local.zsh.example** - Machine-specific settings template

#### GitHub Integration
- **.github/CONTRIBUTING.md** - Contribution guidelines
- **.github/ISSUE_TEMPLATE/bug_report.md** - Bug report template
- **.github/ISSUE_TEMPLATE/feature_request.md** - Feature request template
- **.github/PULL_REQUEST_TEMPLATE.md** - PR template

#### Quality Assurance
- **.pre-commit-config.yaml** - Pre-commit hooks with secret detection
- **.yamllint.yml** - YAML linting configuration
- **Brewfile.devops** - Comprehensive DevOps tool list

### Changed

- **README.md** - Streamlined with badges, linking to detailed docs
- **.zshrc** - Fixed hardcoded paths, removed duplicate bashcompinit calls
- **.github/workflows/ci.yml** - Enhanced with comprehensive comments
- **.gitignore** - Organized with section headers and comments
- **.zsh/aliases.zsh** - Complete rewrite with 10 organized sections
- **.zsh/dev/index.zsh** - Enhanced module loading with documentation

### Fixed

- Hardcoded `/Users/thomasvincent/dotfiles` path in .zshrc
- Duplicate `bashcompinit` calls causing slow startup
- FZF path detection for Apple Silicon Macs
- Missing pyenv existence check

### Moved

- Test files from root to `tests/` directory

## [1.0.0] - Initial Release

### Added

- Initial dotfiles structure
- Zsh configuration with Powerlevel10k
- Chezmoi management
- Core aliases and functions
- Homebrew Brewfiles
- CI/CD with GitHub Actions
