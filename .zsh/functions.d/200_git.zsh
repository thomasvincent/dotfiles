#!/usr/bin/env zsh
# Git utility functions

# Show git repository status in a compact format
gstat() {
  git status -sb
}

# Show git log with a pretty format
glog() {
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

# Enhanced git diff with line numbers and colors
gdiff() {
  git diff --color | nl -b a | less -R
}

# Create and checkout a new branch
gnew() {
  if [ -z "$1" ]; then
    echo "Usage: gnew <branch-name>"
    return 1
  fi
  git checkout -b "$1"
}

# Push branch to origin and set upstream
gpush() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  git push -u origin "$branch"
}

# List all branches sorted by last commit date
gbranches() {
  git for-each-ref --sort='-committerdate' --format='%(committerdate:short) %(refname:short)' refs/heads/
}

# Undo the last commit but keep the changes
gundo() {
  git reset --soft HEAD~1
  echo "Last commit undone, changes kept in working directory"
}

# Amend the last commit without changing the message
gamend() {
  git commit --amend --no-edit
}

# Squash the last N commits
gsquash() {
  if [ -z "$1" ] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Usage: gsquash <number-of-commits>"
    return 1
  fi
  
  git reset --soft HEAD~"$1" && git commit
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

# Delete branches that have been merged to main/master
gclean() {
  local main_branch="main"
  if ! git show-ref --verify --quiet refs/heads/main; then
    main_branch="master"
  fi
  
  echo "Deleting branches that have been merged to $main_branch..."
  git branch --merged "$main_branch" | grep -v "^\*" | grep -v "$main_branch" | xargs -n 1 git branch -d
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