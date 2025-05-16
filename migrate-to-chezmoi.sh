#!/bin/bash
set -euo pipefail

echo "Setting up chezmoi for dotfiles management..."

# Check if chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
    echo "Installing chezmoi..."
    if command -v brew &> /dev/null; then
        brew install chezmoi
    else
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi

# Initialize chezmoi with the existing dotfiles
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEZMOI_SOURCE_DIR="${DOTFILES_DIR}/home"

echo "Creating chezmoi source directory structure..."
mkdir -p "${CHEZMOI_SOURCE_DIR}"

# Function to convert a file to chezmoi format
convert_to_chezmoi_template() {
    local file=$1
    local base_name
    base_name=$(basename "$file")
    local target_path="${CHEZMOI_SOURCE_DIR}/dot_${base_name}"

    # If it's a directory, handle differently
    if [ -d "$file" ]; then
        target_path="${CHEZMOI_SOURCE_DIR}/dot_${base_name}"
        mkdir -p "$target_path"

        # Copy contents
        cp -R "$file"/* "$target_path"/ 2>/dev/null || true

        # Convert subdirectories
        find "$file" -type d -not -path "$file" | while read -r subdir; do
            local rel_path
            rel_path="${subdir#$file/}"
            mkdir -p "${target_path}/${rel_path}"
        done

        # Process files in the directory
        find "$file" -type f | while read -r subfile; do
            local rel_path
            rel_path="${subfile#$file/}"
            cp "$subfile" "${target_path}/${rel_path}"
        done
    else
        # Regular file
        cp "$file" "$target_path"
    fi

    echo "Converted: $file → $target_path"
}

# Files to convert
dotfiles=(
    "${DOTFILES_DIR}/.zshrc"
    "${DOTFILES_DIR}/.zprofile"
    "${DOTFILES_DIR}/.zshenv"
    "${DOTFILES_DIR}/.gitconfig"
    "${DOTFILES_DIR}/.config"
    "${DOTFILES_DIR}/.zsh"
)

# Convert each dotfile
for file in "${dotfiles[@]}"; do
    if [ -e "$file" ]; then
        convert_to_chezmoi_template "$file"
    fi
done

# Create executable template files if needed
executable_files=(
    "${DOTFILES_DIR}/bin"
)

# Function to convert executable files
convert_executable() {
    local file=$1
    local base_name
    base_name=$(basename "$file")
    local target_path

    if [ -d "$file" ]; then
        target_path="${CHEZMOI_SOURCE_DIR}/executable_dot_${base_name}"
        mkdir -p "$target_path"
        cp -R "$file"/* "$target_path"/ 2>/dev/null || true
    else
        target_path="${CHEZMOI_SOURCE_DIR}/executable_dot_${base_name}"
        cp "$file" "$target_path"
    fi
    echo "Converted executable: $file → $target_path"
}

for file in "${executable_files[@]}"; do
    if [ -e "$file" ]; then
        convert_executable "$file"
    fi
done

# Create templated files
echo "Creating templated files..."

cat > "${CHEZMOI_SOURCE_DIR}/dot_gitconfig.tmpl" << 'EOF'
[user]
    name = {{ .name }}
    email = {{ .email }}
[github]
    user = {{ .github_username }}
[core]
    editor = code --wait
    excludesfile = ~/.gitignore
    autocrlf = input
[init]
    defaultBranch = main
[pull]
    rebase = true
[push]
    default = current
    autoSetupRemote = true
[fetch]
    prune = true
[alias]
    st = status
    ci = commit
    br = branch
    co = checkout
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    uncommit = reset --soft HEAD^
    unstage = reset HEAD --
    last = log -1 HEAD
[color]
    ui = auto
[diff]
    tool = vscode
[difftool "vscode"]
    cmd = code --wait --diff $LOCAL $REMOTE
[merge]
    tool = vscode
[mergetool "vscode"]
    cmd = code --wait $MERGED
EOF

cat > "${CHEZMOI_SOURCE_DIR}/dot_zshrc.tmpl" << 'EOF'
# .zshrc - ZSH configuration file
# Managed by chezmoi - DO NOT EDIT DIRECTLY

# User Information
export NAME="{{ .name }}"
export EMAIL="{{ .email }}"
export GITHUB_USERNAME="{{ .github_username }}"

# Source all ZSH configuration files
for file in ~/.zsh/*.zsh; do
    source "$file"
done

# Load platform-specific configurations
source ~/.zsh/platform.zsh

# Source local configuration if it exists
[[ -f ~/.zsh/local.zsh ]] && source ~/.zsh/local.zsh
EOF

# Copy chezmoi.toml to the right location
echo "Setting up chezmoi configuration..."
mkdir -p "$HOME/.config/chezmoi"
cp "${DOTFILES_DIR}/chezmoi.toml" "$HOME/.config/chezmoi/chezmoi.toml"

echo "Migration to chezmoi complete!"
echo "Dotfiles are now in chezmoi format in: ${CHEZMOI_SOURCE_DIR}"
echo ""
echo "Next steps:"
echo "1. Review the migrated files in ${CHEZMOI_SOURCE_DIR}"
echo "2. Initialize chezmoi with: chezmoi init ${DOTFILES_DIR}"
echo "3. Apply the dotfiles with: chezmoi apply -v"
echo ""
echo "For future use:"
echo "  - chezmoi edit <file>  : Edit a dotfile"
echo "  - chezmoi apply        : Apply changes"
echo "  - chezmoi update       : Pull and apply the latest changes"
echo "  - chezmoi cd           : Go to the source directory"
