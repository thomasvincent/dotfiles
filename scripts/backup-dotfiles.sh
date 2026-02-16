#!/bin/bash
# =============================================================================
# Dotfiles Backup Script
# =============================================================================
#
# Creates a timestamped backup of important configuration files.
# Useful before making major changes or before system updates.
#
# Usage:
#   ./scripts/backup-dotfiles.sh
#   ./scripts/backup-dotfiles.sh /custom/backup/path
#
# =============================================================================

set -e

# Configuration
BACKUP_BASE="${1:-$HOME/dotfiles-backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$BACKUP_BASE/backup_$TIMESTAMP"

# Files and directories to backup
FILES_TO_BACKUP=(
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.zprofile"
    "$HOME/.zsh"
    "$HOME/.gitconfig"
    "$HOME/.gitignore_global"
    "$HOME/.ssh/config"
    "$HOME/.config/chezmoi"
    "$HOME/.p10k.zsh"
    "$HOME/.tmux.conf"
    "$HOME/.vimrc"
    "$HOME/.config/nvim"
    "$HOME/.aws/config"
    "$HOME/.kube/config"
)

echo "📦 Dotfiles Backup Script"
echo "========================="
echo ""
echo "Backup location: $BACKUP_DIR"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup each file/directory
for item in "${FILES_TO_BACKUP[@]}"; do
    if [[ -e "$item" ]]; then
        # Get relative path for backup
        relative_path="${item#$HOME/}"
        backup_path="$BACKUP_DIR/$relative_path"

        # Create parent directory if needed
        mkdir -p "$(dirname "$backup_path")"

        # Copy file or directory
        if [[ -d "$item" ]]; then
            cp -R "$item" "$backup_path"
            echo "✓ Backed up directory: $relative_path"
        else
            cp "$item" "$backup_path"
            echo "✓ Backed up file: $relative_path"
        fi
    else
        echo "⊘ Skipped (not found): ${item#$HOME/}"
    fi
done

# Create a manifest file
cat > "$BACKUP_DIR/MANIFEST.txt" << EOF
Dotfiles Backup Manifest
========================
Created: $(date)
Hostname: $(hostname)
User: $USER
macOS Version: $(sw_vers -productVersion 2>/dev/null || echo "N/A")

Files backed up:
$(ls -la "$BACKUP_DIR" 2>/dev/null)

To restore:
  cp -R $BACKUP_DIR/* ~/
EOF

# Calculate backup size
BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)

echo ""
echo "✅ Backup complete!"
echo "   Location: $BACKUP_DIR"
echo "   Size: $BACKUP_SIZE"
echo ""
echo "To restore: cp -R $BACKUP_DIR/* ~/"

# Optional: Keep only last 5 backups
if [[ -d "$BACKUP_BASE" ]]; then
    BACKUP_COUNT=$(ls -1d "$BACKUP_BASE"/backup_* 2>/dev/null | wc -l)
    if [[ $BACKUP_COUNT -gt 5 ]]; then
        echo ""
        echo "🧹 Cleaning old backups (keeping last 5)..."
        total=$(ls -1d "$BACKUP_BASE"/backup_* | wc -l)
        ls -1d "$BACKUP_BASE"/backup_* | head -n $((total - 5)) | xargs rm -rf
    fi
fi
