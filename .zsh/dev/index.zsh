#!/usr/bin/env zsh
# =============================================================================
# Developer Environment Configuration Loader
# =============================================================================
#
# File: ~/.zsh/dev/index.zsh
# Purpose: Central loader for all development environment modules
# Platform: macOS (with Linux compatibility)
#
# This file orchestrates loading of all development tool configurations.
# Modules are loaded in a specific order to handle dependencies.
#
# Loading Order:
#   1. Core tools (git)
#   2. Programming languages
#   3. Container/orchestration tools
#   4. Infrastructure as Code
#   5. Cloud platforms
#   6. Utilities (network, database)
#   7. Local customizations
#
# =============================================================================

# Get the directory containing this file
DEV_MODULE_DIR="${0:h}"

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

# -----------------------------------------------------------------------------
# source_if_exists: Safely source a file if it exists
# -----------------------------------------------------------------------------
#
# This function prevents errors when optional modules are missing.
# It silently skips files that don't exist.
#
# Usage:
#   source_if_exists "$DEV_MODULE_DIR/module.zsh"
#
# -----------------------------------------------------------------------------
source_if_exists() {
  emulate -L zsh
  [[ -f "$1" ]] && source "$1" 2>/dev/null || true
}

# =============================================================================
# MODULE LOADING
# =============================================================================
#
# Modules are loaded in dependency order. Some modules may depend on
# functions or aliases defined in earlier modules.
#
# =============================================================================

# -----------------------------------------------------------------------------
# Core Development Tools
# -----------------------------------------------------------------------------
# These are the foundational tools used across all development work.
# -----------------------------------------------------------------------------
source_if_exists "$DEV_MODULE_DIR/git-module.zsh"     # Git configuration
source_if_exists "$DEV_MODULE_DIR/git-extras.zsh"     # Advanced Git workflows

# -----------------------------------------------------------------------------
# Programming Languages
# -----------------------------------------------------------------------------
# Language-specific configurations, version managers, and tooling.
# -----------------------------------------------------------------------------
source_if_exists "$DEV_MODULE_DIR/node.zsh"           # Node.js / npm / yarn
source_if_exists "$DEV_MODULE_DIR/python.zsh"         # Python / pip / venv
source_if_exists "$DEV_MODULE_DIR/java.zsh"           # Java / Maven / Gradle
source_if_exists "$DEV_MODULE_DIR/php.zsh"            # PHP / Composer
source_if_exists "$DEV_MODULE_DIR/rust.zsh"           # Rust / Cargo
source_if_exists "$DEV_MODULE_DIR/ruby.zsh"           # Ruby / Bundler
source_if_exists "$DEV_MODULE_DIR/go.zsh"             # Go

# -----------------------------------------------------------------------------
# Container and Orchestration
# -----------------------------------------------------------------------------
# Tools for containerization and container orchestration.
# Order matters: Docker before Kubernetes before GitOps tools.
# -----------------------------------------------------------------------------
source_if_exists "$DEV_MODULE_DIR/docker.zsh"         # Docker / Compose
source_if_exists "$DEV_MODULE_DIR/kubernetes.zsh"     # kubectl / Helm
source_if_exists "$DEV_MODULE_DIR/argocd.zsh"         # ArgoCD GitOps

# -----------------------------------------------------------------------------
# Infrastructure as Code
# -----------------------------------------------------------------------------
# Tools for managing infrastructure through code.
# -----------------------------------------------------------------------------
source_if_exists "$DEV_MODULE_DIR/terraform.zsh"      # Terraform
source_if_exists "$DEV_MODULE_DIR/ansible.zsh"        # Ansible

