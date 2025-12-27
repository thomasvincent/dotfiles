# Customization Guide

> How to personalize these dotfiles for your workflow.

---

## Configuration File

The main configuration is in `~/.config/chezmoi/chezmoi.toml`:

```toml
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
        azure = false
        gcp = true
        digitalocean = false

    # Security features
    [data.security]
        gpg_signing = true
        use_ssh_agent = true
        use_keychain = true      # macOS only
        use_1password = false
        use_yubikey = false

    # GTD preferences
    [data.preferences]
        notes_folder = "CLI Notes"
        meeting_folder = "Meetings"
        reminders_list = "CLI Tools"
```

---

## Local Customizations

### Machine-Specific Settings

Create `~/.zsh/local.zsh` for settings that shouldn't be committed:

```bash
# Copy the example file
cp ~/.zsh/dev/local.zsh.example ~/.zsh/local.zsh

# Edit with your customizations
vim ~/.zsh/local.zsh
```

**Example `local.zsh`:**

```bash
#!/usr/bin/env zsh
# Machine-specific configuration

# Custom aliases
alias work="cd ~/Projects/work && code ."
alias myproject="cd ~/Projects/my-project"

# AWS defaults for this machine
export AWS_DEFAULT_REGION="us-east-1"
export AWS_PROFILE="work-account"

# Kubernetes defaults
export KUBECONFIG="$HOME/.kube/config:$HOME/.kube/work-config"

# Project shortcuts
work() { cd ~/Projects/work && code . }
personal() { cd ~/Projects/personal && code . }

# Company-specific tools
source ~/company-scripts/init.zsh
```

---

## Adding Custom Aliases

### Option 1: local.zsh (Recommended)

Add to `~/.zsh/local.zsh` - not tracked by git.

### Option 2: aliases.zsh

Edit `~/.zsh/aliases.zsh` and commit your changes.

### Option 3: Create a new module

Create `~/.zsh/dev/mytools.zsh` and add to `index.zsh`.

---

## Customizing Prompt

### Powerlevel10k

Run the configuration wizard:

```bash
p10k configure
```

Or edit directly:

```bash
vim ~/.p10k.zsh
```

### Common Customizations

**Show AWS profile in prompt:**

In `~/.p10k.zsh`, find `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS` and add:

```bash
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=( aws )
```

**Show Kubernetes context:**

```bash
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=( kubecontext )
```

---

## Adding New Tools

### 1. Create Module File

```bash
vim ~/.zsh/dev/mytool.zsh
```

**Template:**

```bash
#!/usr/bin/env zsh
# ~/.zsh/dev/mytool.zsh - My Tool configuration
#
# Description: What this module does
# Dependencies: List any required tools
#

# ====================================
# ALIASES
# ====================================
if command -v mytool &>/dev/null; then
  alias mt='mytool'
  alias mtls='mytool list'
fi

# ====================================
# FUNCTIONS
# ====================================

# Description of what this does
my-function() {
  local arg="$1"
  
  if [[ -z "$arg" ]]; then
    echo "Usage: my-function <argument>"
    return 1
  fi
  
  mytool do-something "$arg"
}
```

### 2. Add to Index

Edit `~/.zsh/dev/index.zsh`:

```bash
source_if_exists "$DEV_MODULE_DIR/mytool.zsh"
```

### 3. Reload

```bash
source ~/.zshrc
# Or just: sz
```

---

## Brewfile Customization

### Add Packages

Edit `~/dotfiles/Brewfile`:

```ruby
# My custom additions
brew "my-favorite-tool"
cask "my-app"
```

### Machine-Specific Packages

Create `~/dotfiles/Brewfile.local` (not committed):

```ruby
# Work-specific tools
brew "work-cli"
cask "work-app"
```

Install with:

```bash
brew bundle install --file=~/dotfiles/Brewfile.local
```

---

## Git Configuration

### Global Config

Edit `~/.gitconfig`:

```ini
[user]
    name = Your Name
    email = your.email@example.com
    signingkey = YOUR_GPG_KEY

[commit]
    gpgsign = true

[alias]
    co = checkout
    br = branch
    ci = commit
    st = status
```

### Per-Directory Config

Create `~/Projects/work/.gitconfig`:

```ini
[user]
    email = work.email@company.com
```

Then in `~/.gitconfig`:

```ini
[includeIf "gitdir:~/Projects/work/"]
    path = ~/Projects/work/.gitconfig
```

---

## Environment Variables

### Persistent Variables

Add to `~/.zsh/env.zsh` or `~/.zsh/local.zsh`:

```bash
export MY_VAR="value"
```

### Sensitive Variables

Use a secrets manager or add to `~/.zsh/local.zsh` (not committed):

```bash
export API_KEY="secret-key"
export DATABASE_URL="postgres://..."
```

### Per-Project Variables

Use `direnv` with `.envrc` files:

```bash
# In project directory
echo 'export PROJECT_ENV=development' > .envrc
direnv allow
```

---

## Syncing Across Machines

### Initial Setup on New Machine

```bash
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thomasvincent
```

### Pull Updates

```bash
chezmoi update
```

### Push Local Changes

```bash
# Add modified file to chezmoi
chezmoi add ~/.zshrc

# Commit and push
cd ~/.local/share/chezmoi
git add -A
git commit -m "Update zshrc"
git push
```
