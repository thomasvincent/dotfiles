#!/usr/bin/env zsh
# Backup and synchronization utilities for dotfiles

# ====================================
# Backup Configuration
# ====================================
# Default locations
DOTFILES_BACKUP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/backups"
DOTFILES_REPO="$HOME/dotfiles"
DOTFILES_REMOTE=${DOTFILES_REMOTE:-"origin"}
DOTFILES_BRANCH=${DOTFILES_BRANCH:-"main"}

# Create backup directory if it doesn't exist
[[ -d "$DOTFILES_BACKUP_DIR" ]] || mkdir -p "$DOTFILES_BACKUP_DIR"

# ====================================
# Backup Functions
# ====================================

# Create a backup of dotfiles
dotfiles_backup() {
  local backup_name="dotfiles_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
  local backup_file="$DOTFILES_BACKUP_DIR/$backup_name"
  
  echo "Creating backup of dotfiles..."
  
  # Create backup directory if it doesn't exist
  mkdir -p "$DOTFILES_BACKUP_DIR"
  
  # Create tarball of dotfiles repo
  tar -czf "$backup_file" -C "$HOME" dotfiles
  
  echo "Backup created: $backup_file"
  
  # Optionally sync backup to cloud storage
  if [[ "$1" == "--sync" || "$1" == "-s" ]]; then
    dotfiles_backup_sync "$backup_file"
  fi
}

# Backup dotfiles to cloud storage
# Supports: iCloud, Dropbox, Google Drive
dotfiles_backup_sync() {
  local backup_file="$1"
  
  if [[ -z "$backup_file" ]]; then
    echo "Error: No backup file specified"
    return 1
  fi
  
  if [[ ! -f "$backup_file" ]]; then
    echo "Error: Backup file not found: $backup_file"
    return 1
  fi
  
  local backup_name=$(basename "$backup_file")
  local cloud_dir=""
  
  # Detect available cloud services
  if [[ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]]; then
    cloud_dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Dotfiles"
  elif [[ -d "$HOME/Dropbox" ]]; then
    cloud_dir="$HOME/Dropbox/Dotfiles"
  elif [[ -d "$HOME/Google Drive" ]]; then
    cloud_dir="$HOME/Google Drive/Dotfiles"
  elif [[ -d "$HOME/OneDrive" ]]; then
    cloud_dir="$HOME/OneDrive/Dotfiles"
  fi
  
  if [[ -z "$cloud_dir" ]]; then
    echo "No supported cloud storage found"
    return 1
  fi
  
  # Create cloud directory if it doesn't exist
  mkdir -p "$cloud_dir"
  
  # Copy backup to cloud storage
  cp "$backup_file" "$cloud_dir/"
  
  echo "Backup synced to: $cloud_dir/$backup_name"
}

# List available backups
dotfiles_backup_list() {
  echo "Available dotfiles backups:"
  echo "--------------------------"
  
  if [[ ! -d "$DOTFILES_BACKUP_DIR" ]]; then
    echo "No backups found"
    return 0
  fi
  
  local backups=$(ls -1 "$DOTFILES_BACKUP_DIR" | grep "^dotfiles_backup_.*\.tar\.gz$")
  
  if [[ -z "$backups" ]]; then
    echo "No backups found"
    return 0
  fi
  
  # Print backups with size and date
  echo "$backups" | while read backup; do
    local date_str=$(echo "$backup" | sed -E 's/dotfiles_backup_([0-9]{8})_([0-9]{6})\.tar\.gz/\1 \2/')
    local year=${date_str:0:4}
    local month=${date_str:4:2}
    local day=${date_str:6:2}
    local hour=${date_str:9:2}
    local minute=${date_str:11:2}
    local second=${date_str:13:2}
    
    local size=$(du -h "$DOTFILES_BACKUP_DIR/$backup" | cut -f1)
    
    printf "%-40s %8s    %s-%s-%s %s:%s:%s\n" "$backup" "$size" "$year" "$month" "$day" "$hour" "$minute" "$second"
  done
}

