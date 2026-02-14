# Dotfiles Architecture

## Overview

This is a chezmoi-managed dotfiles repository. It provides declarative configuration for shell environment, development tools, cloud integrations, and workflow automation on macOS and Linux. All deployments are templated and platform-aware.

## Chezmoi Template System

### File Naming Convention

Chezmoi translates source files in `home/` to target files in `$HOME` using prefix and suffix rules:

| Source | Target | Notes |
|--------|--------|-------|
| `dot_zshrc.tmpl` | `~/.zshrc` | `dot_` prefix removed, `.tmpl` processed |
| `dot_zsh/aliases.zsh.tmpl` | `~/.zsh/aliases.zsh` | Nested directories preserved |
| `private_dot_ssh/config.tmpl` | `~/.ssh/config` (mode 0600) | `private_dot_` = restricted permissions |
| `dot_config/git/config` | `~/.config/git/config` | No `.tmpl` = exact copy |

### Template Processing

All `.tmpl` files are processed via Go's `text/template` engine with access to `chezmoi.toml` data:

```
{{ .data.name }}              # Access top-level data keys
{{ .preferences.editor }}     # Access nested toggle values
{{ .chezmoi.os }}            # Built-in OS detection (darwin, linux)
{{ if .enable_cloud }} ... {{ end }}     # Conditional inclusion
{{ if or .security.gpg_signing .security.use_ssh_agent }} ... {{ end }}  # Logical OR
```

### Deployment Flow

```
chezmoi.toml
    ↓
    (data + chezmoi context)
    ↓
home/*.tmpl files
    ↓
chezmoi apply
    ↓
~/.zshrc, ~/.zsh/*, ~/.config/*, etc.
```

## ZSH Module Loading Chain

ZSH loads initialization files in strict order:

```
1. ~/.zshenv    (sourced for ALL shells - login, interactive, non-interactive)
2. ~/.zprofile  (sourced for LOGIN shells only)
3. ~/.zshrc     (sourced for INTERACTIVE shells only)
```

### File Responsibilities

