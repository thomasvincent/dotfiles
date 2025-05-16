#!/usr/bin/env zsh
# Git module - A consolidated module for Git functionality following DRY principles

# Load dependencies if needed
if [[ -f "${ZDOTDIR:-$HOME}/.zsh/lib/colors.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zsh/lib/colors.zsh"
fi

# ====================================
# 1. SECTION: BASIC GIT ALIASES
# ====================================
# Short aliases for common Git commands
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gst='git status -sb'  # Enhanced status (short format with branch info)
alias gcl='git clone'

# ====================================
# 2. SECTION: ADVANCED WORKFLOW FUNCTIONS
# ====================================

# Show git log with a pretty format
glog() {
  local count="${1:-15}"
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n "$count"
}

# Detailed git log with files changed
glogf() {
  local count="${1:-10}"
  git log --stat --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' -n "$count"
}

# Enhanced git diff with line numbers and colors
gdiff() {
  git diff --color "$@" | nl -b a | less -R
}

# Show diff with file names only
gdiffn() {
  git diff --name-only "$@"
}

# List all branches sorted by last commit date
gbranches() {
  git for-each-ref --sort='-committerdate' --format='%(committerdate:short) %(refname:short)' refs/heads/
}

# Show most recently modified branches
grecent() {
  local count=${1:-10}
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:relative) %(refname:short)' | head -n "$count"
}

# Show modified files in working directory
gmodified() {
  git ls-files --modified
}

# Show git stats (number of commits by author)
gstats() {
  git shortlog -sne
}

# ====================================
# 3. SECTION: BRANCH MANAGEMENT
# ====================================

# Create and checkout a new branch
gnew() {
  if [[ -z "$1" ]]; then
    echo "Usage: gnew <branch-name>"
    return 1
  fi
  git checkout -b "$1"
}

# Get the current branch name
gbranch() {
  git rev-parse --abbrev-ref HEAD
}

# Push branch to origin and set upstream
gpush() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  git push -u origin "$branch"
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

# Show branch tree
gtree() {
  git log --graph --oneline --all --decorate
}

# ====================================
# 4. SECTION: COMMIT OPERATIONS
# ====================================

# Add all changes
gaa() {
  git add -A
}

# Amend the last commit without changing the message
gamend() {
  git commit --amend --no-edit
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

# Squash the last N commits
gsquash() {
  if [[ -z "$1" ]] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Usage: gsquash <number-of-commits>"
    return 1
  fi
  
  git reset --soft HEAD~"$1" && git commit
}

# Find commits by commit message
gfind() {
  if [[ -z "$1" ]]; then
    echo "Usage: gfind <search-term>"
    return 1
  fi
  
  git log --oneline --grep="$1"
}

# ====================================
# 5. SECTION: STASH OPERATIONS
# ====================================

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

# Show all stashes with their contents
gstashes() {
  git stash list | while read -r stash; do
    local stash_num=$(echo "$stash" | cut -d: -f1)
    echo "=== $stash ==="
    git stash show -p "$stash_num"
    echo ""
  done
}

# ====================================
# 6. SECTION: REPOSITORY OPERATIONS
# ====================================

# Fetch all changes and prune references
gfetchall() {
  git fetch --all --prune
  echo "Fetched all changes and pruned references"
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
  if command -v pygmentize &>/dev/null; then
    git blame "$@" | pygmentize -l ruby 2>/dev/null
  else
    git blame "$@" 
  fi
}

# ====================================
# 7. SECTION: PROJECT SETUP
# ====================================

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

# ====================================
# 8. SECTION: HELPERS & DOCUMENTATION
# ====================================

# Print documentation for all git functions
ghelp() {
  cat << 'HELP'
Git Functions:

-- Basic Aliases --
g       : git
ga      : git add
gb      : git branch
gc      : git commit
gco     : git checkout
gd      : git diff
gl      : git log
gp      : git push
gpl     : git pull
gs, gst : git status -sb

-- Advanced Workflow --
glog [n]     : Pretty git log with last n entries
glogf [n]    : Detailed git log with files changed
gdiff        : Git diff with line numbers
gdiffn       : Git diff with file names only
gbranches    : List branches by date
grecent [n]  : Show n most recent branches
gmodified    : Show modified files
gstats       : Show contributor statistics

-- Branch Management --
gnew <name>  : Create & checkout new branch
gbranch      : Print current branch name
gpush        : Push & track current branch
gclean       : Delete merged branches
gtree        : Show branch tree graph

-- Commit Operations --
gaa          : Add all changes
gamend       : Amend last commit
gundo        : Undo last commit but keep changes
grebase [n]  : Interactive rebase last n commits
gsquash <n>  : Squash last n commits
gfind <term> : Find commits by message

-- Stash Operations --
gstash [desc]       : Create named stash
gstashview [n]      : View stash without applying
gstashes            : Show all stashes with contents

-- Repository Operations --
gfetchall     : Fetch all changes and prune
ghuburl       : Show GitHub repository URL
gblame <file> : Colorful git blame

-- Project Setup --
ginit [branch] : Initialize new repository
gpr [branch]   : Create GitHub PR to target branch
HELP
}

# Create a quick temporary commit (useful for work in progress)
gwip() {
  local message="${1:-WIP: Work in progress}"
  git add -A && git commit -m "$message"
  echo "Created WIP commit: $message"
}