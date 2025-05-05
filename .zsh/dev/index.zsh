#!/usr/bin/env zsh
# Developer environment configuration loader
# This file loads all development environment modules based on availability

DEV_MODULE_DIR="${0:h}"

# Function to source a file if it exists
source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

# Load core development tools
source_if_exists "$DEV_MODULE_DIR/git.zsh"

# Load language-specific configurations
# Core languages
source_if_exists "$DEV_MODULE_DIR/node.zsh"
source_if_exists "$DEV_MODULE_DIR/python.zsh"

# Container-related tools
source_if_exists "$DEV_MODULE_DIR/docker.zsh"

# Load cloud platform tools if available
source_if_exists "$DEV_MODULE_DIR/aws.zsh"
source_if_exists "$DEV_MODULE_DIR/gcp.zsh"
source_if_exists "$DEV_MODULE_DIR/azure.zsh"

# Load other tools
source_if_exists "$DEV_MODULE_DIR/database.zsh"
source_if_exists "$DEV_MODULE_DIR/kubernetes.zsh"
source_if_exists "$DEV_MODULE_DIR/terraform.zsh"

# Load local developer config if exists
source_if_exists "$DEV_MODULE_DIR/local.zsh"

# Create a universal project initializer
init-project() {
  local project_type="$1"
  local project_name="$2"
  local args=("${@:3}")
  
  if [[ -z "$project_type" || -z "$project_name" ]]; then
    echo "Usage: init-project <type> <name> [options]"
    echo "Available types:"
    echo "  node     - Create a Node.js project"
    echo "  python   - Create a Python project"
    echo "  git      - Initialize a Git repository"
    echo "  docker   - Create a Docker project"
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
    echo "  node     - Node.js documentation"
    echo "  python   - Python documentation"
    echo "  git      - Git documentation"
    echo "  docker   - Docker documentation"
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
    *)
      echo "Unknown environment type: $env_type"
      echo "Available types: node, python"
      return 1
      ;;
  esac
}