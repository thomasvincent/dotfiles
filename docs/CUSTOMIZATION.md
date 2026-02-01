# Customization Guide

How to customize these dotfiles for your specific needs.

## Configuration File

The main configuration is in `~/.config/chezmoi/chezmoi.toml`. This file controls which features are enabled and how tools are configured.

## Feature Toggles

### Core Features

```toml
[data]
  # Enable/disable major feature categories
  enable_cloud = true         # Cloud provider tools (AWS, Azure, GCP)
  enable_containers = true    # Docker, container tools
  enable_kubernetes = true    # Kubernetes tools
  enable_dev_tools = true     # Development environment
  enable_editors = true       # Code editors
  enable_extras = false       # Extra/optional apps
  enable_workflows = true     # GitHub, tmux workflows
  enable_productivity = true  # Task management
  minimal = false             # Minimal installation mode
```

### Workflow Modules

```toml
[data]
  # Enable specific workflow modules
  enable_wordpress = true     # WordPress development
  enable_chef = true          # Chef configuration management
  enable_puppet = true        # Puppet configuration management
  enable_gtd = true           # Getting Things Done methodology
  enable_macos_gtd = true     # macOS Notes/Reminders integration
  enable_google_gtd = true    # Google Workspace integration
  enable_microsoft_gtd = true # Microsoft 365 integration
```

### Cloud Providers

```toml
[data]
  # Enable cloud provider tools
  aws = true
  azure = true
  gcp = true
  digitalocean = true
  oracle = false
  linode = false
```

## Personal Preferences

### Editor

```toml
[data]
  editor = "vscode"  # Options: vscode, vim, neovim, emacs
```

This sets `$EDITOR` and installs appropriate plugins.

### Terminal

```toml
[data]
  terminal = "iterm2"  # Options: iterm2, alacritty, kitty, default
```

### Shell Prompt

```toml
[data]
  shell_prompt = "powerlevel10k"  # Options: powerlevel10k, starship, pure
```

### Color Scheme

```toml
[data]
  color_scheme = "dark"  # Options: dark, light, auto
```

## Directory Customization

```toml
[data]
  # Customize default directories
  projects_dir = "$HOME/Projects"      # Project workspace
  task_dir = "$HOME/.tasks"            # Task management
  notes_dir = "$HOME/.notes"           # Notes storage
  gtd_inbox_file = "$HOME/.gtd/inbox.md"  # GTD inbox
  time_track_dir = "$HOME/.timetrack"  # Time tracking
```

## Security Settings

```toml
[data]
  # Security configuration
  gpg_signing = true        # Sign git commits with GPG
  use_ssh_agent = true      # Use SSH agent
  use_keychain = true       # Use macOS keychain
  use_1password = false     # 1Password integration
  use_yubikey = false       # YubiKey support
```

## Adding Local Customizations

### Local Zsh Config

Create `~/.zsh/local.zsh` for machine-specific configurations:

```bash
# ~/.zsh/local.zsh - Not tracked by git

# Machine-specific aliases
alias work="cd ~/Work/mycompany"

# Local environment variables
export MY_LOCAL_VAR="value"

# Override default settings
export EDITOR="nvim"
```

### Local Git Config

Create `~/.gitconfig.local` for private git settings:

```gitconfig
# ~/.gitconfig.local

[user]
    email = work@company.com

[includeIf "gitdir:~/Work/"]
    path = ~/.gitconfig.work
```

## Creating Custom Profiles

### Work Profile

1. Copy the work example:
   ```bash
   cp chezmoi.toml.work.example ~/.config/chezmoi/chezmoi.toml
   ```

2. Customize for your company:
   ```toml
   [data]
     email = "you@company.com"
     enable_microsoft_gtd = true  # If using Microsoft 365
     azure = true                 # If using Azure
     corporate_proxy = "http://proxy.company.com:8080"
   ```

### Personal Profile

1. Copy the personal example:
   ```bash
   cp chezmoi.toml.personal.example ~/.config/chezmoi/chezmoi.toml
   ```

2. Enable all features you want:
   ```toml
   [data]
     email = "personal@email.com"
     enable_extras = true
     use_1password = true
   ```

## Adding New Modules

### Creating a Workflow Module

1. Create a new file in `home/dot_zsh/`:
   ```bash
   touch home/dot_zsh/my_workflow.zsh.tmpl
   ```

2. Add your functions:
   ```zsh
   {{- if .enable_my_workflow }}
   # My Custom Workflow
   # Description: Custom automation functions

   function my_function() {
       echo "Hello from my function"
   }

   alias mf="my_function"
   {{- end }}
   ```

3. Add the toggle to chezmoi.toml:
   ```toml
   [data]
     enable_my_workflow = true
   ```

### Creating a Brewfile Extension

1. Create a new Brewfile:
   ```bash
   touch Brewfile.mytools
   ```

2. Add your packages:
   ```ruby
   # Brewfile.mytools - My custom tools

   brew "my-tool"
   cask "my-app"
   ```

3. Install:
   ```bash
   brew bundle --file=Brewfile.mytools
   ```

## Environment-Specific Configs

### Multiple Machines

Use chezmoi's templating for machine-specific configs:

```zsh
{{- if eq .chezmoi.hostname "work-laptop" }}
# Work laptop specific
export WORK_MODE=true
{{- else if eq .chezmoi.hostname "home-desktop" }}
# Home desktop specific
export GAMING_MODE=true
{{- end }}
```

### OS-Specific Settings

```zsh
{{- if eq .chezmoi.os "darwin" }}
# macOS specific
alias ls="gls --color=auto"
{{- else if eq .chezmoi.os "linux" }}
# Linux specific
alias ls="ls --color=auto"
{{- end }}
```

## Applying Changes

After modifying chezmoi.toml:

```bash
# Preview changes
chezmoi diff

# Apply changes
chezmoi apply -v

# Force re-apply all files
chezmoi apply --force
```

## Testing Customizations

Before committing changes:

```bash
# Run tests
make test

# Lint templates
make lint

# Check specific template
chezmoi execute-template < home/dot_zsh/my_workflow.zsh.tmpl
```
