# Chezmoi Variables Reference

Complete reference of all variables in `chezmoi.toml` and their usage across template files.

## Top-Level Variables

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `name` | string | "Thomas Vincent" | git config, commits | User's full name |
| `email` | string | "thomas@email.com" | git config, GPG | User's email address |
| `github_username` | string | "thomasvincent" | GitHub workflows, git config | GitHub username for API calls and git remotes |
| `minimal` | bool | false | All conditional blocks | Minimal installation mode; disables heavy integrations |
| `macos` | bool | true | All macOS-specific blocks | Enable macOS-specific functionality |
| `linux` | bool | false | Linux-specific blocks | Enable Linux-specific functionality |
| `work` | bool | false | Work-related configuration | Enable work-specific setup |
| `work_username` | string | "" | Work configuration | Work account username |
| `work_email` | string | "" | Work configuration | Work account email |

## Feature Toggle Variables

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `enable_cloud` | bool | true | `cloud.zsh` | Enable cloud provider tools (AWS, Azure, GCP, DigitalOcean, Oracle) |
| `enable_containers` | bool | true | Container tools (Docker, Kubernetes) | Enable container and Kubernetes tools |
| `enable_kubernetes` | bool | true | Kubernetes workflows | Enable Kubernetes-specific aliases and functions |
| `enable_dev_tools` | bool | true | `cicd.zsh`, `dev_workflows.zsh`, language modules | Enable development tool integrations |
| `enable_editors` | bool | true | `vscode_workflows.zsh` | Enable code editor integrations |
| `enable_extras` | bool | false | Extra applications | Enable extra/experimental applications |
| `enable_workflows` | bool | true | `workflows.zsh`, `cicd.zsh` | Enable project and automation workflows |
| `enable_productivity` | bool | true | `productivity.zsh`, `app_workflows.zsh`, `omnifocus_workflows.zsh` | Enable productivity tools and integrations |

## GTD Toggle Variables

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `enable_gtd` | bool | true | macOS/Google/Microsoft GTD modules | Master toggle for all GTD workflows |
| `enable_macos_gtd` | bool | true | `macos_gtd_workflows.zsh` | Enable native macOS GTD (Notes/Reminders) |
| `enable_google_gtd` | bool | true | `google_gtd_workflows.zsh` | Enable Google Workspace GTD (Drive/Calendar/Tasks) |
| `enable_microsoft_gtd` | bool | true | `microsoft_gtd_workflows.zsh` | Enable Microsoft 365 GTD (ToDo/Outlook/OneNote) |

## Preferences Variables

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `preferences.editor` | string | "vscode" | `.zshrc` (EDITOR env var), editor modules | Default editor (vscode, vim, neovim, emacs) |
| `preferences.terminal` | string | "iterm2" | Terminal configuration | Terminal app preference (iterm2, alacritty, kitty, terminal) |
| `preferences.shell_prompt` | string | "powerlevel10k" | Prompt setup | Shell prompt theme (powerlevel10k, starship, pure) |
| `preferences.color_scheme` | string | "dark" | Theme configuration | Color scheme (dark, light, auto) |
| `preferences.projects_dir` | string | "$HOME/Projects" | All workflow modules (`new-project`, `wp-init`, `*-init-project`) | Base directory for all development projects |

## Productivity & Tasks Preferences

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `preferences.task_dir` | string | "$HOME/.tasks" | `productivity.zsh` | Directory for task management files |
| `preferences.notes_dir` | string | "$HOME/.notes" | Note management workflows | Directory for notes |
| `preferences.meeting_dir` | string | "$HOME/.notes/meetings" | Meeting note workflows | Directory for meeting notes |
| `preferences.time_track_dir` | string | "$HOME/.timetrack" | Time tracking workflows | Directory for time tracking logs |

## macOS Integration Preferences

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `preferences.notes_folder` | string | "CLI Notes" | `productivity.zsh`, `app_workflows.zsh` | Default folder name in macOS Notes app |
| `preferences.meeting_folder` | string | "Meetings" | Meeting workflows | Default folder name for meetings in macOS Notes |
| `preferences.reminders_list` | string | "CLI Tools" | `productivity.zsh`, `macos_gtd_workflows.zsh` | Default list name in macOS Reminders app |

## GTD Workflow Preferences

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `preferences.gtd_inbox_folder` | string | "GTD/Inbox" | `app_workflows.zsh`, `macos_gtd_workflows.zsh` | Folder for GTD inbox in Notes app |
| `preferences.gtd_inbox_file` | string | "$HOME/.gtd/inbox.md" | GTD workflow functions | File for GTD inbox items (local backup) |
| `preferences.gtd_templates_dir` | string | "$HOME/.gtd/templates" | GTD template functions | Directory for GTD templates |
| `preferences.gtd_projects_folder` | string | "GTD/Projects" | `macos_gtd_workflows.zsh` | Folder for GTD projects in Notes app |
| `preferences.gtd_projects_dir` | string | "$HOME/.gtd/projects" | GTD project functions | Directory for GTD project files |
| `preferences.gtd_next_actions_file` | string | "$HOME/.gtd/next-actions.md" | GTD workflow functions | File for next actions list |

