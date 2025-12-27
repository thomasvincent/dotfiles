# Development Workflows

> Automation functions for common development tasks.

---

## Project Initialization

### Universal Project Creator

```bash
init-project <type> <name> [options]
```

Supported types:
- `node` - Node.js project with package.json
- `python` - Python project with venv
- `rust` - Rust project with Cargo
- `java` - Java project with Gradle
- `terraform` - Terraform project with environments
- `docker` - Docker project with Dockerfile + compose
- `git` - Initialize Git repository

**Examples:**

```bash
init-project node my-api
init-project python data-pipeline
init-project terraform aws-infrastructure
```

---

## Git Workflows

### Quick Aliases

| Alias | Command |
|-------|---------|
| `g` | `git` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gco` | `git checkout` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `gs` | `git status` |
| `gd` | `git diff` |
| `gl` | `git log` |
| `gb` | `git branch` |

### Functions

```bash
# Check if in git repo
in-git-repo && echo "Yes" || echo "No"
```

---

## Development Environments

### Start Dev Environment

```bash
dev-env <type>
```

Opens tmux with:
- Editor (nvim)
- Dev server / watcher
- Git status

**Types:**
- `node` - npm run dev
- `python` - Python with venv
- `k8s` - kubectl watch + stern
- `terraform` - Terraform plan

**Example:**

```bash
cd my-node-project
dev-env node
```

---

## Documentation Quick Access

```bash
docs <technology>
```

Opens documentation in browser:

| Argument | Opens |
|----------|-------|
| `node` | nodejs.org/docs |
| `python` | docs.python.org |
| `git` | git-scm.com/doc |
| `docker` | docs.docker.com |
| `k8s` | kubernetes.io/docs |
| `terraform` | HashiCorp Terraform docs |
| `aws` | AWS documentation |
| `argocd` | ArgoCD docs |
| `helm` | Helm docs |

---

## CI/CD Workflows

### Jenkins

```bash
jenkins-status <url> <job>    # Check job status
jenkins-build <url> <job>     # Trigger build
jenkins-new-file [type]       # Create Jenkinsfile
```

### GitHub Actions

```bash
github-actions-new [type]           # Create workflow file
github-actions-status <owner/repo>  # Check workflow status
github-actions-run <workflow>       # Run workflow
```

---

## Productivity Tools

### Task Management

```bash
task-add "Fix the bug"        # Add task
task-list                      # List tasks
task-done 1                    # Complete task #1
```

### Note Taking

```bash
note-new "Meeting Notes"       # Create note
note-list                      # List notes
note-search "API"              # Search notes
```

### Time Tracking

```bash
time-start project task        # Start timer
time-stop                      # Stop timer
time-summary                   # Show summary
```

### Focus Tools

```bash
pomodoro "Write docs" 4        # 4 pomodoro cycles
timer 25 "Focus time"          # 25 minute timer
```

---

## Useful One-Liners

### Generate Secure Password

```bash
genpass 32                     # 32 character password
```

### Create Backup with Timestamp

```bash
backup important-file.txt      # Creates important-file.txt.bak-20251227-120000
```

### Extract Any Archive

```bash
extract archive.tar.gz         # Works with .zip, .tar, .7z, .rar, etc.
```

### Quick Weather

```bash
weather                        # Default: San Francisco
weather "New York"
```

### Show Colors

```bash
colors                         # Display terminal color palette
```
