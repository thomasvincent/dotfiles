# ZSH Module Reference

Complete reference of all 28 zsh modules managed by chezmoi.

## Core Modules (Always Loaded)

| Module | File | Toggle(s) | Description | Key Functions/Aliases |
|--------|------|-----------|-------------|----------------------|
| Aliases | `aliases.zsh.tmpl` | Always | Common shell abbreviations and shortcuts | `..`, `...`, `....`, `l`, `la`, `grep`, `zshrc`, `reload`, `cls`, `localip`, `ips` |
| Functions | `functions.zsh.tmpl` | Always | Utility functions for common tasks | `mkd`, `fs`, `unidecode`, `showcolors`, `hl` |
| Completion | `completion.zsh.tmpl` | Always | ZSH completion system configuration | Case-insensitive matching, menu-driven completion, colored lists, caching |
| History | `history.zsh.tmpl` | Always | Shell history settings and options | 50k history size, extended history with timestamps, deduplication, incremental append |
| Keybindings | `keybindings.zsh.tmpl` | Always | Emacs-style keybindings and navigation | Home/End, word navigation, history search, character deletion |
| FZF | `fzf.zsh.tmpl` | Always | Fuzzy finder integration with bat and eza | File preview, directory tree preview, context-aware completion |
| Modern Tools | `modern_tools.zsh.tmpl` | Always | Aliases for modern CLI replacements | `bat` for cat, `eza` for ls, `btop` for top, `trash` for rm, `prettyping` for ping |
| Utils | `utils.zsh.tmpl` | Always | Miscellaneous utility functions | `getcertnames`, `cdf`, DNS lookups, SSL certificate inspection |

## Security Module

| Module | File | Toggle(s) | Description | Key Functions/Aliases |
|--------|------|-----------|-------------|----------------------|
| Security | `security.zsh.tmpl` | `gpg_signing`, `use_ssh_agent`, `use_keychain`, `use_1password`, `use_yubikey` | SSH agent, GPG, keychain setup for macOS | SSH agent initialization, GPG TTY configuration, keychain integration |

## Cloud Module

| Module | File | Toggle(s) | Description | Key Functions/Aliases |
|--------|------|-----------|-------------|----------------------|
| Cloud | `cloud.zsh.tmpl` | `enable_cloud` | Multi-cloud provider configuration | `aws-profile`, `aws-list-profiles`, `aws-who`, `az-login`, `az-account`, GCP setup |

## CI/CD Module

| Module | File | Toggle(s) | Description | Key Functions/Aliases |
|--------|------|-----------|-------------|----------------------|
| CI/CD | `cicd.zsh.tmpl` | `enable_workflows` or `enable_dev_tools` | Jenkins, GitHub Actions, GitLab CI workflows | `jenkins-status`, `jenkins-build`, `jenkins-logs`, `jenkins-abort`, `jenkins-last-build` |

## Development Workflow Modules

| Module | File | Toggle(s) | Description | Key Functions/Aliases |
|--------|------|-----------|-------------|----------------------|
| Dev Workflows | `dev_workflows.zsh.tmpl` | `enable_dev_tools` | WordPress, Chef, Puppet project initialization | `wp-init`, `chef-init`, `puppet-init`, project scaffolding and Docker setup |
| Ansible | `ansible_workflows.zsh.tmpl` | `enable_ansible` or `enable_dev_tools` | Ansible project setup and playbook management | `ansible-init-project`, `ansible-init-playbook`, Ansible directory structure |
| Java/Gradle | `java_gradle_workflows.zsh.tmpl` | `enable_java` or `enable_dev_tools` | Java/Gradle project initialization | `java-init-gradle`, `java-init-maven`, project structure generation |
| Groovy | `groovy_workflows.zsh.tmpl` | `enable_groovy` or `enable_dev_tools` | Groovy/Gradle project setup | `groovy-init-project`, Gradle build configuration for Groovy |
| Rails | `rails_workflows.zsh.tmpl` | `enable_rails` or `enable_dev_tools` | Rails application generation and database setup | `rails-init-project`, database type selection, Rails scaffolding |
| Rust | `rust_workflows.zsh.tmpl` | `enable_rust` or `enable_dev_tools` | Rust cargo project management | `cr`, `cb`, `crr`, `cbr`, `ct`, `cc`, `cf`, `rust-init`, cargo commands |
| Ruby | `ruby_workflows.zsh.tmpl` | `enable_ruby` or `enable_dev_tools` | Ruby environment with rbenv/chruby | `rbenv` initialization, `chruby` setup for Ruby version management |
| HashiCorp | `hashicorp_workflows.zsh.tmpl` | `enable_hashicorp` or `enable_dev_tools` | Terraform, Packer, Vault, Consul workflows | `tfi`, `tfp`, `tfa`, `tfd`, `tfv`, `tfws`, Terraform state management aliases |
| VS Code | `vscode_workflows.zsh.tmpl` | `enable_vscode` or `enable_editors` | VS Code project and workspace management | `code`, `c`, `cr`, `vs`, `vsproj`, VS Code environment setup |
| GitHub | `github_workflows.zsh.tmpl` | `enable_github` or `enable_dev_tools` | GitHub CLI shortcuts and automation | `ghr`, `ghrc`, `ghrf`, `ghi`, `ghic`, `ghp`, `ghpc`, `ghs` |

## Productivity & GTD Modules

| Module | File | Toggle(s) | Description | Key Functions/Aliases |
|--------|------|-----------|-------------|----------------------|
| Workflows | `workflows.zsh.tmpl` | `enable_workflows` | Project management and scaffolding | `new-project`, project type support (generic, node, python, go, rust, java, web) |
| Productivity | `productivity.zsh.tmpl` | `enable_productivity` | Task management and Reminders integration | `task-add`, `task-list`, `task-done`, `task-clear`, `task-archive`, `task-search` |
| App Workflows | `app_workflows.zsh.tmpl` | `enable_productivity` | macOS native app integration | `gtd-capture`, Apple Notes/Reminders integration, GTD inbox capture |
| OmniFocus | `omnifocus_workflows.zsh.tmpl` | `enable_omnifocus` or `enable_productivity` | OmniFocus task management integration | `of-add`, `of-list`, `of-search`, `of-complete`, OmniFocus AppleScript automation |
| macOS GTD | `macos_gtd_workflows.zsh.tmpl` | `enable_macos_gtd` or `enable_gtd` | Native macOS GTD system using Notes/Reminders | `reminders-new-list`, `notes-create-folder`, GTD structure in native apps |
| Google GTD | `google_gtd_workflows.zsh.tmpl` | `enable_google_gtd` or `enable_gtd` | Google Drive, Calendar, Tasks GTD workflows | `gcal-open`, Google Sheets/Tasks integration, Drive folder structure |
| Microsoft GTD | `microsoft_gtd_workflows.zsh.tmpl` | `enable_microsoft_gtd` or `enable_gtd` | Microsoft 365 ToDo, Outlook, OneNote workflows | URL shortcuts to MS services, OneDrive/SharePoint GTD folders, Azure Portal |

## Summary

- **Total modules**: 28
- **Always-loaded**: 8 (aliases, functions, completion, history, keybindings, fzf, modern_tools, utils)
- **Conditional**: 20 (controlled by feature flags in chezmoi.toml)
- **Coverage**: Desktop dev workflows, cloud platforms, productivity systems, CI/CD pipelines, multiple programming languages
