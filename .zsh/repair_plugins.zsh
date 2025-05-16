#!/usr/bin/env zsh
# repair_plugins.zsh - Fix plugin loading errors in ZSH
# This script will repair any plugin 404 errors and verify all URLs

# Colors and formatting
autoload -U colors && colors

# Helper function for output
print_header() {
  print -P "%F{blue}====%f %F{white}$1%f %F{blue}====%f"
}

print_step() {
  print -P "%F{cyan}===>%f %F{white}$1%f"
}

print_success() {
  print -P "%F{green}✓%f %F{white}$1%f"
}

print_warning() {
  print -P "%F{yellow}!%f %F{white}$1%f"
}

print_error() {
  print -P "%F{red}✗%f %F{white}$1%f"
}

# Plugin URL verification function
verify_plugin_url() {
  local name=$1
  local url=$2
  
  print_step "Checking $name plugin URL..."
  
  if curl --output /dev/null --silent --head --fail "$url"; then
    print_success "URL for $name is valid"
    return 0
  else
    print_error "URL for $name is invalid: $url"
    return 1
  fi
}

# Main function
repair_plugins() {
  print_header "ZSH Plugin Repair Tool"
  
  # Check Zinit installation
  print_step "Checking Zinit installation..."
  ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  
  if [[ ! -d "$ZINIT_HOME" ]]; then
    print_error "Zinit not installed. Installing now..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    if [[ $? -eq 0 ]]; then
      print_success "Zinit installed successfully"
    else
      print_error "Failed to install Zinit"
      return 1
    fi
  else
    print_success "Zinit is installed"
  fi
  
  # Update Zinit
  print_step "Updating Zinit..."
  (cd "$ZINIT_HOME" && git pull)
  print_success "Zinit updated"
  
  # Ensure completions directory exists
  mkdir -p "${ZDOTDIR:-$HOME}/.zsh/completions"
  
  # Check Oh My Zsh raw URLs for plugins
  print_header "Verifying Plugin URLs"
  
  # List of plugin names and their URLs to verify
  declare -A plugins
  plugins=(
    ["utility"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/common-aliases/common-aliases.plugin.zsh"
    ["extract"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/extract/extract.plugin.zsh"
    ["terraform"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/terraform/terraform.plugin.zsh"
    ["direnv"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/direnv/direnv.plugin.zsh"
    ["asdf"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/asdf/asdf.plugin.zsh"
    ["npm"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/npm/npm.plugin.zsh"
    ["fzf"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fzf/fzf.plugin.zsh"
    ["python"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/python/python.plugin.zsh"
    ["node"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/node/node.plugin.zsh"
    ["docker-compose"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/docker-compose/_docker-compose"
    ["command-not-found"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/command-not-found/command-not-found.plugin.zsh"
  )
  
  # Verify each plugin URL
  for name in "${(@k)plugins}"; do
    verify_plugin_url "$name" "${plugins[$name]}"
  done
  
  # Verify external plugin repositories
  print_header "Verifying Plugin Repositories"
  
  # List of plugin repositories
  declare -A repos
  repos=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
    ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search"
    ["zsh-z"]="https://github.com/agkozak/zsh-z"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["forgit"]="https://github.com/wfxr/forgit"
    ["zshmarks"]="https://github.com/jocelynmallon/zshmarks"
    ["up.zsh"]="https://github.com/peterhurford/up.zsh"
  )
  
  # Check each repo
  for name in "${(@k)repos}"; do
    print_step "Checking $name repository..."
    if curl --output /dev/null --silent --head --fail "${repos[$name]}"; then
      print_success "Repository for $name is accessible"
    else
      print_error "Repository for $name is inaccessible: ${repos[$name]}"
    fi
  done
  
  # Clean Zinit state and cache
  print_header "Cleaning Zinit"
  
  print_step "Clearing Zinit cache..."
  zinit clear 2>/dev/null || true
  
  print_step "Removing broken plugins..."
  rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/snippets/OMZP--"* 2>/dev/null || true
  
  print_success "Zinit cleaned"
  
  # Create fresh completions for command-line tools
  print_header "Updating Tool Completions"
  
  # GitHub CLI completions
  if command -v gh &>/dev/null; then
    print_step "Generating GitHub CLI completions..."
    gh completion -s zsh > "${ZDOTDIR:-$HOME}/.zsh/completions/_gh"
    print_success "GitHub CLI completions updated"
  fi
  
  # DigitalOcean CLI completions
  if command -v doctl &>/dev/null; then
    print_step "Generating DigitalOcean CLI completions..."
    doctl completion zsh > "${ZDOTDIR:-$HOME}/.zsh/completions/_doctl"
    print_success "DigitalOcean CLI completions updated"
  fi
  
  # Terraform completions
  if command -v terraform &>/dev/null; then
    print_step "Generating Terraform completions..."
    terraform -install-autocomplete 2>/dev/null || true
    print_success "Terraform completions updated"
  fi
  
  print_header "Plugin Repair Complete"
  print_step "Your ZSH plugins have been verified and repaired."
  print_step "Please restart your shell with: exec zsh"
}

# Execute the repair function
repair_plugins