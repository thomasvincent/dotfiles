#!/bin/bash
# move_projects.sh - Move all projects to ~/Documents/Projects
# This script will create the Projects directory in Documents and move all projects there

# Color definitions
RESET="\033[0m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BOLD="\033[1m"
UNDERLINE="\033[4m"

# Print header
echo -e "\n${BOLD}${BLUE}======================================${RESET}"
echo -e "${BOLD}${BLUE}   PROJECTS MIGRATION UTILITY${RESET}"
echo -e "${BOLD}${BLUE}======================================${RESET}\n"

echo -e "${BLUE}Moving projects to ${GREEN}~/Documents/Projects${BLUE}...${RESET}"

# Create the target directory if it doesn't exist
TARGET_DIR="$HOME/Documents/Projects"
mkdir -p "$TARGET_DIR"

# 1. First, copy the dotfiles project
if [ -d "$HOME/dotfiles" ]; then
  echo -e "\n${BOLD}${UNDERLINE}${BLUE}DOTFILES PROJECT${RESET}"
  echo -e "${BLUE}Moving dotfiles project to new location...${RESET}"
  rsync -av --progress "$HOME/dotfiles/" "$TARGET_DIR/dotfiles/"
  echo -e "${GREEN}✅ dotfiles copied to ${BOLD}$TARGET_DIR/dotfiles${RESET}"
  
  # Create a symlink to maintain compatibility
  echo -e "\n${BLUE}Creating symlink for backward compatibility...${RESET}"
  if [ -L "$HOME/dotfiles" ]; then
    echo -e "${YELLOW}Removing existing symlink...${RESET}"
    rm "$HOME/dotfiles"
  elif [ -d "$HOME/dotfiles" ]; then
    BACKUP_DIR="$HOME/dotfiles.bak.$(date +%Y%m%d)"
    echo -e "${YELLOW}Backing up original directory to ${BOLD}$BACKUP_DIR${RESET}"
    mv "$HOME/dotfiles" "$BACKUP_DIR"
  fi
  ln -s "$TARGET_DIR/dotfiles" "$HOME/dotfiles"
  echo -e "${GREEN}✅ Symlink created: ${BOLD}$HOME/dotfiles${RESET} → ${BOLD}$TARGET_DIR/dotfiles${RESET}"
fi

# 2. Look for other potential project directories
echo -e "\n${BOLD}${UNDERLINE}${BLUE}OTHER PROJECTS${RESET}"
echo -e "${BLUE}Searching for other project directories in ${GREEN}$HOME${BLUE}...${RESET}"

# Standard directories to skip
declare -a SKIP_DIRS=("Library" "Documents" "Downloads" "Movies" "Music" "Pictures" 
                      "Public" "Desktop" "Applications" ".config" ".local" ".cache")

# Count of found projects
found_projects=0

for dir in "$HOME"/*/; do
  dir_name=$(basename "$dir")
  
  # Skip standard directories
  skip=false
  for skip_dir in "${SKIP_DIRS[@]}"; do
    if [[ "$dir_name" == "$skip_dir" ]]; then
      skip=true
      break
    fi
  done
  [[ $skip == true ]] && continue
  
  # Check if it's a git repo or has src/main directories (likely a project)
  if [ -d "$dir/.git" ] || [ -d "$dir/src" ] || [ -d "$dir/main" ]; then
    found_projects=$((found_projects+1))
    echo -e "\n${YELLOW}Found potential project:${RESET} ${BOLD}$dir_name${RESET}"
    
    # Check if project has a git repo
    if [ -d "$dir/.git" ]; then
      echo -e "  • ${GREEN}Git repository detected${RESET}"
    fi
    
    # Check for common project directories
    [ -d "$dir/src" ] && echo -e "  • ${GREEN}src directory found${RESET}"
    [ -d "$dir/main" ] && echo -e "  • ${GREEN}main directory found${RESET}"
    [ -d "$dir/test" ] && echo -e "  • ${GREEN}test directory found${RESET}"
    [ -d "$dir/docs" ] && echo -e "  • ${GREEN}documentation directory found${RESET}"
    
    echo -ne "\n${BOLD}Do you want to move this to $TARGET_DIR?${RESET} (y/n): "
    read -r answer
    
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      echo -e "\n${BLUE}Moving ${BOLD}$dir_name${BLUE} to ${GREEN}$TARGET_DIR${BLUE}...${RESET}"
      rsync -av --progress "$dir" "$TARGET_DIR/$dir_name/"
      echo -e "${GREEN}✅ Project copied to ${BOLD}$TARGET_DIR/$dir_name${RESET}"
      
      echo -ne "\n${BOLD}Create a symlink for backward compatibility?${RESET} (y/n): "
      read -r symlink_answer
      
      if [[ "$symlink_answer" =~ ^[Yy]$ ]]; then
        if [ -L "$HOME/$dir_name" ]; then
          echo -e "${YELLOW}Removing existing symlink...${RESET}"
          rm "$HOME/$dir_name"
        elif [ -d "$HOME/$dir_name" ]; then
          BACKUP_DIR="$HOME/$dir_name.bak.$(date +%Y%m%d)"
          echo -e "${YELLOW}Backing up original directory to ${BOLD}$BACKUP_DIR${RESET}"
          mv "$HOME/$dir_name" "$BACKUP_DIR"
        fi
        ln -s "$TARGET_DIR/$dir_name" "$HOME/$dir_name"
        echo -e "${GREEN}✅ Symlink created: ${BOLD}$HOME/$dir_name${RESET} → ${BOLD}$TARGET_DIR/$dir_name${RESET}"
      fi
    fi
  fi
done

# Output result message
if [ $found_projects -eq 0 ]; then
  echo -e "\n${YELLOW}No additional projects found in ${BOLD}$HOME${RESET}"
else
  echo -e "\n${GREEN}Found ${BOLD}$found_projects${GREEN} potential projects in ${BOLD}$HOME${RESET}"
fi

# 3. Update configuration files
echo -e "\n${BOLD}${UNDERLINE}${BLUE}UPDATING CONFIGURATION${RESET}"

# Update PROJECTS_DIR in env.zsh
echo -e "${BLUE}Updating environment configuration...${RESET}"
if [ -f "$HOME/dotfiles/.zsh/env.zsh" ]; then
  sed -i '' 's|export PROJECTS_DIR="$HOME/Projects"|export PROJECTS_DIR="$HOME/Documents/Projects"|g' "$HOME/dotfiles/.zsh/env.zsh"
  echo -e "${GREEN}✅ Updated PROJECTS_DIR in ${BOLD}env.zsh${RESET}"
else
  echo -e "${YELLOW}⚠️ env.zsh not found, skipping environment update${RESET}"
fi

# Update project path aliases in aliases.zsh
echo -e "${BLUE}Updating shell aliases...${RESET}"
if [ -f "$HOME/dotfiles/.zsh/aliases.zsh" ]; then
  sed -i '' 's|alias cdp='\''cd ~/Projects'\'|alias cdp='\''cd ~/Documents/Projects'\'|g' "$HOME/dotfiles/.zsh/aliases.zsh"
  echo -e "${GREEN}✅ Updated aliases in ${BOLD}aliases.zsh${RESET}"
else
  echo -e "${YELLOW}⚠️ aliases.zsh not found, skipping alias update${RESET}"
fi

# Final message
echo -e "\n${BOLD}${GREEN}======================================${RESET}"
echo -e "${BOLD}${GREEN}✅  PROJECT MIGRATION COMPLETE${RESET}"
echo -e "${BOLD}${GREEN}======================================${RESET}"
echo -e "\n${GREEN}Your projects have been successfully moved to:${RESET}"
echo -e "${BOLD}$TARGET_DIR${RESET}"
echo -e "\n${YELLOW}NOTE:${RESET} You should restart your shell to apply all changes."
echo -e "${BLUE}To restart your shell, run:${RESET} ${BOLD}exec zsh${RESET}"
echo