# -----------------------------------------------------------------------------
# Cloud Platforms
# -----------------------------------------------------------------------------
# Cloud provider CLI tools and helpers.
# -----------------------------------------------------------------------------
source_if_exists "$DEV_MODULE_DIR/aws.zsh"            # AWS CLI
source_if_exists "$DEV_MODULE_DIR/gcp.zsh"            # Google Cloud
source_if_exists "$DEV_MODULE_DIR/azure.zsh"          # Azure CLI
source_if_exists "$DEV_MODULE_DIR/digitalocean.zsh"   # DigitalOcean

# -----------------------------------------------------------------------------
# Utilities
# -----------------------------------------------------------------------------
# General development utilities.
# -----------------------------------------------------------------------------
source_if_exists "$DEV_MODULE_DIR/network.zsh"        # Network / API debugging
source_if_exists "$DEV_MODULE_DIR/database.zsh"       # Database tools
source_if_exists "$DEV_MODULE_DIR/github.zsh"         # GitHub CLI

# -----------------------------------------------------------------------------
# Local Configuration (Machine-Specific)
# -----------------------------------------------------------------------------
# This file is not tracked by git and contains machine-specific settings.
# See local.zsh.example for a template.
# -----------------------------------------------------------------------------
source_if_exists "$DEV_MODULE_DIR/local.zsh"

# =============================================================================
# UNIVERSAL FUNCTIONS
# =============================================================================
#
# These functions work across all project types and development contexts.
#
# =============================================================================

# -----------------------------------------------------------------------------
# init-project: Universal project initializer
# -----------------------------------------------------------------------------
#
# Creates a new project with the appropriate structure for the given type.
#
# Usage:
#   init-project node my-api        # Create Node.js project
#   init-project python ml-project  # Create Python project
#   init-project terraform infra    # Create Terraform project
#
# -----------------------------------------------------------------------------
init-project() {
  local project_type="$1"
  local project_name="$2"
  local args=("${@:3}")

  if [[ -z "$project_type" || -z "$project_name" ]]; then
    echo "Usage: init-project <type> <name> [options]"
    echo ""
    echo "Available types:"
    echo "  node       - Node.js project with package.json"
    echo "  python     - Python project with venv"
    echo "  rust       - Rust project with Cargo"
    echo "  go         - Go module"
    echo "  terraform  - Terraform project with environments"
    echo "  docker     - Docker project with Dockerfile + compose"
    echo "  git        - Initialize Git repository"
    echo "  gh         - Create GitHub repository"
    return 1
  fi

  case "$project_type" in
    node)
      mkdir -p "$project_name" && cd "$project_name"
      npm init -y
      git init
      echo "node_modules/" > .gitignore
      echo "✅ Created Node.js project: $project_name"
      ;;
    python)
      mkdir -p "$project_name" && cd "$project_name"
      python3 -m venv .venv
      source .venv/bin/activate
      git init
      echo ".venv/\n__pycache__/\n*.pyc" > .gitignore
      echo "✅ Created Python project: $project_name (venv activated)"
      ;;
    rust)
      cargo new "$project_name"
      cd "$project_name"
      echo "✅ Created Rust project: $project_name"
      ;;
    go)
      mkdir -p "$project_name" && cd "$project_name"
      go mod init "$project_name"
      git init
      echo "✅ Created Go project: $project_name"
      ;;
    terraform)
      tf-project "$project_name" "${args[@]}"
      ;;
    docker)
      mkdir -p "$project_name" && cd "$project_name"
      cat > Dockerfile << 'EOF'
FROM alpine:latest
WORKDIR /app
COPY . .
CMD ["sh"]
EOF
      cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
EOF
      git init
      echo "✅ Created Docker project: $project_name"
      ;;
    git)
      mkdir -p "$project_name" && cd "$project_name"
      git init
      echo "# $project_name" > README.md
      git add README.md
      git commit -m "Initial commit"
      echo "✅ Initialized Git repository: $project_name"
      ;;
    *)
      echo "❌ Unknown project type: $project_type"
      return 1
      ;;
  esac
}

