#!/usr/bin/env zsh
# =============================================================================
# Git Extended Workflows
# =============================================================================
#
# File: ~/.zsh/dev/git-extras.zsh
# Purpose: Advanced Git workflows and productivity functions
# Dependencies: git, gh (GitHub CLI), fzf (optional)
#
# These functions go beyond simple aliases to provide:
#   - Interactive branch management
#   - Conventional commit helpers
#   - PR workflow automation
#   - Repository statistics
#
# =============================================================================

# =============================================================================
# BRANCH MANAGEMENT
# =============================================================================

# -----------------------------------------------------------------------------
# git-branch-clean: Delete merged branches
# -----------------------------------------------------------------------------
#
# Removes local branches that have been merged into main/master.
# Keeps main, master, develop, and current branch.
#
# Usage:
#   git-branch-clean           # Dry run (show what would be deleted)
#   git-branch-clean --force   # Actually delete
#
# -----------------------------------------------------------------------------
git-branch-clean() {
  local force="${1:-}"
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
  main_branch=${main_branch:-main}
  
  echo "🌿 Branches merged into $main_branch:"
  
  local branches=$(git branch --merged "$main_branch" | grep -vE "^\*|^\s*(main|master|develop)$")
  
  if [[ -z "$branches" ]]; then
    echo "   No merged branches to clean up."
    return 0
  fi
  
  echo "$branches" | while read branch; do
    echo "   $branch"
  done
  
  if [[ "$force" == "--force" ]]; then
    echo ""
    echo "🗑️  Deleting merged branches..."
    echo "$branches" | xargs git branch -d
    echo "✅ Done!"
  else
    echo ""
    echo "Run with --force to delete these branches."
  fi
}