# Restore a backup
dotfiles_backup_restore() {
  local backup_name="$1"
  
  if [[ -z "$backup_name" ]]; then
    echo "Usage: dotfiles_backup_restore <backup_name>"
    echo "Available backups:"
    dotfiles_backup_list
    return 1
  fi
  
  local backup_file="$DOTFILES_BACKUP_DIR/$backup_name"
  
  if [[ ! -f "$backup_file" ]]; then
    echo "Error: Backup file not found: $backup_file"
    return 1
  fi
  
  # Check if dotfiles directory exists
  if [[ -d "$DOTFILES_REPO" ]]; then
    echo -n "Dotfiles directory already exists. Overwrite? (y/n) "
    read -q response
    echo
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
      echo "Restore canceled"
      return 1
    fi
    
    # Rename existing dotfiles directory
    local timestamp=$(date +%Y%m%d%H%M%S)
    mv "$DOTFILES_REPO" "${DOTFILES_REPO}.bak.$timestamp"
    echo "Existing dotfiles directory renamed to: ${DOTFILES_REPO}.bak.$timestamp"
  fi
  
  echo "Restoring dotfiles from backup: $backup_name"
  
  # Extract backup
  tar -xzf "$backup_file" -C "$HOME"
  
  echo "Dotfiles restored successfully"
  echo "Run the following command to apply the configuration:"
  echo "  cd ~/dotfiles && ./install.sh"
}

# Clean old backups
dotfiles_backup_clean() {
  local days="${1:-30}"
  
  echo "Cleaning backups older than $days days..."
  
  if [[ ! -d "$DOTFILES_BACKUP_DIR" ]]; then
    echo "No backups directory found"
    return 0
  fi
  
  # Find and remove old backups
  find "$DOTFILES_BACKUP_DIR" -name "dotfiles_backup_*.tar.gz" -mtime +$days -delete
  
  echo "Backup cleanup complete"
}

# ====================================
# Git Synchronization
# ====================================

# Sync dotfiles with Git repository
dotfiles_sync() {
  if [[ ! -d "$DOTFILES_REPO/.git" ]]; then
    echo "Error: $DOTFILES_REPO is not a git repository"
    return 1
  fi
  
  echo "Syncing dotfiles repository..."
  
  # Change to dotfiles directory
  cd "$DOTFILES_REPO" || return 1
  
  # Create backup before sync
  dotfiles_backup
  
  # Fetch changes from remote
  echo "Fetching updates from remote repository..."
  git fetch "$DOTFILES_REMOTE" "$DOTFILES_BRANCH"
  
  # Check for changes
  local changes=$(git rev-list HEAD..."$DOTFILES_REMOTE/$DOTFILES_BRANCH" --count)
  
  if [[ "$changes" -eq 0 ]]; then
    echo "Repository is already up to date"
    return 0
  fi
  
  echo "Found $changes new commit(s)"
  
  # Check for local changes
  if ! git diff-index --quiet HEAD --; then
    echo "Local changes detected in dotfiles repository"
    echo "Stashing changes before pull..."
    git stash save "Auto-stash before sync $(date)"
    local stashed=true
  fi
  
  # Pull changes
  echo "Pulling updates from remote repository..."
  if ! git pull --rebase "$DOTFILES_REMOTE" "$DOTFILES_BRANCH"; then
    echo "Error: Failed to pull updates"
    if [[ "$stashed" == true ]]; then
      echo "Restoring stashed changes..."
      git stash pop
    fi
    return 1
  fi
  
  # Apply stashed changes if any
  if [[ "$stashed" == true ]]; then
    echo "Applying stashed changes..."
    git stash pop
    
    # Check for conflicts
    if ! git diff-index --quiet HEAD --; then
      echo "Warning: There are conflicts after applying stashed changes"
      echo "Please resolve them manually"
    fi
  fi
  
  echo "Dotfiles repository updated successfully"
  
  # Run install script if it exists
  if [[ -x "$DOTFILES_REPO/install.sh" ]]; then
    echo -n "Run install script to apply changes? (y/n) "
    read -q response
    echo
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
      "$DOTFILES_REPO/install.sh"
    fi
  fi
}

# Push local changes to remote repository
dotfiles_push() {
  if [[ ! -d "$DOTFILES_REPO/.git" ]]; then
    echo "Error: $DOTFILES_REPO is not a git repository"
    return 1
  fi
  
  # Change to dotfiles directory
  cd "$DOTFILES_REPO" || return 1
  
  # Check for changes
  if git diff-index --quiet HEAD --; then
    echo "No local changes to push"
    return 0
  fi
  
  echo "Local changes detected. Creating commit..."
  
  # Prompt for commit message
  echo -n "Enter commit message (or press Enter for default): "
  read commit_message
  
  if [[ -z "$commit_message" ]]; then
    commit_message="Update dotfiles $(date +%Y-%m-%d)"
  fi
  
  # Stage all changes
  git add .
  
  # Create commit
  git commit -m "$commit_message"
  
  # Push to remote
  echo "Pushing changes to remote repository..."
  git push "$DOTFILES_REMOTE" "$DOTFILES_BRANCH"
  
  echo "Changes pushed successfully"
}

