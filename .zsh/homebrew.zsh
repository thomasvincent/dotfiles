#!/usr/bin/env zsh
# Homebrew configuration and helpers

# Homebrew path setup
if [[ -x /opt/homebrew/bin/brew ]]; then
  # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  # Intel Mac
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Set Homebrew GitHub API token if it exists
if [[ -f "$HOME/.zsh/secrets.zsh" ]]; then
  source "$HOME/.zsh/secrets.zsh"
  if [[ -n "$HOMEBREW_GITHUB_API_TOKEN" ]]; then
    export HOMEBREW_GITHUB_API_TOKEN
  fi
fi

# Homebrew preferences
export HOMEBREW_NO_ANALYTICS=1       # Disable analytics
export HOMEBREW_NO_INSECURE_REDIRECT=1  # Prevent insecure redirects
export HOMEBREW_CASK_OPTS="--appdir=/Applications"  # Install apps to /Applications

# Skip Homebrew cleanup on install to save time
export HOMEBREW_NO_INSTALL_CLEANUP=1

# Allow installing multiple versions of packages
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# Homebrew update, upgrade, and cleanup
brewup() {
  echo "📦 Updating Homebrew..."
  brew update

  echo "📋 Checking outdated packages..."
  brew outdated

  echo -n "⬆️  Upgrade packages? [y/N] "
  read -q upgrade_response
  echo
  if [[ "$upgrade_response" =~ ^[Yy]$ ]]; then
    brew upgrade
  fi

  echo -n "🧹 Clean up old versions? [y/N] "
  read -q cleanup_response
  echo
  if [[ "$cleanup_response" =~ ^[Yy]$ ]]; then
    brew cleanup
  fi

  echo "✅ Homebrew update complete"
}

# Install packages from Brewfile
brewinstall() {
  local brewfile="${1:-$HOME/dotfiles/Brewfile}"
  
  if [[ ! -f "$brewfile" ]]; then
    echo "❌ Brewfile not found at $brewfile"
    return 1
  fi
  
  echo "🔄 Installing packages from $brewfile..."
  brew bundle install --file="$brewfile"
}

# Create a Brewfile from installed packages
brewdump() {
  local output="${1:-$HOME/dotfiles/Brewfile}"
  
  echo "📝 Creating Brewfile at $output..."
  brew bundle dump --file="$output" --force
  
  echo "✅ Brewfile created"
  echo "📋 Review the file to keep only what you need"
}

# Check for outdated packages and show notification (for use in scripts)
brewcheck() {
  local outdated=$(brew outdated)
  local count=$(echo "$outdated" | grep -v '^$' | wc -l | tr -d ' ')
  
  if [[ $count -gt 0 ]]; then
    echo "🆕 $count outdated Homebrew packages"
    echo "$outdated"
    return $count
  else
    echo "✅ All Homebrew packages up to date"
    return 0
  fi
}

# Doctor command
brewdoctor() {
  echo "🩺 Running Homebrew doctor..."
  brew doctor
}

# List leaves (packages not required by other packages)
brewleaves() {
  echo "🍃 Listing leaf packages (not dependencies)..."
  brew leaves
}

# Show dependency tree for a formula
brewdeps() {
  if [[ -z "$1" ]]; then
    echo "Usage: brewdeps <formula>"
    return 1
  fi
  
  echo "🔄 Showing dependencies for $1..."
  brew deps --tree --installed "$1"
}

# Show what depends on a formula
brewuses() {
  if [[ -z "$1" ]]; then
    echo "Usage: brewuses <formula>"
    return 1
  fi
  
  echo "🔄 Showing packages that depend on $1..."
  brew uses --installed "$1"
}

# Weekly Homebrew package update check
# Add to cron with: (crontab -l; echo "0 10 * * 1 zsh -c 'source ~/.zshrc && brew_weekly_check'") | crontab -
brew_weekly_check() {
  brew update >/dev/null 2>&1
  local outdated=$(brew outdated)
  local count=$(echo "$outdated" | grep -v '^$' | wc -l | tr -d ' ')
  
  if [[ $count -gt 0 ]]; then
    if command -v terminal-notifier >/dev/null 2>&1; then
      terminal-notifier -title "Homebrew" -message "$count outdated packages" -activate "com.apple.Terminal"
    else
      echo "🔄 $count outdated Homebrew packages"
    fi
  fi
}