# -----------------------------------------------------------------------------
# git-branch-select: Interactive branch checkout with fzf
# -----------------------------------------------------------------------------
git-branch-select() {
  if ! command -v fzf &>/dev/null; then
    echo "fzf not installed. Use: git checkout <branch>"
    git branch -a
    return 1
  fi
  
  local branch
  branch=$(git branch -a | fzf --height 40% --prompt="Checkout branch: " | sed 's/^\*//' | xargs)
  
  if [[ -n "$branch" ]]; then
    # Handle remote branches
    if [[ "$branch" == remotes/origin/* ]]; then
      branch=${branch#remotes/origin/}
    fi
    git checkout "$branch"
  fi
}
alias gbs='git-branch-select'

# =============================================================================
# CONVENTIONAL COMMITS
# =============================================================================
#
# Helpers for writing conventional commit messages:
#   feat: New feature
#   fix: Bug fix
#   docs: Documentation
#   style: Formatting
#   refactor: Code restructuring
#   test: Tests
#   chore: Maintenance
#
# =============================================================================

# -----------------------------------------------------------------------------
# git-commit-feat: Commit a new feature
# -----------------------------------------------------------------------------
git-commit-feat() {
  local scope="$1"
  local message="$2"
  
  if [[ -z "$message" ]]; then
    # No scope provided, first arg is message
    message="$scope"
    git commit -m "feat: $message"
  else
    git commit -m "feat($scope): $message"
  fi
}
alias gcf='git-commit-feat'

# -----------------------------------------------------------------------------
# git-commit-fix: Commit a bug fix
# -----------------------------------------------------------------------------
git-commit-fix() {
  local scope="$1"
  local message="$2"
  
  if [[ -z "$message" ]]; then
    message="$scope"
    git commit -m "fix: $message"
  else
    git commit -m "fix($scope): $message"
  fi
}
alias gcx='git-commit-fix'

# -----------------------------------------------------------------------------
# git-commit-docs: Commit documentation changes
# -----------------------------------------------------------------------------
git-commit-docs() {
  git commit -m "docs: $*"
}
alias gcd='git-commit-docs'

# -----------------------------------------------------------------------------
# git-commit-chore: Commit maintenance changes
# -----------------------------------------------------------------------------
git-commit-chore() {
  git commit -m "chore: $*"
}
alias gcc='git-commit-chore'

# -----------------------------------------------------------------------------
# git-commit-interactive: Interactive conventional commit
# -----------------------------------------------------------------------------
git-commit-interactive() {
  local types=("feat" "fix" "docs" "style" "refactor" "test" "chore" "build" "ci" "perf")
  
  echo "Select commit type:"
  select type in "${types[@]}"; do
    if [[ -n "$type" ]]; then
      break
    fi
  done
  
  echo -n "Scope (optional, press Enter to skip): "
  read scope
  
  echo -n "Message: "
  read message
  
  if [[ -n "$scope" ]]; then
    git commit -m "$type($scope): $message"
  else
    git commit -m "$type: $message"
  fi
}
alias gci='git-commit-interactive'

# =============================================================================
# GITHUB PR WORKFLOWS
# =============================================================================

# -----------------------------------------------------------------------------
# git-pr-create: Create a PR with template
# -----------------------------------------------------------------------------
#
# Creates a PR from current branch to main/master.
# Opens editor for description.
#
# Usage:
#   git-pr-create "Add user authentication"
#   git-pr-create "Fix login bug" --draft
#
# -----------------------------------------------------------------------------
git-pr-create() {
  local title="$1"
  shift
  local args="$@"
  
  if [[ -z "$title" ]]; then
    echo "Usage: git-pr-create <title> [--draft]"
    return 1
  fi
  
  # Push current branch
  local branch=$(git branch --show-current)
  echo "📤 Pushing $branch to origin..."
  git push -u origin "$branch"
  
  # Create PR
  echo "🔀 Creating pull request..."
  gh pr create --title "$title" $args
}
alias gpr='git-pr-create'

# -----------------------------------------------------------------------------
# git-pr-checkout: Checkout a PR by number
# -----------------------------------------------------------------------------
git-pr-checkout() {
  local pr_number="$1"
  
  if [[ -z "$pr_number" ]]; then
    # Interactive selection
    if command -v fzf &>/dev/null; then
      pr_number=$(gh pr list | fzf --height 40% | awk '{print $1}')
    else
      echo "Usage: git-pr-checkout <pr-number>"
      gh pr list
      return 1
    fi
  fi
  
  if [[ -n "$pr_number" ]]; then
    gh pr checkout "$pr_number"
  fi
}
alias gprc='git-pr-checkout'

# =============================================================================
# REPOSITORY STATISTICS
# =============================================================================

# -----------------------------------------------------------------------------
# git-stats: Show repository statistics
# -----------------------------------------------------------------------------
git-stats() {
  echo "📊 Repository Statistics"
  echo "========================"
  echo ""
  
  echo "📁 Repository: $(basename $(git rev-parse --show-toplevel))"
  echo "🌿 Current branch: $(git branch --show-current)"
  echo "📝 Total commits: $(git rev-list --count HEAD)"
  echo "👥 Contributors: $(git shortlog -sn | wc -l | xargs)"
  echo ""
  
  echo "Top 5 contributors:"
  git shortlog -sn --no-merges | head -5
  echo ""
  
  echo "Recent activity (last 7 days):"
  git log --oneline --since='7 days ago' | wc -l | xargs echo "  Commits:"
}

# -----------------------------------------------------------------------------
# git-standup: Show what you worked on recently
# -----------------------------------------------------------------------------
#
# Great for daily standups - shows your commits from yesterday/today.
#
# Usage:
#   git-standup              # Your commits from last working day
#   git-standup 3            # Last 3 days
#   git-standup 7 all        # Last 7 days, all authors
#
# -----------------------------------------------------------------------------
git-standup() {
  local days="${1:-1}"
  local author="${2:-$(git config user.email)}"
  
  if [[ "$2" == "all" ]]; then
    author=""
  fi
  
  echo "📋 Work from the last $days day(s):"
  echo ""
  
  if [[ -n "$author" ]]; then
    git log --oneline --since="$days days ago" --author="$author"
  else
    git log --oneline --since="$days days ago"
  fi
}

# -----------------------------------------------------------------------------
# git-fame: Show contributor statistics
# -----------------------------------------------------------------------------
git-fame() {
  echo "🏆 Contributor Fame"
  echo "==================="
  echo ""
  git shortlog -sn --all | head -20
}

# =============================================================================
# WORKFLOW HELPERS
# =============================================================================

# -----------------------------------------------------------------------------
# git-sync: Sync current branch with remote main
# -----------------------------------------------------------------------------
#
# Fetches latest main and rebases current branch onto it.
#
# -----------------------------------------------------------------------------
git-sync() {
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
  main_branch=${main_branch:-main}
  local current_branch=$(git branch --show-current)
  
  echo "🔄 Syncing $current_branch with $main_branch..."
  
  git fetch origin "$main_branch"
  git rebase "origin/$main_branch"
  
  echo "✅ $current_branch is now up to date with $main_branch"
}

# -----------------------------------------------------------------------------
# git-undo: Undo last commit (keep changes)
# -----------------------------------------------------------------------------
git-undo() {
  git reset --soft HEAD~1
  echo "↩️  Undid last commit. Changes are staged."
}

# -----------------------------------------------------------------------------
# git-amend: Quick amend without editing message
# -----------------------------------------------------------------------------
git-amend() {
  git commit --amend --no-edit
  echo "📝 Amended last commit."
}

# -----------------------------------------------------------------------------
# git-wip: Quick work-in-progress commit
# -----------------------------------------------------------------------------
git-wip() {
  git add -A
  git commit -m "WIP: $*"
  echo "💾 Created WIP commit."
}

# -----------------------------------------------------------------------------
# git-unwip: Undo a WIP commit
# -----------------------------------------------------------------------------
git-unwip() {
  if git log -1 --pretty=%B | grep -q "^WIP:"; then
    git reset HEAD~1
    echo "↩️  Undid WIP commit. Changes are unstaged."
  else
    echo "Last commit is not a WIP commit."
  fi
}
