#!/usr/bin/env zsh
# Git development environment setup and enhanced functions

# === Git Aliases and Functions ===

# Enhanced git status
gst() {
  git status -sb
}

# Interactive add with patch
gaa() {
  git add -A
}

# Amend the last commit without changing message
gamend() {
  git commit --amend --no-edit
}

# Create a new branch and switch to it
gnew() {
  if [[ -z "$1" ]]; then
    echo "Usage: gnew <branch-name>"
    return 1
  fi
  
  git checkout -b "$1"
}

# Push a new branch to origin and set tracking
gpush() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  git push -u origin "$branch"
}

# Get the current branch name
gbranch() {
  git rev-parse --abbrev-ref HEAD
}

# Find commits by commit message
gfind() {
  if [[ -z "$1" ]]; then
    echo "Usage: gfind <search-term>"
    return 1
  fi
  
  git log --oneline --grep="$1"
}

# Enhanced git log
glog() {
  local count="${1:-15}"
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n "$count"
}

# Detailed git log with files changed
glogf() {
  local count="${1:-10}"
  git log --stat --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' -n "$count"
}

# Clean up local branches that have been merged to main/master
gclean() {
  local main_branch="main"
  if ! git show-ref --verify --quiet refs/heads/main; then
    main_branch="master"
  fi
  
  echo "Deleting branches that have been merged to $main_branch..."
  git branch --merged "$main_branch" | grep -v "^\*" | grep -v "$main_branch" | xargs -n 1 git branch -d
  echo "Done"
}

# Undo last commit but keep changes
gundo() {
  git reset --soft HEAD~1
  echo "Last commit undone, changes kept in working directory"
}

# Interactive rebase
grebase() {
  local count="${1:-5}"
  git rebase -i HEAD~"$count"
}

# Show all stashes with their contents
gstashes() {
  git stash list | while read -r stash; do
    local stash_num=$(echo "$stash" | cut -d: -f1)
    echo "=== $stash ==="
    git stash show -p "$stash_num"
    echo ""
  done
}

# Fetch all changes and prune references
gfetchall() {
  git fetch --all --prune
  echo "Fetched all changes and pruned references"
}

# Squash the last N commits
gsquash() {
  if [[ -z "$1" ]] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Usage: gsquash <number-of-commits>"
    return 1
  fi
  
  git reset --soft HEAD~"$1" && git commit
}

# Show diff with file names only
gdiffn() {
  git diff --name-only "$@"
}

# Show modified files in working directory
gmodified() {
  git ls-files --modified
}

# Show git stats (number of commits by author)
gstats() {
  git shortlog -sne
}

# Show most recently modified branches
grecent() {
  local count=${1:-10}
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:relative) %(refname:short)' | head -n "$count"
}

# Create a temporary stash that can be easily identified
gstash() {
  local desc="${1:-$(date +%Y%m%d-%H%M%S)}"
  git stash push -m "temp-stash-$desc"
}

# View a stash's changes without applying it
gstashview() {
  local stash="${1:-0}"
  git stash show -p "stash@{$stash}"
}

# Display a repository's GitHub URL
ghuburl() {
  local remote_url=$(git config --get remote.origin.url)
  
  if [[ "$remote_url" == *"github.com"* ]]; then
    if [[ "$remote_url" == git@* ]]; then
      echo "$remote_url" | sed -E 's/git@github.com:(.+)\.git/https:\/\/github.com\/\1/'
    else
      echo "$remote_url" | sed -E 's/https:\/\/github.com\/(.+)\.git/https:\/\/github.com\/\1/'
    fi
  else
    echo "Not a GitHub repository: $remote_url"
  fi
}

# Colorful git blame
gblame() {
  git blame "$@" | pygmentize -l ruby 2>/dev/null || git blame "$@"
}

# Initialize a new git repository with sensible defaults
ginit() {
  local branch_name="${1:-main}"
  
  git init
  
  # Set default branch name
  git checkout -b "$branch_name"
  
  # Create a basic .gitignore
  cat > .gitignore << 'EOF'
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
Desktop.ini

# Editor directories and files
.idea/
.vscode/
*.sublime-project
*.sublime-workspace
*.swp
*.swo
*~

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Dependency directories
node_modules/
vendor/
.venv/
venv/
ENV/
env/
EOF
  
  # Create a README
  cat > README.md << EOF
# Project Name

Description of your project.

## Installation

Instructions for installing the project.

## Usage

Instructions for using the project.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
EOF
  
  # Create initial commit
  git add .
  git commit -m "Initial commit"
  
  echo "Git repository initialized with $branch_name branch"
}

# Create a GitHub PR from the current branch
gpr() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local target_branch="${1:-main}"
  
  # Check if gh CLI is installed
  if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Install it first."
    return 1
  fi
  
  # Ensure we're working with latest
  git fetch origin "$target_branch"
  
  # Check if there are any differences
  if git diff --quiet "origin/$target_branch" "$current_branch"; then
    echo "No differences between $current_branch and origin/$target_branch"
    return 1
  fi
  
  # Create PR
  gh pr create --base "$target_branch" --head "$current_branch"
}

# Show branch tree
gtree() {
  git log --graph --oneline --all --decorate
}