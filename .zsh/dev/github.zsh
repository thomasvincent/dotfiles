#!/usr/bin/env zsh
# github.zsh - GitHub CLI and workflow configuration for macOS

# Ensure GitHub CLI is installed
if command -v gh >/dev/null; then
  # Load GitHub CLI completions
  if [[ ! -f "${ZDOTDIR:-$HOME}/.zsh/completions/_gh" ]]; then
    # Create completions directory if it doesn't exist
    mkdir -p "${ZDOTDIR:-$HOME}/.zsh/completions"
    print -P "%F{blue}Generating GitHub CLI completions...%f"
    gh completion -s zsh > "${ZDOTDIR:-$HOME}/.zsh/completions/_gh"
  fi

  # Add completions directory to fpath if not already added
  [[ -d "${ZDOTDIR:-$HOME}/.zsh/completions" ]] && fpath=("${ZDOTDIR:-$HOME}/.zsh/completions" $fpath)

  # GitHub CLI aliases
  alias ghv="gh repo view --web"  # Open current repo in browser
  alias ghi="gh issue list"        # List issues
  alias ghpr="gh pr list"          # List PRs
  alias ghs="gh status"            # Show status

  # Function to create a new GitHub repo from current directory
  gh-create() {
    emulate -L zsh
    setopt local_options err_return pipefail

    local visibility="${1:-private}"
    local description="${2:-}"
    local current_dir="${PWD##*/}"

    if [[ ! -d .git ]]; then
      print -P "%F{yellow}Initializing git repository...%f"
      git init -q
    fi

    if [[ -z "$(git remote -v 2>/dev/null)" ]]; then
      print -P "%F{blue}Creating GitHub repository: %F{green}$current_dir%f ($visibility)"

      if [[ -n "$description" ]]; then
        gh repo create "$current_dir" --"$visibility" --description "$description" --source=. --push
      else
        gh repo create "$current_dir" --"$visibility" --source=. --push
      fi

      print -P "%F{green}✓ Repository created and pushed%f"
    else
      print -P "%F{yellow}Repository already has remotes configured%f"
      git remote -v
    fi
  }

  # Function to create a PR with template
  gh-pr() {
    emulate -L zsh
    setopt local_options err_return pipefail

    local title="${1:?PR title required}"
    local base="${2:-main}"

    # Get current branch
    local branch="$(git rev-parse --abbrev-ref HEAD)"

    # Check if there are uncommitted changes
    if ! git diff-index --quiet HEAD --; then
      print -P "%F{yellow}You have uncommitted changes. Commit them first.%f"
      return 1
    fi

    # Push branch if needed
    if ! git ls-remote --exit-code --heads origin "$branch" &>/dev/null; then
      print -P "%F{blue}Pushing branch %F{green}$branch%f to origin...%f"
      git push -u origin "$branch"
    fi

    # Create PR
    print -P "%F{blue}Creating pull request: %F{green}$title%f"
    gh pr create --title "$title" --base "$base" --body "$(cat <<EOF
## Changes

<!-- Describe the changes you've made -->

## Testing

<!-- Describe how you've tested these changes -->

## Screenshots (if applicable)

<!-- Add screenshots if relevant -->
EOF
)"

    # Open PR in browser
    print -P "%F{green}✓ Pull request created%f"
    gh pr view --web
  }

  # Function to clone a GitHub repo with improved macOS defaults
  gh-clone() {
    emulate -L zsh
    setopt local_options err_return pipefail

    local repo="${1:?Repository required (user/repo or URL)}"
    local path="${2:-}"

    # Handle different repo formats
    if [[ "$repo" != */* && "$repo" != https://* ]]; then
      # If just a name is provided, use the current GitHub user
      local user=$(gh api user | jq -r .login)
      repo="$user/$repo"
    fi

    # Clean repo name if it's a URL
    if [[ "$repo" == https://* ]]; then
      repo=${repo#https://github.com/}
      repo=${repo%.git}
    fi

    print -P "%F{blue}Cloning GitHub repository: %F{green}$repo%f"

    # Clone with or without path
    if [[ -n "$path" ]]; then
      gh repo clone "$repo" "$path"
      cd "$path" || return
    else
      gh repo clone "$repo"
      # Extract repo name for cd
      local repo_name="${repo##*/}"
      cd "$repo_name" || return
    fi

    # Post-clone setup
    print -P "%F{blue}Setting up repository...%f"

    # Install dependencies if detected
    if [[ -f "package.json" ]]; then
      print -P "%F{blue}Node.js project detected, installing dependencies...%f"
      if [[ -f "yarn.lock" ]]; then
        yarn install
      else
        npm install
      fi
    elif [[ -f "Gemfile" ]]; then
      print -P "%F{blue}Ruby project detected, installing dependencies...%f"
      bundle install
    elif [[ -f "requirements.txt" ]]; then
      print -P "%F{blue}Python project detected, installing dependencies...%f"
      pip install -r requirements.txt
    elif [[ -f "go.mod" ]]; then
      print -P "%F{blue}Go project detected, downloading dependencies...%f"
      go mod download
    elif [[ -f "composer.json" ]]; then
      print -P "%F{blue}PHP project detected, installing dependencies...%f"
      composer install
    fi

    print -P "%F{green}✓ Repository cloned and set up: %F{blue}$repo%f"
  }
fi
