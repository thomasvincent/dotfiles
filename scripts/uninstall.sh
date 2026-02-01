#!/usr/bin/env bash
# uninstall.sh - Cleanly remove dotfiles installation
#
# Usage:
#   ./scripts/uninstall.sh           # Interactive mode
#   ./scripts/uninstall.sh --force   # No prompts
#   ./scripts/uninstall.sh --dry-run # Show what would be removed

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Globals
DRY_RUN=false
FORCE=false
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--dry-run] [--force]"
            echo ""
            echo "Options:"
            echo "  --dry-run  Show what would be removed without making changes"
            echo "  --force    Skip confirmation prompts"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

# Files and directories managed by these dotfiles
MANAGED_FILES=(
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.zprofile"
    "$HOME/.gitignore"
    "$HOME/.p10k.zsh"
)

MANAGED_DIRS=(
    "$HOME/.zsh"
    "$HOME/.config/git"
    "$HOME/.config/ripgrep"
    "$HOME/.config/vim"
    "$HOME/.config/alacritty"
    "$HOME/.config/htop"
    "$HOME/.config/tmux"
    "$HOME/.config/bat"
)

MANAGED_SYMLINKS=(
    "$HOME/dotfiles"
)

backup_item() {
    local item="$1"
    if [[ -e "$item" || -L "$item" ]]; then
        local dest="$BACKUP_DIR${item#$HOME}"
        mkdir -p "$(dirname "$dest")"
        if $DRY_RUN; then
            log_info "[DRY-RUN] Would backup: $item -> $dest"
        else
            cp -a "$item" "$dest" 2>/dev/null || true
            log_info "Backed up: $item"
        fi
    fi
}

remove_item() {
    local item="$1"
    if [[ -e "$item" || -L "$item" ]]; then
        if $DRY_RUN; then
            log_info "[DRY-RUN] Would remove: $item"
        else
            rm -rf "$item"
            log_success "Removed: $item"
        fi
    else
        log_warn "Not found (skipping): $item"
    fi
}

main() {
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║              DOTFILES UNINSTALL SCRIPT                       ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if $DRY_RUN; then
        log_warn "DRY-RUN MODE - No changes will be made"
        echo ""
    fi

    # Confirmation
    if ! $FORCE && ! $DRY_RUN; then
        echo -e "${YELLOW}This will remove the following:${NC}"
        echo ""
        echo "Files:"
        for f in "${MANAGED_FILES[@]}"; do
            [[ -e "$f" ]] && echo "  - $f"
        done
        echo ""
        echo "Directories:"
        for d in "${MANAGED_DIRS[@]}"; do
            [[ -e "$d" || -L "$d" ]] && echo "  - $d"
        done
        echo ""
        echo "Symlinks:"
        for s in "${MANAGED_SYMLINKS[@]}"; do
            [[ -L "$s" ]] && echo "  - $s"
        done
        echo ""
        read -p "Are you sure you want to continue? [y/N] " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Uninstall cancelled."
            exit 0
        fi
    fi

    # Create backup directory
    if ! $DRY_RUN; then
        mkdir -p "$BACKUP_DIR"
        log_info "Backup directory: $BACKUP_DIR"
    fi

    # Purge chezmoi state if installed
    if command -v chezmoi &>/dev/null; then
        log_info "Purging chezmoi state..."
        if $DRY_RUN; then
            log_info "[DRY-RUN] Would run: chezmoi purge --force"
        else
            chezmoi purge --force 2>/dev/null || true
        fi
    fi

    # Backup and remove managed files
    log_info "Processing managed files..."
    for file in "${MANAGED_FILES[@]}"; do
        backup_item "$file"
        remove_item "$file"
    done

    # Backup and remove managed directories
    log_info "Processing managed directories..."
    for dir in "${MANAGED_DIRS[@]}"; do
        backup_item "$dir"
        remove_item "$dir"
    done

    # Remove symlinks
    log_info "Processing symlinks..."
    for link in "${MANAGED_SYMLINKS[@]}"; do
        remove_item "$link"
    done

    # Clean up empty directories
    log_info "Cleaning up empty directories..."
    for dir in "$HOME/.config" "$HOME/.zsh"; do
        if [[ -d "$dir" ]] && [[ -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
            if $DRY_RUN; then
                log_info "[DRY-RUN] Would remove empty directory: $dir"
            else
                rmdir "$dir" 2>/dev/null || true
            fi
        fi
    done

    echo ""
    if $DRY_RUN; then
        log_success "Dry run complete. No changes were made."
    else
        log_success "Uninstall complete!"
        log_info "Backup saved to: $BACKUP_DIR"
        echo ""
        echo -e "${YELLOW}Note:${NC} You may need to:"
        echo "  1. Remove Homebrew packages manually: brew bundle cleanup --file=Brewfile"
        echo "  2. Start a new shell session"
        echo "  3. Set a new default shell if needed: chsh -s /bin/bash"
    fi
}

main "$@"