**`dot_zshenv.tmpl`** (executed first, always)
- XDG Base Directory setup (`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, etc.)
- Global PATH configuration
- Platform-specific env vars (Homebrew, browser, locale)
- User identity (NAME, EMAIL, GITHUB_USERNAME)
- Skip global compinit (avoid duplicate completions)

**`dot_zprofile.tmpl`** (login shells)
- EDITOR, VISUAL, PAGER variables
- Language/locale settings
- Homebrew path injection (macOS)
- Additional PATH prepends for `~/bin` and `~/.local/bin`

**`dot_zshrc.tmpl`** (interactive shells)
- Core shell features: aliases, functions, completion, history, keybindings
- Conditional module loading based on toggles
- Instant prompt for Powerlevel10k (if enabled)
- Primary entry point for workflow module sourcing

## Conditional Module Loading System

### Top-Level Toggles (Feature Flags)

Boolean flags in `chezmoi.toml` [data] section control entire feature categories:

```toml
enable_cloud = true        # AWS, Azure, GCP, DigitalOcean, Oracle
enable_containers = true   # Docker, Kubernetes tools
enable_kubernetes = true   # K8s-specific tools
enable_dev_tools = true    # Development environments (languages, runtimes)
enable_editors = true      # Code editors (VS Code, vim, neovim)
enable_extras = false      # Extra applications (off by default)
enable_workflows = true    # Workflow automation (tmux, git helpers)
enable_productivity = true # Task management, notes, time tracking
enable_gtd = true         # GTD workflows
enable_macos_gtd = true   # macOS-native GTD (Notes.app, Reminders.app)
enable_google_gtd = true  # Google Workspace GTD
enable_microsoft_gtd = true # Microsoft 365 GTD
```

### Nested Toggles (Preferences)

Fine-grained toggles in `chezmoi.toml` [data.preferences] and [data.security]:

```toml
[data.preferences]
    enable_rails = true
    enable_ansible = true
    enable_java = true
    enable_groovy = true
    enable_rust = true
    enable_ruby = true
    enable_vscode = true
    enable_github = true
    enable_omnifocus = true

[data.security]
    gpg_signing = true
    use_ssh_agent = true
    use_keychain = true      # macOS only
    use_1password = false
    use_yubikey = false
```

### Module Sourcing Logic

In `dot_zshrc.tmpl`, each optional module is guarded by conditional logic:

```zsh
# Single toggle
{{- if .enable_cloud }}
source "$HOME/.zsh/cloud.zsh"
{{- end }}

# Multiple toggles (OR logic)
{{- if or .preferences.enable_ansible .enable_dev_tools }}
source "$HOME/.zsh/ansible_workflows.zsh"
{{- end }}

# Complex condition
{{- if .security.gpg_signing | or .security.use_ssh_agent | or .security.use_keychain }}
source "$HOME/.zsh/security.zsh"
{{- end }}
```

This ensures only enabled modules are sourced, reducing startup overhead.

## Module Inventory

Modules are stored in `home/dot_zsh/` as `.zsh.tmpl` files. Each module is conditionally sourced by `dot_zshrc.tmpl`:

| Module | Toggle(s) | Purpose |
|--------|-----------|---------|
| `aliases.zsh.tmpl` | always | Common shell aliases |
| `functions.zsh.tmpl` | always | Utility functions |
| `completion.zsh.tmpl` | always | ZSH completion setup |
| `history.zsh.tmpl` | always | History config |
| `keybindings.zsh.tmpl` | always | ZSH keybindings |
| `cloud.zsh.tmpl` | `enable_cloud` | AWS/Azure/GCP/DO/Oracle CLI |
| `security.zsh.tmpl` | any security toggle | GPG, SSH agent, keychain setup |
| `workflows.zsh.tmpl` | `enable_workflows` | Workflow automation (git, tmux) |
| `productivity.zsh.tmpl` | `enable_productivity` | Task mgmt, notes, time tracking |
| `cicd.zsh.tmpl` | `enable_workflows` OR `enable_dev_tools` | CI/CD helpers |
| `dev_workflows.zsh.tmpl` | `enable_dev_tools` | Dev environment setup |
| `app_workflows.zsh.tmpl` | `enable_productivity` | App integrations |
| `ansible_workflows.zsh.tmpl` | `preferences.enable_ansible` OR `enable_dev_tools` | Ansible helpers |
| `java_gradle_workflows.zsh.tmpl` | `preferences.enable_java` OR `enable_dev_tools` | Java/Gradle |
| `groovy_workflows.zsh.tmpl` | `preferences.enable_groovy` OR `enable_dev_tools` | Groovy |
| `rails_workflows.zsh.tmpl` | `preferences.enable_rails` OR `enable_dev_tools` | Rails |
| `rust_workflows.zsh.tmpl` | `preferences.enable_rust` OR `enable_dev_tools` | Rust |
| `ruby_workflows.zsh.tmpl` | `preferences.enable_ruby` OR `enable_dev_tools` | Ruby |
| `hashicorp_workflows.zsh.tmpl` | `preferences.enable_hashicorp` OR `enable_dev_tools` | Terraform, Vault, Consul |
| `github_workflows.zsh.tmpl` | `preferences.enable_github` OR `enable_dev_tools` | GitHub CLI helpers |
| `vscode_workflows.zsh.tmpl` | `preferences.enable_vscode` OR `enable_editors` | VS Code integration |
| `omnifocus_workflows.zsh.tmpl` | `preferences.enable_omnifocus` OR `enable_productivity` | OmniFocus (macOS) |
| `macos_gtd_workflows.zsh.tmpl` | `enable_macos_gtd` | macOS Notes/Reminders GTD |
| `google_gtd_workflows.zsh.tmpl` | `enable_google_gtd` | Google Tasks/Workspace GTD |
| `microsoft_gtd_workflows.zsh.tmpl` | `enable_microsoft_gtd` | Microsoft 365 GTD |

## Data Flow Diagram

```
┌──────────────────────────────────────────────────────────────┐
│ chezmoi.toml                                                 │
│ - [data] top-level toggles (enable_cloud, enable_dev_tools) │
│ - [data.preferences] nested toggles (enable_rails, etc.)     │
│ - [data.security] security toggles (gpg_signing, etc.)       │
└──────────────────┬───────────────────────────────────────────┘
                   │
        chezmoi init + apply
                   │
                   ↓
┌──────────────────────────────────────────────────────────────┐
│ Template Processing (Go text/template)                       │
│ - Evaluate {{ if }} guards                                   │
│ - Interpolate {{ .data.* }} values                           │
│ - Apply platform conditionals {{ if eq .chezmoi.os "darwin" }}
└──────────────────┬───────────────────────────────────────────┘
                   │
                   ↓
┌──────────────────────────────────────────────────────────────┐
│ home/ → $HOME                                                │
│                                                              │
│ dot_zshenv.tmpl    →  ~/.zshenv                             │
│ dot_zprofile.tmpl  →  ~/.zprofile                           │
│ dot_zshrc.tmpl     →  ~/.zshrc                              │
│ dot_zsh/*.tmpl     →  ~/.zsh/*.zsh                          │
│ dot_config/*       →  ~/.config/*                           │
│ dot_vscode/*       →  ~/.vscode/*                           │
└──────────────────┬───────────────────────────────────────────┘
                   │
        When shell starts
                   │
                   ↓
┌──────────────────────────────────────────────────────────────┐
│ Shell Initialization (every session)                         │
│                                                              │
│ 1. ~/.zshenv (all shells)                                   │
│    - Sets XDG vars, PATH, identity                          │
│                                                              │
│ 2. ~/.zprofile (login shells)                               │
│    - Sets EDITOR, locale, Homebrew path                     │
│                                                              │
│ 3. ~/.zshrc (interactive shells)                            │
│    - Loads core modules (always)                            │
│    - Conditionally sources ~/.zsh/*.zsh (based on toggles)  │
│                                                              │
│ Result: only enabled workflows + dev tools are in memory    │
└──────────────────────────────────────────────────────────────┘
```

## Platform Support

### macOS vs Linux Detection

Platform-specific configurations are controlled via:

1. **chezmoi.toml toggles** (`macos = true`, `linux = false`)
2. **Template guards** in `.tmpl` files:
   ```zsh
   {{ if eq .chezmoi.os "darwin" }}
     # macOS-only code
   {{ else if eq .chezmoi.os "linux" }}
     # Linux-only code
   {{ end }}
   ```
3. **`.chezmoiignore` rules** to skip platform-specific files:
   ```
   {{ if ne .chezmoi.os "darwin" }}
   .zsh/macos_gtd_workflows.zsh
   .zsh/omnifocus_workflows.zsh
   .zsh/app_workflows.zsh
   .zsh/vscode_workflows.zsh
   {{ end }}
   ```

### macOS-Specific Features

- Homebrew integration (path injection, analytics disabled)
- macOS Notes.app and Reminders.app workflows (GTD, task mgmt)
- OmniFocus integration
- Terminal.app / iTerm2 / Alacritty / Kitty support
- VS Code integration
- Apple's `open` command for browser launching
- Keychain support for SSH/GPG agents

### Linux-Specific Features

- Package managers: apt, yum, dnf, pacman
- XDG-compliant directory layout
- xdg-open for browser launching
- libnotify for notifications

## Script Ecosystem

Scripts in `scripts/` provide automated maintenance tasks:

| Script | Purpose |
|--------|---------|
| `install.sh` | Wrapper around Makefile; autodetects OS; prompts for confirmation |
| `backup-dotfiles.sh` | Backs up existing `~/.zshrc`, `~/.zprofile`, config files |
| `uninstall.sh` | Removes chezmoi and restores from backup |
| `health-check.sh` | Validates shell startup, detects missing tools |
| `generate-docs.sh` | Extracts function/command docs from workflow modules |
| `generate-sbom.sh` | Creates CycloneDX + SPDX bills of materials |
| `macos-defaults.sh` | Applies macOS system defaults (Dock, Finder, keyboard) |
| `update-homebrew.sh` | Updates Homebrew and installed packages |

## Makefile Targets

| Target | Purpose |
|--------|---------|
| `make install` | Install chezmoi (if needed) and apply dotfiles |
| `make update` | Run `chezmoi update` |
| `make backup` | Back up current dotfiles before installation |
| `make dev-setup` | Install dev tools (languages, runtimes via asdf) |
| `make cloud-setup` | Install cloud CLIs (AWS, Azure, GCP, etc.) |
| `make workflow-setup` | Install workflow tools (tmux, GitHub CLI) |
| `make productivity-setup` | Create task/notes/timetrack directories |
| `make brew-install` | Install Homebrew and packages from Brewfile |
| `make test` | Run shell startup test; detect errors |
| `make lint` | Run shellcheck, yamllint, pre-commit |
| `make sbom` | Generate SBOM files |
| `make clean` | Remove temp files, clear ZSH cache |
| `make help` | List available targets |

## Installation Flow

```
$ ./install.sh
  ↓
  Detect OS (macOS / Linux)
  ↓
  Check for 'make' (install if missing)
  ↓
  Confirm with user
  ↓
  make backup          (save existing dotfiles)
  ↓
  make brew-install    (Homebrew + packages)
  ↓
  make install         (chezmoi init + apply)
  ↓
  make dev-setup       (languages, runtimes)
  ↓
  make cloud-setup     (cloud CLIs)
  ↓
  make functions       (generate function docs)
  ↓
  "Installation complete! Run 'exec zsh' to reload."
```

## Configuration Example

To customize your setup, edit `chezmoi.toml` before running `chezmoi apply`:

```toml
[data]
    name = "Your Name"
    email = "you@example.com"
    github_username = "yourname"
    enable_cloud = true
    enable_dev_tools = true
    enable_kubernetes = false      # Skip K8s tools
    enable_extras = true           # Add extra apps

    [data.preferences]
        editor = "vscode"
        enable_rails = true
        enable_rust = false        # Skip Rust workflows
        enable_ansible = true

    [data.security]
        gpg_signing = true
        use_keychain = true
        use_1password = false
```

Then run:

```bash
chezmoi apply
# or if you have local changes:
chezmoi diff          # review changes
chezmoi apply --force # apply with overwrite
```

## Maintenance

- **Add a new workflow?** Create `home/dot_zsh/newfeature_workflows.zsh.tmpl`, add a toggle to `chezmoi.toml`, guard the source line in `dot_zshrc.tmpl`.
- **Update cloud provider tools?** Edit `Brewfile.cloud.tmpl` (macOS) or `dev-setup` target in Makefile (Linux).
- **Modify shell startup?** Edit `.zshenv`, `.zprofile`, or `.zshrc` template files directly; `make test` validates syntax.
- **Check what changed?** Run `chezmoi diff` before applying.
- **Restore from backup?** Backups are timestamped in `~/dotfiles_backup_YYYYMMDD_HHMMSS/`.

---

**Last Updated:** 2026-02-14  
**Maintained by:** chezmoi  
**Repository:** https://github.com/thomasvincent/dotfiles-enhance
