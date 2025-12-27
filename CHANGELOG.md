# Changelog

All notable changes to this dotfiles repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Terraform module** (`.zsh/dev/terraform.zsh`)
  - Complete alias set for terraform commands (`tf`, `tfi`, `tfp`, `tfa`, etc.)
  - `tf-init-backend` - Initialize with environment-specific backend configs
  - `tf-plan-env` / `tf-apply-env` - Environment-aware plan/apply
  - `tf-project` - Create new Terraform project structure
  - `tf-module` - Create new Terraform module
  - `tf-docs` - Generate terraform-docs documentation
  - `tf-check` - Run validation, tflint, tfsec, and checkov
  - `tf-cost` - Infracost integration for cost estimation
  - `tf-export` - Export outputs to environment variables
  - `tf-destroy-safe` - Double confirmation for destroy operations

- **Kubernetes module** (`.zsh/dev/kubernetes.zsh`)
  - Comprehensive kubectl aliases (`k`, `kg`, `kgp`, `kd`, `kl`, etc.)
  - Helm aliases (`h`, `hi`, `hu`, `hui`, `hl`, etc.)
  - `kctx-switch` / `kns-switch` - Fuzzy context/namespace switching
  - `kpod` / `kexec` / `klogs` - Fuzzy pod selection
  - `kwatch` - Watch pods in real-time
  - `kall` - List all resources in namespace
  - `kdebug` - Launch debug container
  - `kres` - Show resource usage
  - `krestart` - Restart deployment with status
  - `kns-create` - Create namespace with resource quota
  - `ksec-view` - Decode and view secrets

- **AWS module** (`.zsh/dev/aws.zsh`)
  - Comprehensive AWS CLI aliases for EC2, S3, ECS, EKS, Lambda, RDS, IAM, etc.
  - `aws-profiles` / `aws-profile` - Profile management with fuzzy selection
  - `aws-sso-login` - SSO authentication helper
  - `ec2-by-name` - Find EC2 instances by name tag
  - `ec2-ssm` - SSM session with instance selection
  - `s3-size` - Get bucket size
  - `cw-logs` - Tail CloudWatch logs
  - `eks-config` - Update kubeconfig for EKS clusters
  - `lambda-logs` - Tail Lambda function logs
  - `aws-resources` - List all resources in region
  - `aws-cost` - Cost explorer summary
  - AWS Vault aliases if installed

- **ArgoCD module** (`.zsh/dev/argocd.zsh`)
  - Full ArgoCD CLI aliases
  - `argo-login` - Login helper
  - `argo-init-password` - Get initial admin password
  - `argo-port-forward` - Port forward to ArgoCD server
  - `argo-sync-select` / `argo-status` - Fuzzy app selection
  - `argo-watch` - Watch application status
  - `argo-create-app` - Create application from Git repo
  - `argo-rollback` - Rollback with history display
  - `argo-out-of-sync` / `argo-unhealthy` - List problem apps
  - `argo-dashboard` - Summary of all apps/clusters/repos

- **Enhanced dev/index.zsh**
  - `devops-status` - Quick verification of all DevOps tools
  - Added terraform to `init-project` types
  - Added k8s/terraform environments to `dev-env`
  - Expanded `docs` function with DevOps documentation links

### Fixed
- **`.zshrc` cleanup**
  - Removed hardcoded `/Users/thomasvincent/dotfiles` path - now uses `$ZSH_CONFIG_DIR`
  - Removed duplicate `bashcompinit` calls (was called 3 times)
  - Consolidated Terraform completion setup
  - Added pyenv existence check before initialization
  - Fixed FZF path detection for both Intel and Apple Silicon Macs
  - Moved machine-specific aliases to `local.zsh`

### Changed
- Improved module loading order in `dev/index.zsh`
- Better organization of container/orchestration tool loading

## [1.0.0] - 2025-04-21

### Added
- Initial dotfiles setup with chezmoi
- ZSH configuration with Powerlevel10k
- Modular configuration structure
- Homebrew package management with Brewfiles
- Pre-commit hooks for code quality
- GitHub Actions CI/CD
- Comprehensive documentation
