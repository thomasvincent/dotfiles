#!/usr/bin/env zsh
# Developer environment configuration loader
# This file loads all development environment modules based on availability
# Optimized for macOS development workflows

DEV_MODULE_DIR="${0:h}"

# Function to source a file if it exists (with macOS error handling)
source_if_exists() {
  emulate -L zsh
  [[ -f "$1" ]] && source "$1" 2>/dev/null || true
}

# Load core development tools
source_if_exists "$DEV_MODULE_DIR/git-module.zsh"

# Load language-specific configurations
# Core languages
source_if_exists "$DEV_MODULE_DIR/node.zsh"
source_if_exists "$DEV_MODULE_DIR/python.zsh"
source_if_exists "$DEV_MODULE_DIR/java.zsh"
source_if_exists "$DEV_MODULE_DIR/php.zsh"
source_if_exists "$DEV_MODULE_DIR/rust.zsh"
source_if_exists "$DEV_MODULE_DIR/ruby.zsh"

# Container and orchestration tools
source_if_exists "$DEV_MODULE_DIR/docker.zsh"
source_if_exists "$DEV_MODULE_DIR/kubernetes.zsh"
source_if_exists "$DEV_MODULE_DIR/argocd.zsh"

# Infrastructure as Code
source_if_exists "$DEV_MODULE_DIR/terraform.zsh"

# Cloud platform tools
source_if_exists "$DEV_MODULE_DIR/aws.zsh"
source_if_exists "$DEV_MODULE_DIR/gcp.zsh"
source_if_exists "$DEV_MODULE_DIR/azure.zsh"
source_if_exists "$DEV_MODULE_DIR/digitalocean.zsh"

# Other tools
source_if_exists "$DEV_MODULE_DIR/database.zsh"
source_if_exists "$DEV_MODULE_DIR/github.zsh"

# Load local developer config if exists
source_if_exists "$DEV_MODULE_DIR/local.zsh"

# Create a universal project initializer
init-project() {
  local project_type="$1"
  local project_name="$2"
  local args=("${@:3}")

  if [[ -z "$project_type" || -z "$project_name" ]]; then
    echo "Usage: init-project <type> <name> [options]"
    print -P "%F{blue}Available types:%f"
    print -P "  %F{green}node%f       - Create a Node.js project"
    print -P "  %F{green}python%f     - Create a Python project"
    print -P "  %F{green}git%f        - Initialize a Git repository"
    print -P "  %F{green}docker%f     - Create a Docker project"
    print -P "  %F{green}php%f        - Create a PHP project"
    print -P "  %F{green}java%f       - Create a Java project"
    print -P "  %F{green}rust%f       - Create a Rust project"
    print -P "  %F{green}terraform%f  - Create a Terraform project"
    print -P "  %F{green}gh%f         - Create a GitHub repository"
    return 1
  fi

  case "$project_type" in
    node)
      create-node-project "$project_name" "${args[@]}"
      ;;
    python)
      create-python-project "$project_name" "${args[@]}"
      ;;
    git)
      ginit "${args[0]:-main}"
      ;;
    docker)
      dcreate "Dockerfile"
      dccompose "docker-compose.yml"
      ;;
    terraform)
      tf-project "$project_name" "${args[@]}"
      ;;
    *)
      echo "Unknown project type: $project_type"
      return 1
      ;;
  esac
}

# Function to open project documentation
docs() {
  local project_type="$1"

  if [[ -z "$project_type" ]]; then
    echo "Usage: docs <technology>"
    echo "Available documentation:"
    echo "  node       - Node.js documentation"
    echo "  python     - Python documentation"
    echo "  git        - Git documentation"
    echo "  docker     - Docker documentation"
    echo "  k8s        - Kubernetes documentation"
    echo "  terraform  - Terraform documentation"
    echo "  aws        - AWS documentation"
    echo "  argocd     - ArgoCD documentation"
    echo "  helm       - Helm documentation"
    return 1
  fi

  case "$project_type" in
    node)
      open "https://nodejs.org/en/docs/"
      ;;
    python)
      open "https://docs.python.org/3/"
      ;;
    git)
      open "https://git-scm.com/doc"
      ;;
    docker)
      open "https://docs.docker.com/"
      ;;
    k8s|kubernetes)
      open "https://kubernetes.io/docs/"
      ;;
    terraform|tf)
      open "https://developer.hashicorp.com/terraform/docs"
      ;;
    aws)
      open "https://docs.aws.amazon.com/"
      ;;
    argocd|argo)
      open "https://argo-cd.readthedocs.io/"
      ;;
    helm)
      open "https://helm.sh/docs/"
      ;;
    *)
      echo "Unknown technology: $project_type"
      return 1
      ;;
  esac
}

# Path additions for development tools
path+=("$HOME/.local/bin")

# Check if we're in a Git repository
in-git-repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# Set up a simple development environment
dev-env() {
  local env_type="$1"

  case "$env_type" in
    node)
      echo "Setting up Node.js development environment..."
      # Create a new tmux session with split panes
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'npm run dev'
      tmux split-window -v 'git status'
      tmux attach-session -t dev
      ;;
    python)
      echo "Setting up Python development environment..."
      # Activate virtual environment if exists
      [[ -d .venv ]] && source .venv/bin/activate
      # Create a new tmux session with split panes
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'python main.py'
      tmux split-window -v 'git status'
      tmux attach-session -t dev
      ;;
    k8s|kubernetes)
      echo "Setting up Kubernetes development environment..."
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'kubectl get pods -w'
      tmux split-window -v 'stern .'
      tmux attach-session -t dev
      ;;
    terraform)
      echo "Setting up Terraform development environment..."
      tmux new-session -d -s dev 'nvim .'
      tmux split-window -h 'terraform plan'
      tmux split-window -v 'git status'
      tmux attach-session -t dev
      ;;
    *)
      echo "Unknown environment type: $env_type"
      echo "Available types: node, python, k8s, terraform"
      return 1
      ;;
  esac
}

# Quick status check for DevOps tools
devops-status() {
  echo "DevOps Tools Status"
  echo "==================="
  
  # Kubernetes
  if command -v kubectl &>/dev/null; then
    echo -n "Kubernetes: "
    kubectl config current-context 2>/dev/null || echo "not configured"
  else
    echo "Kubernetes: not installed"
  fi
  
  # Terraform
  if command -v terraform &>/dev/null; then
    echo -n "Terraform: "
    terraform version | head -1
  else
    echo "Terraform: not installed"
  fi
  
  # AWS
  if command -v aws &>/dev/null; then
    echo -n "AWS: "
    aws sts get-caller-identity --query 'Account' --output text 2>/dev/null || echo "not authenticated"
  else
    echo "AWS: not installed"
  fi
  
  # ArgoCD
  if command -v argocd &>/dev/null; then
    echo -n "ArgoCD: "
    argocd version --client --short 2>/dev/null || echo "installed"
  else
    echo "ArgoCD: not installed"
  fi
  
  # Helm
  if command -v helm &>/dev/null; then
    echo -n "Helm: "
    helm version --short 2>/dev/null
  else
    echo "Helm: not installed"
  fi
  
  # Docker
  if command -v docker &>/dev/null; then
    echo -n "Docker: "
    docker version --format '{{.Server.Version}}' 2>/dev/null || echo "not running"
  else
    echo "Docker: not installed"
  fi
}
