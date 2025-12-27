# Security Policy

## Reporting Security Issues

If you discover a security vulnerability in this dotfiles repository, please report it by emailing the repository owner directly. Do not create a public GitHub issue for security vulnerabilities.

## Security Best Practices for Dotfiles

This dotfiles repository follows security best practices:

### What's Included (Safe to Commit)

- Shell configurations (`.zshrc`, `.bashrc`)
- Git configuration (`.gitconfig`) without credentials
- Editor configurations
- Aliases and functions
- Non-sensitive environment variables

### What's Excluded (Never Committed)

The following are explicitly ignored via `.gitignore`:

- SSH private keys (`~/.ssh/id_*`)
- AWS credentials (`~/.aws/credentials`)
- API keys and tokens
- Password files
- `.env` files with secrets
- Kubernetes credentials with tokens
- GPG private keys

### Local Configuration

For machine-specific or sensitive configurations, use:

- `~/.zsh/local.zsh` - Not tracked by git
- `~/.zsh/dev/local.zsh` - Not tracked by git
- Environment variables via secure methods (1Password, aws-vault, etc.)

### Credential Management

Recommended tools for secure credential management:

1. **1Password CLI** - `op` command for secrets
2. **aws-vault** - Secure AWS credential storage
3. **git-credential-manager** - Git credential caching
4. **SOPS** - Encrypted secrets in repos
5. **age** - Modern file encryption

### SSH Key Security

- Use Ed25519 keys: `ssh-keygen -t ed25519`
- Protect with strong passphrase
- Use SSH agent with timeout
- Never commit private keys

### Reviewing Changes

Before committing, always:

1. Run `git diff --cached` to review staged changes
2. Check for accidental secrets with `git secrets --scan`
3. Use pre-commit hooks for automated scanning

## Security Tools Used

This repository uses:

- **pre-commit hooks** - Scan for secrets before commit
- **shellcheck** - Shell script security analysis
- **gitignore** - Comprehensive exclusion patterns

## Dependencies

All dependencies are installed via Homebrew with:

- Pinned versions where security-critical
- Regular updates via `brew upgrade`
- Security audits via `brew audit`