## Google GTD Preferences

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `preferences.google_credentials_path` | string | "$HOME/.config/google/credentials.json" | `google_gtd_workflows.zsh` | Path to Google service account credentials (for API automation) |
| `preferences.google_auth_token_path` | string | "$HOME/.config/google/token.json" | `google_gtd_workflows.zsh` | Path to Google OAuth token for authentication |
| `preferences.google_gtd_drive_folder` | string | "GTD System" | `google_gtd_workflows.zsh` | Root folder name for GTD in Google Drive |

## Microsoft GTD Preferences

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `preferences.sharepoint_url` | string | "https://your-tenant.sharepoint.com" | `microsoft_gtd_workflows.zsh` | SharePoint tenant URL for Microsoft GTD |
| `preferences.ms_gtd_folder` | string | "GTD System" | `microsoft_gtd_workflows.zsh` | Root folder name for GTD in OneDrive/SharePoint |

## Development Workflow Preferences

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `preferences.enable_wordpress` | bool | true | `dev_workflows.zsh` | Enable WordPress development workflows |
| `preferences.enable_chef` | bool | true | `dev_workflows.zsh` | Enable Chef development workflows |
| `preferences.enable_puppet` | bool | true | `dev_workflows.zsh` | Enable Puppet development workflows |
| `preferences.enable_ansible` | bool | true | `ansible_workflows.zsh` | Enable Ansible development workflows |
| `preferences.enable_java` | bool | true | `java_gradle_workflows.zsh` | Enable Java development workflows |
| `preferences.enable_groovy` | bool | true | `groovy_workflows.zsh` | Enable Groovy development workflows |
| `preferences.enable_rails` | bool | true | `rails_workflows.zsh` | Enable Rails development workflows |
| `preferences.enable_rust` | bool | true | `rust_workflows.zsh` | Enable Rust development workflows |
| `preferences.enable_ruby` | bool | true | `ruby_workflows.zsh` | Enable Ruby development workflows |
| `preferences.enable_hashicorp` | bool | true | `hashicorp_workflows.zsh` | Enable HashiCorp toolchain (Terraform, Vault, Packer, Consul) |
| `preferences.enable_vscode` | bool | true | `vscode_workflows.zsh` | Enable VS Code integration |
| `preferences.enable_github` | bool | true | `github_workflows.zsh` | Enable GitHub CLI integration |
| `preferences.enable_omnifocus` | bool | true | `omnifocus_workflows.zsh` | Enable OmniFocus integration |

## Pomodoro Timer Preferences

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `preferences.pomodoro_work` | int | 25 | Pomodoro timer functions | Work period duration in minutes |
| `preferences.pomodoro_break` | int | 5 | Pomodoro timer functions | Short break duration in minutes |
| `preferences.pomodoro_longbreak` | int | 15 | Pomodoro timer functions | Long break duration in minutes |
| `preferences.pomodoro_cycles` | int | 4 | Pomodoro timer functions | Number of work periods before long break |

## Cloud Provider Variables

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `cloud.aws` | bool | true | `cloud.zsh` | Enable AWS configuration (profile, region, credentials) |
| `cloud.azure` | bool | true | `cloud.zsh` | Enable Azure CLI configuration |
| `cloud.gcp` | bool | true | `cloud.zsh` | Enable Google Cloud Platform configuration |
| `cloud.digitalocean` | bool | true | `cloud.zsh` | Enable DigitalOcean CLI configuration |
| `cloud.oracle` | bool | true | `cloud.zsh` | Enable Oracle Cloud configuration |
| `cloud.linode` | bool | false | `cloud.zsh` | Enable Linode configuration |

## Security Variables

| Variable | Type | Default | Used By | Description |
|----------|------|---------|---------|-------------|
| `security.gpg_signing` | bool | true | `security.zsh` | Enable GPG signing for commits |
| `security.use_ssh_agent` | bool | true | `security.zsh` | Enable SSH agent initialization and management |
| `security.use_keychain` | bool | true | `security.zsh` | Enable macOS keychain for GPG (macOS only) |
| `security.use_1password` | bool | false | `security.zsh` | Enable 1Password CLI integration |
| `security.use_yubikey` | bool | false | `security.zsh` | Enable YubiKey support for GPG/SSH |

## Variable Usage Patterns

- **Top-level variables**: Referenced directly as `{{ .variableName }}`
- **Nested sections**: Referenced as `{{ .section.variableName }}` (e.g., `{{ .cloud.aws }}`)
- **Defaults**: Used via `{{ .var | default "value" }}`
- **Conditionals**: Checked with `{{ if .variableName }}` or `{{ if or .var1 .var2 }}`
- **Environment setup**: Many preferences set environment variables (CARGO_HOME, RBENV_ROOT, etc.)
