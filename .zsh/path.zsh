#!/usr/bin/env zsh
# ~/.zsh/path.zsh - Path configuration
#
# This file manages $PATH and related path variables.
# It follows macOS best practices for path configuration.
#

# Ensure path arrays don't contain duplicates
typeset -U PATH path

# Start with a minimal path to avoid duplicates
path=(
  # Homebrew paths (Apple Silicon first, then Intel for backwards compatibility)
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  /usr/local/sbin

  # User directories (higher priority than system)
  $HOME/.local/bin
  $HOME/bin
  $HOME/dotfiles/bin

  # Development tools managed by package managers
  $HOME/.cargo/bin                     # Rust/Cargo
  $HOME/.npm/bin                       # NPM global packages
  $HOME/.yarn/bin                      # Yarn global packages
  $HOME/.gem/ruby/bin                  # Ruby gems (user installed)
  $HOME/.deno/bin                      # Deno global packages
  $HOME/go/bin                         # Go packages
  $HOME/Library/Python/3.9/bin         # Python packages (adjust version as needed)
  $HOME/.local/share/JetBrains/Toolbox/scripts # JetBrains Toolbox

  # System directories (lowest priority, cleaned up to avoid redundancy)
  /usr/bin
  /bin
  /usr/sbin
  /sbin
)

# Remove any entries that don't exist
path=($^path(N))

# Export PATH for child processes
export PATH

# Configure MANPATH for manual pages
typeset -U MANPATH manpath
manpath=(
  /opt/homebrew/share/man
  /usr/local/share/man
  /usr/share/man
)
manpath=($^manpath(N))
export MANPATH

# Configure INFOPATH for info pages
typeset -U INFOPATH infopath
infopath=(
  /opt/homebrew/share/info
  /usr/local/share/info
  /usr/share/info
)
infopath=($^infopath(N))
export INFOPATH

# Configure CDPATH for quick directory changes
typeset -U CDPATH cdpath
cdpath=(
  $HOME
  $HOME/Documents
  $HOME/Documents/Projects  # New project location
  $HOME/Projects           # Legacy project location
  $HOME/Desktop
)
cdpath=($^cdpath(N))
export CDPATH

# Configure other path-related variables if needed
export GOPATH="$HOME/go"                 # Go workspace
export CARGO_HOME="$HOME/.cargo"         # Cargo/Rust workspace
export NPM_CONFIG_PREFIX="$HOME/.npm"    # NPM global packages
export COMPOSER_HOME="$HOME/.composer"   # PHP Composer

# Add homebrew's completion directory to fpath
if [[ -d "/opt/homebrew/share/zsh/site-functions" ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
elif [[ -d "/usr/local/share/zsh/site-functions" ]]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

# Add user's custom completions to fpath
[[ -d "$HOME/.zsh/completions" ]] && fpath=("$HOME/.zsh/completions" $fpath)

# Export fpath to ensure it's available to other scripts
export FPATH