# -----------------------------------------------------------------------------
# docs: Open documentation for a technology
# -----------------------------------------------------------------------------
#
# Quickly access official documentation in your browser.
#
# Usage:
#   docs node        # Open Node.js docs
#   docs k8s         # Open Kubernetes docs
#   docs terraform   # Open Terraform docs
#
# -----------------------------------------------------------------------------
docs() {
  local topic="$1"

  if [[ -z "$topic" ]]; then
    echo "Usage: docs <technology>"
    echo ""
    echo "Available documentation:"
    echo "  node, python, go, rust, ruby      - Languages"
    echo "  git, github                       - Version control"
    echo "  docker, k8s, helm                 - Containers"
    echo "  terraform, ansible                - IaC"
    echo "  aws, gcp, azure                   - Cloud"
    echo "  argocd, flux                      - GitOps"
    echo "  postgres, mysql, redis, mongo     - Databases"
    return 1
  fi

  # Documentation URLs
  local -A docs_urls=(
    # Languages
    [node]="https://nodejs.org/en/docs/"
    [python]="https://docs.python.org/3/"
    [go]="https://go.dev/doc/"
    [rust]="https://doc.rust-lang.org/book/"
    [ruby]="https://ruby-doc.org/"
    [java]="https://docs.oracle.com/en/java/"
    [php]="https://www.php.net/docs.php"
    
    # Version control
    [git]="https://git-scm.com/doc"
    [github]="https://docs.github.com/"
    
    # Containers
    [docker]="https://docs.docker.com/"
    [k8s]="https://kubernetes.io/docs/"
    [kubernetes]="https://kubernetes.io/docs/"
    [helm]="https://helm.sh/docs/"
    
    # Infrastructure as Code
    [terraform]="https://developer.hashicorp.com/terraform/docs"
    [tf]="https://developer.hashicorp.com/terraform/docs"
    [ansible]="https://docs.ansible.com/"
    [pulumi]="https://www.pulumi.com/docs/"
    
    # Cloud
    [aws]="https://docs.aws.amazon.com/"
    [gcp]="https://cloud.google.com/docs"
    [azure]="https://docs.microsoft.com/azure/"
    [do]="https://docs.digitalocean.com/"
    
    # GitOps
    [argocd]="https://argo-cd.readthedocs.io/"
    [argo]="https://argo-cd.readthedocs.io/"
    [flux]="https://fluxcd.io/docs/"
    
    # Databases
    [postgres]="https://www.postgresql.org/docs/"
    [mysql]="https://dev.mysql.com/doc/"
    [redis]="https://redis.io/docs/"
    [mongo]="https://www.mongodb.com/docs/"
  )

  local url="${docs_urls[$topic]}"
  
  if [[ -n "$url" ]]; then
    open "$url"
  else
    echo "❌ Unknown topic: $topic"
    echo "Run 'docs' without arguments to see available topics."
    return 1
  fi
}

