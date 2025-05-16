#!/bin/bash
# setup-functions.sh - Create empty versions of missing function files
# This script will create properly structured empty function files to avoid errors

# Color definitions
RESET="\033[0m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"

# Define function directory
FUNC_DIR="/Users/thomasvincent/dotfiles/.zsh/functions.d"

# Create function directory if it doesn't exist
mkdir -p "$FUNC_DIR"

# Function to create an empty function file
create_function_file() {
    local file_name="$1"
    local file_desc="$2"
    local file_path="$FUNC_DIR/$file_name"
    
    # Skip if file already exists
    if [[ -f "$file_path" ]]; then
        echo -e "${YELLOW}File $file_name already exists, skipping...${RESET}"
        return 0
    fi
    
    echo -e "${BLUE}Creating $file_name...${RESET}"
    
    # Create the file with a basic structure
    cat > "$file_path" << EOF
#!/usr/bin/env zsh
# $file_name - $file_desc
# Part of the dotfiles collection at /Users/thomasvincent/dotfiles

# ====================================
# Function file for $file_desc
# ====================================

# This is a placeholder file to prevent errors during shell startup
# Add your custom functions below

EOF
    
    # Make executable
    chmod +x "$file_path"
    echo -e "${GREEN}Created $file_name successfully${RESET}"
}

# Create all missing function files
echo -e "${BLUE}Creating missing function files...${RESET}"

# Create the missing function files with descriptions
create_function_file "400_dev.zsh" "Advanced Development Functions"
create_function_file "500_cloud.zsh" "Cloud Services Functions"
create_function_file "600_containers.zsh" "Container Management Functions"
create_function_file "700_network.zsh" "Network Tools and Utilities"
create_function_file "800_security.zsh" "Security and Encryption Functions"
create_function_file "900_misc.zsh" "Miscellaneous Utility Functions"

echo -e "${GREEN}All function files created successfully!${RESET}"
echo "You can now add your own functions to these files."