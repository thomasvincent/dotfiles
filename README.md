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
- **Workflow Automation** - Project management, Git, and Docker workflows
- **Productivity Tools** - Task management, note-taking, and time tracking
- **macOS Integration** - Native Notes, Reminders, Mail, and Calendar apps integration
- **Development Workflows** - WordPress, Chef, Puppet, Ansible, Java, Groovy, Rails, Ruby, and Rust
- **DevOps Toolchain** - HashiCorp suite (Terraform, Vault, Consul, Nomad, Packer, Boundary, Waypoint)
- **Editor Integration** - VS Code workflows, settings, and extensions
- **GTD Methodology** - Getting Things Done workflow support with OmniFocus, native macOS apps, Google tools, and Microsoft 365
- **Chat Integration** - Slack and Microsoft Teams workflows
- **Email & Calendar** - Gmail, Google Calendar, and Office365 integrations

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

### Utility Scripts

- **setup-hooks.sh** - Sets up pre-commit hooks for development
- **fix-code-style.sh** - Fixes common code style issues (trailing whitespace, newlines)

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
- **home/dot_zsh/** - ZSH configuration modules
  - **cloud.zsh.tmpl** - Cloud provider specific functions and aliases
  - **security.zsh.tmpl** - Security enhancements and configurations
  - **workflows.zsh.tmpl** - Development workflow functions
  - **productivity.zsh.tmpl** - Productivity tools and functions
  - **cicd.zsh.tmpl** - CI/CD workflows for Jenkins and GitHub Actions
  - **dev_workflows.zsh.tmpl** - WordPress, Chef, and Puppet development workflows
  - **app_workflows.zsh.tmpl** - Integration with productivity apps (GTD, Mail, Slack, Teams, etc.)
  - **macos_gtd_workflows.zsh.tmpl** - Native macOS apps integration for GTD (Notes, Reminders, Calendar, Mail)
  - **google_gtd_workflows.zsh.tmpl** - Google tools integration for GTD (Keep, Tasks, Calendar, Gmail, Drive)
  - **microsoft_gtd_workflows.zsh.tmpl** - Microsoft 365 and Cloud integration for GTD (To Do, OneNote, Outlook, Teams)
  - **ansible_workflows.zsh.tmpl** - Ansible development and automation workflows
  - **java_gradle_workflows.zsh.tmpl** - Java and Gradle development workflows
  - **groovy_workflows.zsh.tmpl** - Groovy scripting and development workflows
  - **rails_workflows.zsh.tmpl** - Ruby on Rails development workflows
  - **ruby_workflows.zsh.tmpl** - Ruby development workflows and tools
  - **rust_workflows.zsh.tmpl** - Rust development workflows and cargo tools
  - **hashicorp_workflows.zsh.tmpl** - HashiCorp suite workflows (Terraform, Vault, etc.)
  - **vscode_workflows.zsh.tmpl** - VS Code editor integration and workflows
  - **github_workflows.zsh.tmpl** - GitHub CLI integration and workflows
  - **omnifocus_workflows.zsh.tmpl** - OmniFocus task management integration
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

## Language Support

This dotfiles configuration includes specific support for multiple programming languages:

- **Ruby** - Ruby environment with rbenv, management tools, project templates
- **Rust** - Cargo tools, project templates, dependency management
- **Node.js** - npm/yarn workflows, project templates
- **Python** - virtualenv, project templates, dependency management
- **Go** - Project templates, build tools
- **Java** - JVM environment, Gradle workflows
- **Groovy** - Scripting workflows, project templates
- **C++/C** - Build tools, project templates

## HashiCorp Stack Support

Full workflows for the HashiCorp toolchain:

- **Terraform** - Aliases, project templates, environment-specific configs
- **Vault** - Secret management, token creation, policy management
- **Consul** - Service discovery, KV store management
- **Nomad** - Job management, deployment workflows
- **Packer** - VM image building, template management
- **Boundary** - Access management workflows
- **Waypoint** - Deployment workflows

## Editor Support

Integrated support for popular editors:

- **VS Code** - Project templates, extension management, settings templates
- **Vim/Neovim** - Plugin management, configuration
- **JetBrains IDEs** - Configuration and workflow helpers

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

## Workflow Automation

Various workflow automation functions are provided to streamline your development process:

### Project Management

- `new-project <name> [type]` - Create a new project with standard structure (supports node, python, go, rust, java, web)
- `clone-and-setup <repo-url> [destination]` - Clone a repository and set up dependencies based on project type
- `dev-start [project-name]` - Start a development session with tmux and appropriate environment

### Git Workflows

- `git-feature <feature-name>` - Create a new feature branch from the default branch
- `git-publish [branch-name]` - Push a branch to remote and optionally create a PR
- `git-sync [branch-name]` - Sync a branch with the default branch

### Development Workflows

- `release-version <version> [release-notes]` - Create and push a new version tag
- `code-review <pr-number> [repository]` - Set up an environment for code review

### Docker Workflows

- `docker-run-project [project-name] [environment] [build]` - Run a project in Docker
- `docker-logs-project [project-name] [service] [follow]` - View logs for a Docker project

### CI/CD Workflows

#### Jenkins Workflows
- `jenkins-status <jenkins-url> <job-name>` - Get the status of a Jenkins job
- `jenkins-build <jenkins-url> <job-name>` - Trigger a Jenkins build
- `jenkins-new-file [pipeline-type]` - Create a new Jenkinsfile (simple, nodejs, python, java, multi-branch)

#### GitHub Actions Workflows
- `github-actions-new [workflow-type]` - Create new GitHub Actions workflow files (simple, nodejs, python, docker, release, pages)
- `github-actions-status <owner/repo> [workflow-name]` - Check GitHub Actions workflow status
- `github-actions-run <workflow> [repo] [branch]` - Run a GitHub Actions workflow

### DigitalOcean Workflows
- `do-droplets` - List DigitalOcean droplets with details
- `do-create-droplet <name> [size] [region] [image]` - Create a new DigitalOcean droplet
- `do-delete-droplet <droplet-id>` - Delete a DigitalOcean droplet
- `do-create-lamp <name> [size] [region]` - Create a LAMP stack droplet
- `do-create-wordpress <name> [size] [region]` - Create a WordPress droplet
- `do-volumes` - List DigitalOcean volumes
- `do-create-db <name> [engine] [size] [region]` - Create a database cluster
- `do-k8s` - List Kubernetes clusters
- `do-create-k8s <name> [region] [size] [count]` - Create a Kubernetes cluster
- `do-k8s-config <cluster-id>` - Configure kubectl for a DO Kubernetes cluster
- `do-app-create <name> [region]` - Create a new App Platform app

### WordPress Development Workflows
- `wp-init <project-name> [version] [port]` - Initialize a WordPress development environment
- `wp-child-theme <parent-theme> <child-theme> [title] [author]` - Generate a WordPress child theme
- `wp-export-db [output-file]` - Export WordPress database
- `wp-install-cli` - Install WP-CLI in a WordPress project

### Chef Development Workflows
- `chef-init-cookbook <cookbook-name> [options]` - Initialize a Chef cookbook
- `chef-gen-recipe <recipe-name>` - Generate a Chef recipe
- `chef-test [instance]` - Test a Chef cookbook with Test Kitchen
- `chef-create-role <role-name> [description]` - Create a Chef role
- `chef-report [output-file]` - Generate a Chef cookbook report
- `chef-upload` - Upload a Chef cookbook to a Chef server

### Puppet Development Workflows
- `puppet-init-module <module-name> [author]` - Initialize a new Puppet module
- `puppet-gen-class <class-name>` - Generate a Puppet class
- `puppet-gen-type <type-name>` - Create a Puppet resource type
- `puppet-lint [path]` - Run Puppet lint on a module
- `puppet-test` - Run Puppet Tests with PDK
- `puppet-build` - Build a Puppet module package

### Ansible Development Workflows
- `ansible-init-project <project-name> [directory]` - Initialize a new Ansible project
- `ansible-new-role <role-name> [directory]` - Create a new Ansible role
- `ansible-run <playbook-path> [inventory-path] [options]` - Run Ansible playbook with common options
- `ansible-new-vault <vault-name> [vault-directory]` - Create an encrypted Ansible vault file
- `ansible-generate-inventory <output-file> [source]` - Generate Ansible inventory file
- `ansible-adhoc <hosts> [module] [args] [inventory]` - Run Ansible adhoc command
- `ansible-scan-network <network-cidr> [output-file]` - Generate inventory from network scan
- `ansible-playbook-wizard <playbook-name>` - Interactively create a playbook

### Java/Gradle Development Workflows
- `java-init-gradle <project-name> [package-name] [directory]` - Initialize a new Java project with Gradle
- `java-init-spring <project-name> [package-name] [directory]` - Create a Java Spring Boot project
- `java-versions` - List all available versions of Java via SDKMAN
- `java-install <version>` - Install and set a specific version of Java via SDKMAN
- `java-gen-class <class-name> [package-name]` - Generate a new Java class with boilerplate
- `java-gen-pojo <class-name> [package-name] <fields>` - Generate a POJO with getters/setters/builders
- `java-gradle-wrapper` - Create Gradle wrapper for a project
- `java-gradle <task> [options]` - Run common Gradle tasks with provided options
- `java-gen-test <class-name> [package-name]` - Create a Java/JUnit test file

### Groovy Development Workflows
- `groovy-init-project <project-name> [package-name] [directory]` - Initialize a new Groovy project with Gradle
- `groovy-new-script <script-name> [description]` - Create a new Groovy script
- `groovy-gen-class <class-name> [package-name]` - Generate Groovy class with Spock test
- `groovy-run <script-path> [args]` - Compile and run a standalone Groovy script
- `groovy-convert-java <java-file> [output-directory]` - Convert a Java class to Groovy
- `groovy-gen-dsl <dsl-name> [package-name]` - Generate a Groovy DSL builder
- `groovy-install <version>` - Install Groovy using SDKMAN
- `groovy-grape-script <script-name> [description]` - Create a Groovy Grape dependency script

### Rails Development Workflows
- `rails-init-project <project-name> [db-type] [options] [directory]` - Initialize a new Rails project
- `rails-gen-model <model-name> [fields]` - Generate a Rails model with boilerplate and specs
- `rails-gen-controller <controller-name> [actions]` - Generate a Rails controller with views and specs
- `rails-init-api <project-name> [db-type] [options] [directory]` - Setup a new Rails API project
- `rails-gen-api-resource <resource-name> [fields]` - Generate a Rails API resource with CRUD endpoints
- `rails-gen-service <service-name> [method-name]` - Generate a Rails service object
- `rails-db-migrate [environment]` - Run a Rails database migration
- `rails-db <operation> [environment]` - Rails database operations

### OmniFocus Integration
- `of-add <task-name> [note] [due-date]` - Add a task to OmniFocus inbox
- `of-add-to-project <project-name> <task-name> [note] [due-date]` - Add a task to a specific OmniFocus project
- `of-projects [filter]` - List all OmniFocus projects
- `of-tasks <project-name> [include-completed]` - List all tasks in a specific OmniFocus project
- `of-complete <task-name>` - Mark an OmniFocus task as completed
- `of-search <search-term> [context]` - Search for tasks in OmniFocus
- `of-new-project <project-name> [folder-name]` - Create a new OmniFocus project
- `of-folders` - List all OmniFocus folders
- `of-today` - Show tasks due today in OmniFocus
- `of-process-inbox` - Process OmniFocus inbox items to projects
- `of-template <template-name>` - Create a new project template in OmniFocus
- `of-apply-template <template-name> <project-name> [folder-name]` - Apply a template to create a new project
- `of-templates` - List all OmniFocus templates
- `of-quick-entry` - Create a quick OmniFocus entry with project and context
- `of-weekly-review` - Create a GTD weekly review workflow in OmniFocus

### Ruby Development Workflows
- `ruby-init <project-name> [ruby-version]` - Initialize a new Ruby project
- `rails-init <project-name> [database] [additional options]` - Initialize a new Rails project
- `ruby-lint` - Run Ruby linter
- `ruby-test` - Run Ruby tests
- `rc` - Run Rails console
- `rs` - Run Rails server
- `rg` - Run Rails generator
- `rmig` - Run Rails migrations
- `rr` - Run Rails routes
- `rails-controller <controller-name> [action1 action2 ...]` - Create a new Rails controller
- `rails-model <model-name> [attribute1:type attribute2:type ...]` - Create a new Rails model
- `rails-api <project-name>` - Set up a Rails API project
- `rails-api-scaffold <model-name> [attribute1:type attribute2:type ...]` - Create Rails scaffold with API endpoints
- `rails-erd` - Generate ERD diagram for Rails models
- `ruby-gem <gem-name>` - Create a gem from template
- `ruby-install <version>` - Install Ruby version with rbenv
- `rails-security` - Run Rails security check
- `sinatra-init <app-name>` - Create a new Sinatra app

### Rust Development Workflows
- `rust-init <project-name> [bin|lib]` - Initialize a new Rust project
- `ra-server` - Run rust-analyzer language server
- `rust-workspace <member1> <member2> ...` - Create a new workspace in current directory
- `rust-lint` - Run cargo clippy with pedantic warnings
- `rust-project <project-name> [bin|lib]` - Start a Rust project with common dependencies
- `rust-audit` - Check rust project dependencies for security vulnerabilities
- `rust-profile` - Build and run a release version with timing
- `rust-outdated` - Check for outdated dependencies
- `rust-depgraph [output.png]` - Generate dependency graph
- `rust-cli <app-name>` - Start a new Rust application with a basic CLI

### HashiCorp Workflows

#### Terraform Workflows
- `tf-init-backend [env]` - Initialize Terraform with backend config
- `tf-plan-env [env]` - Plan Terraform with variables file
- `tf-apply-env [env]` - Apply Terraform with variables file
- `tf-project <project-name> [provider]` - Create Terraform directory structure for a new project
- `tf-module <module-name> [description]` - Create a new Terraform module
- `tf-visualize [planfile]` - Visualize Terraform plan
- `tf-docs [dir]` - Generate Terraform documentation
- `tf-check` - Run Terraform validation and security checks
- `tf-workspace-create <workspace-name>` - Create a Terraform workspace
- `tf-cost [env]` - Calculate Terraform cost estimate
- `tf-export` - Export Terraform outputs to environment variables

#### Vault Workflows
- `vault-dev [vault-dir]` - Initialize a Vault development server
- `vault-env [addr] [token]` - Set up Vault environment variables
- `vault-kv-init [path]` - Initialize a Vault KV store
- `vault-store <path> <key> [value]` - Store a secret in Vault with confirmation
- `vault-get <path> [key]` - Retrieve a secret from Vault
- `vault-export <path>` - Export Vault secrets as environment variables
- `vault-policy-create <policy-name> <policy-file>` - Create a new Vault policy
- `vault-policy-template <policy-name> [path-prefix]` - Generate a policy file template
- `vault-token-create <policy> [ttl]` - Create a new Vault token with a specific policy

#### Consul Workflows
- `consul-dev [data-dir]` - Start a Consul development server
- `consul-put <key> <value>` - Store a key-value pair in Consul
- `consul-get <key>` - Retrieve a value from Consul KV store
- `consul-list [prefix]` - List keys in Consul KV store
- `consul-export [prefix]` - Export Consul KV pairs as environment variables
- `consul-register <service-name> [port] [tags]` - Register a service with Consul
- `consul-deregister <service-name>` - Deregister a service from Consul

#### Nomad Workflows
- `nomad-dev [data-dir]` - Start a Nomad development server
- `nomad-job-template <job-name> [job-type]` - Create a Nomad job template
- `nomad-run <job-file>` - Run a Nomad job
- `nomad-status <job-name>` - Check Nomad job status
- `nomad-logs <job-name> [task-name]` - View Nomad job logs
- `nomad-exec <job-name> [command] [task-name]` - Execute a command in a Nomad allocation
- `nomad-stop <job-name>` - Stop a Nomad job

#### Packer Workflows
- `packer-template <template-name> [builder]` - Create a Packer template
- `packer-lint [dir]` - Check and format Packer templates
- `packer-build [template-dir] [vars...]` - Build a Packer image with variables
- `packer-inspect [template-dir]` - Inspect a Packer template

#### Boundary Workflows
- `boundary-env [addr]` - Set up Boundary environment
- `boundary-login [auth-method-id] [username] [password]` - Authenticate with Boundary
- `boundary-targets [scope-id]` - List Boundary targets
- `boundary-connect <target-id> [port]` - Connect to a Boundary target

#### Waypoint Workflows
- `waypoint-template <project-name> [platform]` - Create a Waypoint project template
- `waypoint-server-dev` - Initialize Waypoint server in development mode
- `waypoint-up [folder]` - Run the complete Waypoint deployment workflow
- `waypoint-status` - Check Waypoint project status
- `waypoint-logs [deployment]` - View Waypoint deployment logs
- `waypoint-exec <command> [deployment]` - Execute a command in a Waypoint deployment

### VS Code Workflows
- `vs [directory]` - Open VS Code in current directory
- `vsproj [project-name]` - Open VS Code with a specific project
- `vscode-export-extensions [output-file]` - Export a list of installed VS Code extensions
- `vscode-install-extensions [input-file]` - Install VS Code extensions from a list
- `vscode-create-workspace <workspace-name> [extension1 extension2 ...]` - Create a workspace with recommended extensions
- `vsworkspace <workspace-file>` - Open VS Code with a specific workspace
- `vscode-setup <project-type>` - Create a collection of recommended settings for different project types
- `vscode-customize [keybinding-style]` - Set up VS Code with custom keybindings and settings
- `vsdiff <file1> <file2>` - Create a diff view for two files
- `vscode-snippet <snippet-name> <language> [description]` - Create a new code snippet

### GitHub Workflows
- `gh-init <repo-name> [visibility] [description]` - Initialize a new GitHub repository
- `gh-init-current [visibility] [description]` - Create a GitHub repository from the current directory
- `gh-fork <owner/repo> [clone-directory]` - Fork a GitHub repository
- `gh-new-issue <title> [body] [repo] [labels] [assignee]` - Create a GitHub issue
- `gh-new-pr <title> [body] [base-branch] [repo] [labels] [reviewers]` - Create a pull request
- `gh-search-repos <query> [limit]` - Search GitHub repositories
- `gh-search-issues <query> [limit]` - Search GitHub issues
- `gh-clone <repo> [destination]` - Clone a GitHub repository
- `gh-new-gist <description> <file-path> [is-public]` - Create a GitHub Gist
- `gh-release <tag-name> [title] [notes-file] [prerelease] [draft] [target]` - Create a GitHub release
- `gh-release-notes <previous-tag> <new-tag> [output-file]` - Generate a GitHub release notes file
- `gh-workflows [repo]` - List GitHub workflows
- `gh-run-workflow <workflow> [ref] [repo] [inputs]` - Run a GitHub workflow
- `gh-new-workflow <workflow-name> [template]` - Create a GitHub Actions workflow file
- `gh-project-setup [repo-name] [template]` - Setup GitHub project with common files
- `gh-stats [owner/repo]` - Display GitHub repository stats
- `gh-codeowners [content]` - Create a GitHub CODEOWNERS file
- `gh-badge <workflow-name> [branch]` - Generate GitHub Actions status badge for README
- `gh-dependabot` - Create a GitHub dependabot configuration
- `gh-pr-template` - Create a GitHub pull request template
- `gh-security-policy` - Create a GitHub security policy
- `gh-branch-protection [branch] [owner/repo]` - Set up GitHub branch protection rules

## Productivity Tools

This dotfiles setup includes several productivity enhancing tools:

### Task Management

- `task-add <description> [list]` - Add a new task to track
- `task-list [filter] [list]` - List current tasks
- `task-done <task-number> [list]` - Mark a task as completed
- `task-history [days] [list]` - Show completed task history
- `task-clear [list]` - Clear completed task history

macOS specific (with Reminders app integration):
- `task-lists` - List all available Reminders lists
- `task-new-list <name>` - Create a new Reminders list

### Note Taking

- `note-new <title> [folder] [content]` - Create a new note
- `note-list [filter] [folder]` - List available notes
- `note-view <title> [folder]` - View a specific note
- `note-search <term> [folder]` - Search notes for a term

macOS specific (with Notes app integration):
- `note-folders` - List all available Notes folders
- `note-new-folder <name>` - Create a new Notes folder

### Meeting Notes

- `meeting-start <title> [attendees]` - Start a meeting note with a standard template
- `meeting-list [filter]` - List meeting notes
- `meeting-view <title>` - View a specific meeting note
- `meeting-actions [days]` - Extract action items from meeting notes

macOS specific:
- `meeting-to-tasks <title> [list]` - Convert meeting action items to tasks in Reminders

### Time Tracking

- `time-start <project> <task>` - Start tracking time
- `time-stop` - Stop tracking time for the current task
- `time-switch <project> <task>` - Switch to tracking a different task
- `time-summary [period]` - Show time tracking summary

### Focus Tools

- `pomodoro <task> [cycles]` - Run a Pomodoro timer for focused work
- `timer <minutes> [description]` - Run a simple countdown timer

### GTD (Getting Things Done) Workflows

- `gtd-capture <note-text>` - Capture a quick note to your GTD inbox
- `gtd-review` - Start a GTD weekly review with a template
- `gtd-new-project <project-name>` - Create a new GTD project template
- `gtd-next [context]` - List GTD next actions, optionally by context

### macOS Native GTD Apps Integration

- `reminders-new-list <list-name>` - Create a new list in Reminders
- `reminders-lists` - Show all lists in Reminders
- `reminders-add <task> [list] [due-date] [priority]` - Add a task to Reminders
- `reminders-list [list] [filter]` - List tasks in a specified list
- `reminders-complete <task-number> [list]` - Complete a task
- `reminders-review` - Weekly review of all tasks

- `notes-new-folder <folder-name>` - Create a new folder in Notes
- `notes-folders` - List all folders in Notes
- `notes-new <title> [folder] [content]` - Create a new note
- `notes-new-project <project-name> [folder]` - Create a new project note with template
- `notes-list [folder] [filter]` - List notes in a folder
- `notes-open <title> [folder]` - Open a specific note

- `calendar-create <title> <start-date-time> [end-date-time] [location] [calendar] [all-day]` - Create a new calendar event
- `calendar-list` - List available calendars
- `calendar-today` - List today's events

- `gtd-status` - Show current GTD system status
- `gtd-new-context <context-name>` - Create new context list for next actions
- `gtd-process-email` - Process email and create actions
- `gtd-meeting <title> <date-time> [attendees] [location]` - Create a meeting note and calendar event
- `gtd-focus <task-description> [duration-minutes]` - Set up a focused work session with notes and timer
- `gtd-extract-actions [days]` - Extract action items from all meeting notes

### Google Tools GTD Integration

- `gkeep-open [search]` - Open Google Keep, optionally with search
- `gkeep-capture <note-text>` - Create a new note in Google Keep
- `gkeep-label <label>` - Open Google Keep filtered by label

- `gtasks-open [list]` - Open Google Tasks
- `gtasks-gmail` - Open Gmail with Google Tasks sidebar

- `gcal-open [view] [date]` - Open Google Calendar in specified view
- `gcal-new <title> <start> [end] [details] [location]` - Create a new Google Calendar event
- `gcal-today` - Show today's Google Calendar events
- `gcal-range <start-date> <end-date>` - Open Google Calendar for a specific date range

- `gmail-open [label]` - Open Gmail, optionally with specified label
- `gmail-search <search-query>` - Open Gmail with search
- `gmail-compose <to> [subject] [body]` - Create a Gmail draft
- `gmail-filter <filter>` - Open Gmail with predefined filters

- `gdrive-open [folder]` - Open Google Drive, optionally with folder
- `gdrive-search <search-term>` - Search Google Drive
- `gdocs-new [title]` - Create a new Google Docs document
- `gsheets-new [title]` - Create a new Google Sheets spreadsheet

- `ggoog-gtd-open` - Open Google Drive GTD system
- `ggoog-gtd-capture <note-text>` - Capture a note to Google Keep for GTD
- `ggoog-gtd-project <project-name>` - Create a new GTD project in Google Docs
- `ggoog-gtd-review` - Start a GTD weekly review in Google Docs
- `ggoog-gtd-weekly-plan` - Create a weekly planning doc with calendar integration
- `ggoog-gtd-meeting <title> <date> [attendees]` - Create a meeting note with calendar event
- `ggoog-gtd-focus <task> [duration]` - Set up a focused work session with Google Keep
- `ggoog-gtd-next` - Show next actions from various Google sources
- `ggoog-gtd-dashboard` - Open all GTD components in browser tabs

### Microsoft 365 and Cloud GTD Integration

- `mstodo-open [list]` - Open Microsoft To Do, optionally with list
- `mstodo-myday` - Open the My Day view in Microsoft To Do
- `mstodo-important` - Open the Important list in Microsoft To Do
- `mstodo-planned` - Open the Planned list in Microsoft To Do

- `msonenote-open` - Open Microsoft OneNote
- `msonenote-new-notebook <name>` - Open OneNote to create a new notebook

- `msoutlook-open [folder]` - Open Microsoft Outlook
- `msoutlook-search <query>` - Search Outlook emails
- `msoutlook-compose <to> [subject] [body]` - Compose a new email in Outlook

- `mscalendar-open [view]` - Open Microsoft Calendar in specified view
- `mscalendar-new <title> <start> [end] [location]` - Create a new calendar event
- `mscalendar-today` - Show today's events

- `msonedrive-open [folder]` - Open Microsoft OneDrive
- `msonedrive-docs` - Open OneDrive Documents folder

- `msteams-open` - Open Microsoft Teams
- `msteams-chat <person>` - Open Teams chat with a person

- `msplanner-open` - Open Microsoft Planner
- `mssharepoint-open [site]` - Open SharePoint, optionally with site path
- `msazure-open [resource]` - Open Azure Portal, optionally with resource

- `ms-gtd-open` - Open Microsoft GTD system components
- `ms-gtd-capture <task>` - Open Microsoft To Do for task capture
- `ms-gtd-project <project>` - Create a project in OneNote
- `ms-gtd-review` - Start a GTD weekly review with Microsoft tools
- `ms-gtd-meeting <title> <date> [attendees]` - Create a meeting note with calendar
- `ms-gtd-focus <task> [duration]` - Set up a focused work session
- `ms-gtd-next` - Show next actions in Microsoft To Do
- `ms-gtd-dashboard` - Open all GTD dashboard components
- `ms-cloud-project <project>` - Open Microsoft cloud tools for a project

### Mail App Workflows (macOS)

- `mail-process` - Process Mail.app inbox using keyboard shortcuts
- `mail-new <recipient> [subject] [body]` - Create a new email
- `mail-unread` - Count unread emails
- `mail-flag-search <search-term>` - Flag important emails matching a search term
- `mail-from-note <note-title>` - Create an email draft from notes

### Slack Workflows

- `slack-send <webhook-url> <message> [channel] [username]` - Send a Slack message via webhook
- `slack-open <channel>` - Open Slack and navigate to a channel
- `slack-status <status-text> [status-emoji]` - Set Slack status
- `slack-remind <reminder-text> <time>` - Create a Slack reminder

### Microsoft Teams Workflows (macOS)

- `teams-open <team-name> [channel-name]` - Open Microsoft Teams and navigate to a channel
- `teams-new-meeting` - Start a new Teams meeting
- `teams-status <status>` - Set Teams status

### Gmail Workflows

- `gmail-search <search-query>` - Open Gmail with search
- `gmail-compose <to> [subject] [body]` - Create a Gmail draft with mailto
- `gmail-filter <filter>` - Open Gmail with predefined filters

### Calendar Workflows (macOS)

- `calendar-new <title> <start-date-time> [end-date-time] [location] [calendar]` - Create a new Calendar event
- `calendar-today` - List today's Calendar events
- `calendar-search <search-term> [days]` - Search Calendar events

### Google Calendar Workflows

- `gcal-new <title> <start-date-time> [end-date-time] [details] [location]` - Open Google Calendar to create a new event
- `gcal-open [view] [date]` - Open Google Calendar with specific view
- `gcal-range <start-date> <end-date>` - Open Google Calendar for a specific date range

### Office365 Workflows

- `office365-open <app>` - Open Office365 apps
- `office365-new <document-type>` - Create a new document in Office365
- `outlook-compose <to> [subject] [body]` - Compose a new email in Outlook
- `onedrive-open [folder-path]` - Open OneDrive folder

### macOS Integration

On macOS systems, this dotfiles setup integrates with native applications:

- **Reminders App**: Task management functions automatically use Apple Reminders
- **Notes App**: Note taking functions integrate with Apple Notes
- **Mail.app**: Email management functions
- **Calendar.app**: Calendar management functions
- **Notification Center**: Timers and alerts use native notifications
- **Folders & Organization**: Specific folders for meetings and tasks sync with the native apps

To customize the macOS integration, use the following settings in your `chezmoi.toml`:

```toml
[data.preferences]
    # macOS integration preferences
    notes_folder = "CLI Notes"     # Default folder name in macOS Notes app
    meeting_folder = "Meetings"    # Folder for meetings in macOS Notes app
    reminders_list = "CLI Tools"   # Default list name in macOS Reminders app

    # GTD workflow preferences
    gtd_inbox_folder = "GTD/Inbox"   # Folder for GTD inbox in Notes app
    gtd_projects_folder = "GTD/Projects"  # Folder for GTD projects in Notes app
```

If you're not using macOS or prefer the plain text approach, all functions automatically fall back to local files.

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