# -----------------------------------------------------------------------------
# in-git-repo: Check if current directory is a Git repository
# -----------------------------------------------------------------------------
#
# Returns 0 (true) if in a Git repo, 1 (false) otherwise.
# Useful in conditionals.
#
# Usage:
#   in-git-repo && echo "In a repo" || echo "Not in a repo"
#
# -----------------------------------------------------------------------------
in-git-repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# -----------------------------------------------------------------------------
# dev-env: Start a tmux development environment
# -----------------------------------------------------------------------------
#
# Creates a tmux session with appropriate layout for the project type.
#
# Usage:
#   dev-env node        # Node.js layout
#   dev-env k8s         # Kubernetes layout
#   dev-env terraform   # Terraform layout
#
# -----------------------------------------------------------------------------
dev-env() {
  local env_type="$1"

  if ! command -v tmux &>/dev/null; then
    echo "❌ tmux not installed. Install with: brew install tmux"
    return 1
  fi

  case "$env_type" in
    node)
      echo "🟢 Starting Node.js development environment..."
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'npm run dev 2>/dev/null || npm start 2>/dev/null || echo "No dev script found"'
      tmux split-window -v 'git status; zsh'
      tmux attach-session -t dev
      ;;
    python)
      echo "🐍 Starting Python development environment..."
      [[ -d .venv ]] && source .venv/bin/activate
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'python main.py 2>/dev/null || echo "No main.py found"; zsh'
      tmux split-window -v 'git status; zsh'
      tmux attach-session -t dev
      ;;
    k8s|kubernetes)
      echo "☸️  Starting Kubernetes development environment..."
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'kubectl get pods -w'
      tmux split-window -v 'stern . 2>/dev/null || kubectl logs -f --tail=100 -l app'
      tmux attach-session -t dev
      ;;
    terraform|tf)
      echo "🗂️  Starting Terraform development environment..."
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'terraform plan'
      tmux split-window -v 'git status; zsh'
      tmux attach-session -t dev
      ;;
    docker)
      echo "🐳 Starting Docker development environment..."
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'docker compose logs -f 2>/dev/null || docker-compose logs -f'
      tmux split-window -v 'docker ps; zsh'
      tmux attach-session -t dev
      ;;
    *)
      echo "Usage: dev-env <type>"
      echo ""
      echo "Available types:"
      echo "  node       - Node.js (editor + dev server + git)"
      echo "  python     - Python (editor + runner + git)"
      echo "  k8s        - Kubernetes (editor + pods + logs)"
      echo "  terraform  - Terraform (editor + plan + git)"
      echo "  docker     - Docker (editor + logs + ps)"
      return 1
      ;;
  esac
}

# -----------------------------------------------------------------------------
# devops-status: Quick status check for DevOps tools
# -----------------------------------------------------------------------------
#
# Shows the current configuration status for common DevOps tools.
# Useful for verifying your environment is properly configured.
#
# Usage:
#   devops-status
#
# -----------------------------------------------------------------------------
devops-status() {
  echo "🛠️  DevOps Tools Status"
  echo "====================="
  echo ""
  
  # Kubernetes
  printf "%-12s" "Kubernetes:"
  if command -v kubectl &>/dev/null; then
    kubectl config current-context 2>/dev/null || echo "not configured"
  else
    echo "not installed"
  fi
  
  # Terraform
  printf "%-12s" "Terraform:"
  if command -v terraform &>/dev/null; then
    terraform version -json 2>/dev/null | jq -r '.terraform_version' 2>/dev/null || terraform version | head -1
  else
    echo "not installed"
  fi
  
  # AWS
  printf "%-12s" "AWS:"
  if command -v aws &>/dev/null; then
    local account=$(aws sts get-caller-identity --query 'Account' --output text 2>/dev/null)
    if [[ -n "$account" ]]; then
      echo "$account (${AWS_PROFILE:-default})"
    else
      echo "not authenticated"
    fi
  else
    echo "not installed"
  fi
  
  # ArgoCD
  printf "%-12s" "ArgoCD:"
  if command -v argocd &>/dev/null; then
    argocd version --client --short 2>/dev/null || echo "installed"
  else
    echo "not installed"
  fi
  
  # Helm
  printf "%-12s" "Helm:"
  if command -v helm &>/dev/null; then
    helm version --short 2>/dev/null | head -1
  else
    echo "not installed"
  fi
  
  # Docker
  printf "%-12s" "Docker:"
  if command -v docker &>/dev/null; then
    docker version --format '{{.Server.Version}}' 2>/dev/null || echo "not running"
  else
    echo "not installed"
  fi
  
  # GitHub CLI
  printf "%-12s" "GitHub CLI:"
  if command -v gh &>/dev/null; then
    gh auth status 2>&1 | grep -q "Logged in" && echo "authenticated" || echo "not authenticated"
  else
    echo "not installed"
  fi
}

# =============================================================================
# PATH ADDITIONS
# =============================================================================

# Add local bin to PATH for user-installed tools
path+=("$HOME/.local/bin")