# Create a new machine-specific branch
dotfiles_setup_machine() {
  local machine_name="${1:-$(hostname)}"
  
  if [[ ! -d "$DOTFILES_REPO/.git" ]]; then
    echo "Error: $DOTFILES_REPO is not a git repository"
    return 1
  fi
  
  # Change to dotfiles directory
  cd "$DOTFILES_REPO" || return 1
  
  # Create a new branch for this machine
  local branch_name="machine/$machine_name"
  
  echo "Setting up machine-specific configuration on branch: $branch_name"
  
  # Check if branch already exists
  if git show-ref --verify --quiet "refs/heads/$branch_name"; then
    echo "Branch $branch_name already exists"
    git checkout "$branch_name"
  else
    # Create and checkout new branch
    git checkout -b "$branch_name"
    
    # Create machine-specific configuration files
    mkdir -p "$DOTFILES_REPO/.zsh/local"
    
    # Create local.zsh if it doesn't exist
    if [[ ! -f "$DOTFILES_REPO/.zsh/local/$machine_name.zsh" ]]; then
      cat > "$DOTFILES_REPO/.zsh/local/$machine_name.zsh" << EOL
# Machine-specific configuration for $machine_name
# This file is loaded from .zsh/local.zsh

# Machine-specific environment variables
export MACHINE_NAME="$machine_name"

# Machine-specific path additions
# path=(/path/to/machine/specific/bin \$path)

# Machine-specific aliases
# alias machine-cmd="command --with-args"

# Machine-specific functions
# machine_function() {
#   echo "This function is specific to $machine_name"
# }
EOL
    
      # Create symlink to load machine-specific config
      ln -sf "$DOTFILES_REPO/.zsh/local/$machine_name.zsh" "$DOTFILES_REPO/.zsh/local.zsh"
      
      # Commit changes
      git add .
      git commit -m "Add machine-specific configuration for $machine_name"
    fi
  fi
  
  echo "Machine-specific configuration set up successfully"
  echo "You can now make machine-specific changes to: $DOTFILES_REPO/.zsh/local/$machine_name.zsh"
}

# Clone a dotfiles repository from GitHub
dotfiles_clone() {
  local repo="${1:-thomasvincent/dotfiles}"
  local target_dir="${2:-$HOME/dotfiles}"
  
  # Check if target directory already exists
  if [[ -d "$target_dir" ]]; then
    echo "Target directory already exists: $target_dir"
    return 1
  fi
  
  # Clone repository
  echo "Cloning dotfiles repository from GitHub: $repo"
  git clone "https://github.com/$repo.git" "$target_dir"
  
  # Check if clone was successful
  if [[ $? -ne 0 ]]; then
    echo "Failed to clone repository"
    return 1
  fi
  
  echo "Dotfiles repository cloned successfully to: $target_dir"
  
  # Run install script if it exists
  if [[ -x "$target_dir/install.sh" ]]; then
    echo -n "Run install script to set up dotfiles? (y/n) "
    read -q response
    echo
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
      "$target_dir/install.sh"
    fi
  fi
}

# ====================================
# Dotfiles Management Commands
# ====================================

# Main dotfiles command
dotfiles_manager() {
  local command="$1"
  shift
  
  case "$command" in
    backup)
      dotfiles_backup "$@"
      ;;
    list-backups)
      dotfiles_backup_list
      ;;
    restore)
      dotfiles_backup_restore "$@"
      ;;
    clean)
      dotfiles_backup_clean "$@"
      ;;
    sync)
      dotfiles_sync
      ;;
    push)
      dotfiles_push
      ;;
    setup-machine)
      dotfiles_setup_machine "$@"
      ;;
    clone)
      dotfiles_clone "$@"
      ;;
    help|*)
      echo "Dotfiles Manager - Manage your dotfiles"
      echo ""
      echo "Usage: dotfiles <command> [args]"
      echo ""
      echo "Commands:"
      echo "  backup           Create a backup of your dotfiles"
      echo "  list-backups     List available backups"
      echo "  restore <file>   Restore a backup"
      echo "  clean [days]     Clean backups older than [days] (default: 30)"
      echo "  sync             Sync dotfiles with remote repository"
      echo "  push             Push local changes to remote repository"
      echo "  setup-machine    Set up machine-specific configuration"
      echo "  clone [repo]     Clone a dotfiles repository from GitHub"
      echo "  help             Show this help message"
      ;;
  esac
}

# Alias for dotfiles manager
alias dotfiles=dotfiles_manager