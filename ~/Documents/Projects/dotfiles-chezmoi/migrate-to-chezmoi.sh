#!/bin/bash
# migrate-to-chezmoi.sh - Migrate dotfiles to chezmoi with templating
#
# This script migrates the existing dotfiles to a chezmoi-managed setup
# with proper templating for cross-platform compatibility.

set -e

# Color definitions
RESET="\033[0m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BOLD="\033[1m"

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
CHEZMOI_CONFIG_DIR="$HOME/Documents/Projects/dotfiles-chezmoi"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo -e "${BLUE}${BOLD}Migrating dotfiles to chezmoi with templating${RESET}"
echo -e "${BLUE}===============================================${RESET}"

# Check if dotfiles exist
if [ ! -d "$DOTFILES_DIR" ]; then
  echo -e "${RED}Error: Dotfiles directory $DOTFILES_DIR not found!${RESET}"
  exit 1
fi

# Create backup of existing dotfiles
echo -e "${BLUE}Creating backup of existing dotfiles in $BACKUP_DIR...${RESET}"
mkdir -p "$BACKUP_DIR"
cp -r "$DOTFILES_DIR/." "$BACKUP_DIR/"
echo -e "${GREEN}✓ Backup completed${RESET}"

# Initialize chezmoi source repository
echo -e "${BLUE}Initializing chezmoi source repository...${RESET}"
chezmoi init --source="$CHEZMOI_CONFIG_DIR"
echo -e "${GREEN}✓ Chezmoi initialized with source at $CHEZMOI_CONFIG_DIR${RESET}"

# Copy configuration file to chezmoi
echo -e "${BLUE}Copying configuration file to chezmoi...${RESET}"
mkdir -p "$HOME/.config/chezmoi"
cp "$CHEZMOI_CONFIG_DIR/chezmoi.toml" "$HOME/.config/chezmoi/"
echo -e "${GREEN}✓ Configuration copied${RESET}"

# Add main dotfiles (converting to templates where appropriate)
echo -e "${BLUE}Adding main dotfiles to chezmoi...${RESET}"

# Convert .zshrc to template
echo -e "${BLUE}Converting .zshrc to template...${RESET}"
chezmoi add "$DOTFILES_DIR/.zshrc" --template
sed -i '' 's|/Users/thomasvincent|{{ .chezmoi.homeDir }}|g' "$CHEZMOI_CONFIG_DIR/dot_zshrc.tmpl"
echo -e "${GREEN}✓ Added .zshrc as template${RESET}"

# Add .zshenv as template
echo -e "${BLUE}Converting .zshenv to template...${RESET}"
chezmoi add "$DOTFILES_DIR/.zshenv" --template
sed -i '' 's|/Users/thomasvincent|{{ .chezmoi.homeDir }}|g' "$CHEZMOI_CONFIG_DIR/dot_zshenv.tmpl"
echo -e "${GREEN}✓ Added .zshenv as template${RESET}"

# Add .zprofile as template
echo -e "${BLUE}Converting .zprofile to template...${RESET}"
chezmoi add "$DOTFILES_DIR/.zprofile" --template
sed -i '' 's|/Users/thomasvincent|{{ .chezmoi.homeDir }}|g' "$CHEZMOI_CONFIG_DIR/dot_zprofile.tmpl"
echo -e "${GREEN}✓ Added .zprofile as template${RESET}"

# Add the .zsh directory structure
echo -e "${BLUE}Adding .zsh directory structure...${RESET}"
mkdir -p "$CHEZMOI_CONFIG_DIR/dot_zsh"

# Copy key ZSH files with templating
for file in aliases.zsh env.zsh path.zsh platform.zsh plugins.zsh completions.zsh themes.zsh performance.zsh; do
  echo -e "${BLUE}Converting $file to template...${RESET}"
  cp "$DOTFILES_DIR/.zsh/$file" "$CHEZMOI_CONFIG_DIR/dot_zsh/$file.tmpl"
  sed -i '' 's|/Users/thomasvincent|{{ .chezmoi.homeDir }}|g' "$CHEZMOI_CONFIG_DIR/dot_zsh/$file.tmpl"

  # Add platform-specific templating
  if [ "$file" = "platform.zsh" ]; then
    sed -i '' 's|PLATFORM="mac"|PLATFORM="{{ if .platform.is_macos }}mac{{ else if .platform.is_linux }}linux{{ else }}unknown{{ end }}"|g' "$CHEZMOI_CONFIG_DIR/dot_zsh/$file.tmpl"
  fi

  # Add homebrew-specific templating
  if [ "$file" = "homebrew.zsh" ]; then
    sed -i '' '/# Detect Homebrew path/,/fi/ c\
# Detect Homebrew path based on platform
{{ if .platform.is_macos -}}
if [[ -d "/opt/homebrew" ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d "/usr/local" ]]; then
  export HOMEBREW_PREFIX="/usr/local"
fi
{{- else if .platform.is_linux -}}
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
elif [[ -d "$HOME/.linuxbrew" ]]; then
  export HOMEBREW_PREFIX="$HOME/.linuxbrew"
fi
{{- end }}' "$CHEZMOI_CONFIG_DIR/dot_zsh/$file.tmpl"
  fi

  echo -e "${GREEN}✓ Added $file as template${RESET}"
done

# Create directory structure for functions.d
echo -e "${BLUE}Creating directory structure for functions.d...${RESET}"
mkdir -p "$CHEZMOI_CONFIG_DIR/dot_zsh/functions.d"
for func_file in "$DOTFILES_DIR/.zsh/functions.d/"*.zsh; do
  if [ -f "$func_file" ]; then
    base_name=$(basename "$func_file")
    echo -e "${BLUE}Converting $base_name to template...${RESET}"
    cp "$func_file" "$CHEZMOI_CONFIG_DIR/dot_zsh/functions.d/$base_name.tmpl"
    sed -i '' 's|/Users/thomasvincent|{{ .chezmoi.homeDir }}|g' "$CHEZMOI_CONFIG_DIR/dot_zsh/functions.d/$base_name.tmpl"
  fi
done
echo -e "${GREEN}✓ Added functions.d templates${RESET}"

# Add bin directory
echo -e "${BLUE}Adding bin directory...${RESET}"
mkdir -p "$CHEZMOI_CONFIG_DIR/bin"
for bin_file in "$DOTFILES_DIR/bin/"*; do
  if [ -f "$bin_file" ]; then
    base_name=$(basename "$bin_file")
    echo -e "${BLUE}Adding $base_name to bin...${RESET}"
    cp "$bin_file" "$CHEZMOI_CONFIG_DIR/bin/$base_name"
    chmod +x "$CHEZMOI_CONFIG_DIR/bin/$base_name"
  fi
done
echo -e "${GREEN}✓ Added bin directory${RESET}"

# Add Brewfile with templating
echo -e "${BLUE}Converting Brewfile to template...${RESET}"
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
  cp "$DOTFILES_DIR/Brewfile" "$CHEZMOI_CONFIG_DIR/Brewfile.tmpl"

  # Add conditional sections based on platform
  sed -i '' '1i\
{{ if .platform.is_macos -}}' "$CHEZMOI_CONFIG_DIR/Brewfile.tmpl"

  # Add Linux-specific section at the end
  echo '
{{- else if .platform.is_linux }}
# Linux-specific packages
brew "gcc"
brew "make"
brew "curl"
{{- end }}' >> "$CHEZMOI_CONFIG_DIR/Brewfile.tmpl"

  echo -e "${GREEN}✓ Added Brewfile as template${RESET}"
fi

# Create README for chezmoi source
echo -e "${BLUE}Creating README for chezmoi source...${RESET}"
cat > "$CHEZMOI_CONFIG_DIR/README.md" << 'EOL'
# Dotfiles (Managed with Chezmoi)

This repository contains my personal dotfiles, managed using [chezmoi](https://www.chezmoi.io/).

## Features

- Cross-platform support (macOS, Linux, WSL)
- Templating for different environments
- ZSH configuration with Powerlevel10k and Zinit
- Modern command-line tools and aliases
- Development environment configurations

## Setup

### Prerequisites

- [chezmoi](https://www.chezmoi.io/install/)
- git

### Installation

```bash
# Install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply thomasvincent
```

Or initialize from the local repository:

```bash
# Initialize from local source
chezmoi init ~/Documents/Projects/dotfiles-chezmoi
chezmoi apply
```

## Customization

The dotfiles use templates and conditional logic to adapt to different environments.
Modify the `~/.config/chezmoi/chezmoi.toml` file to customize your setup.

## License

MIT
EOL
echo -e "${GREEN}✓ Added README${RESET}"

# Create install script
echo -e "${BLUE}Creating install script...${RESET}"
cat > "$CHEZMOI_CONFIG_DIR/install.sh" << 'EOL'
#!/bin/bash
# Easy installer for chezmoi dotfiles

set -e

# Install chezmoi if it's not already installed
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)"
else
  echo "Chezmoi already installed!"
fi

# Initialize dotfiles
echo "Initializing dotfiles..."
chezmoi init --apply thomasvincent

echo "Dotfiles installed successfully!"
echo "You may need to restart your shell for all changes to take effect."
EOL
chmod +x "$CHEZMOI_CONFIG_DIR/install.sh"
echo -e "${GREEN}✓ Added install script${RESET}"

# Initialize a git repository
echo -e "${BLUE}Initializing git repository...${RESET}"
cd "$CHEZMOI_CONFIG_DIR"
git init
git add .
git commit -m "Initial commit: Migrated dotfiles to chezmoi with templating"
echo -e "${GREEN}✓ Git repository initialized${RESET}"

echo -e "${GREEN}${BOLD}Migration to chezmoi completed!${RESET}"
echo -e "${BLUE}Your dotfiles are now managed by chezmoi with proper templating.${RESET}"
echo -e "${BLUE}Source directory: $CHEZMOI_CONFIG_DIR${RESET}"
echo -e "${BLUE}To apply the changes to your system, run:${RESET}"
echo -e "${BOLD}chezmoi apply${RESET}"
