#!/usr/bin/env zsh
# Terminal theming and appearance customization

# ===================================
# Terminal Colors and Themes
# ===================================

# Define color variables for easy terminal coloring
typeset -A ZSH_COLORS

# ANSI color codes
ZSH_COLORS[reset]="\033[0m"
ZSH_COLORS[black]="\033[0;30m"
ZSH_COLORS[red]="\033[0;31m"
ZSH_COLORS[green]="\033[0;32m"
ZSH_COLORS[yellow]="\033[0;33m"
ZSH_COLORS[blue]="\033[0;34m"
ZSH_COLORS[magenta]="\033[0;35m"
ZSH_COLORS[cyan]="\033[0;36m"
ZSH_COLORS[white]="\033[0;37m"

# Bold colors
ZSH_COLORS[bold_black]="\033[1;30m"
ZSH_COLORS[bold_red]="\033[1;31m"
ZSH_COLORS[bold_green]="\033[1;32m"
ZSH_COLORS[bold_yellow]="\033[1;33m"
ZSH_COLORS[bold_blue]="\033[1;34m"
ZSH_COLORS[bold_magenta]="\033[1;35m"
ZSH_COLORS[bold_cyan]="\033[1;36m"
ZSH_COLORS[bold_white]="\033[1;37m"

# Background colors
ZSH_COLORS[bg_black]="\033[40m"
ZSH_COLORS[bg_red]="\033[41m"
ZSH_COLORS[bg_green]="\033[42m"
ZSH_COLORS[bg_yellow]="\033[43m"
ZSH_COLORS[bg_blue]="\033[44m"
ZSH_COLORS[bg_magenta]="\033[45m"
ZSH_COLORS[bg_cyan]="\033[46m"
ZSH_COLORS[bg_white]="\033[47m"

# Test all colors with a color chart
colortest() {
  echo "ANSI Color Chart:"
  echo
  echo "Regular Colors:"
  echo "${ZSH_COLORS[black]}Black${ZSH_COLORS[reset]} ${ZSH_COLORS[red]}Red${ZSH_COLORS[reset]} ${ZSH_COLORS[green]}Green${ZSH_COLORS[reset]} ${ZSH_COLORS[yellow]}Yellow${ZSH_COLORS[reset]} ${ZSH_COLORS[blue]}Blue${ZSH_COLORS[reset]} ${ZSH_COLORS[magenta]}Magenta${ZSH_COLORS[reset]} ${ZSH_COLORS[cyan]}Cyan${ZSH_COLORS[reset]} ${ZSH_COLORS[white]}White${ZSH_COLORS[reset]}"
  echo
  echo "Bold Colors:"
  echo "${ZSH_COLORS[bold_black]}Black${ZSH_COLORS[reset]} ${ZSH_COLORS[bold_red]}Red${ZSH_COLORS[reset]} ${ZSH_COLORS[bold_green]}Green${ZSH_COLORS[reset]} ${ZSH_COLORS[bold_yellow]}Yellow${ZSH_COLORS[reset]} ${ZSH_COLORS[bold_blue]}Blue${ZSH_COLORS[reset]} ${ZSH_COLORS[bold_magenta]}Magenta${ZSH_COLORS[reset]} ${ZSH_COLORS[bold_cyan]}Cyan${ZSH_COLORS[reset]} ${ZSH_COLORS[bold_white]}White${ZSH_COLORS[reset]}"
  echo
  echo "Background Colors:"
  echo "${ZSH_COLORS[bg_black]}Black${ZSH_COLORS[reset]} ${ZSH_COLORS[bg_red]}Red${ZSH_COLORS[reset]} ${ZSH_COLORS[bg_green]}Green${ZSH_COLORS[reset]} ${ZSH_COLORS[bg_yellow]}Yellow${ZSH_COLORS[reset]} ${ZSH_COLORS[bg_blue]}Blue${ZSH_COLORS[reset]} ${ZSH_COLORS[bg_magenta]}Magenta${ZSH_COLORS[reset]} ${ZSH_COLORS[bg_cyan]}Cyan${ZSH_COLORS[reset]} ${ZSH_COLORS[bg_white]}White${ZSH_COLORS[reset]}"

  # Show 256 color palette
  echo
  echo "256 Color Mode:"
  local i
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%8)):#7}:+$'\n'}
  done
  echo
}

# ===================================
# Terminal Theme Switching
# ===================================

# Theme directory
THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/themes"
[[ -d "$THEMES_DIR" ]] || mkdir -p "$THEMES_DIR"

# Current theme file
CURRENT_THEME_FILE="$THEMES_DIR/current_theme"

# Create theme files if they don't exist
if [[ ! -f "$THEMES_DIR/dark.theme" ]]; then
  cat > "$THEMES_DIR/dark.theme" << EOL
# Dark Theme
export BAT_THEME="Dracula"
export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
export THEME_MODE="dark"

# iTerm2 profile switching (if iTerm2 integration is installed)
if [[ -n "$ITERM_PROFILE" ]]; then
  echo -e "\033]50;SetProfile=Dark\a"
fi

# Terminal app setting
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  osascript -e 'tell application "Terminal" to set current settings of first window to settings set "Pro"'
fi

# macOS color scheme (dark mode) - requires restart
# defaults write -g AppleInterfaceStyle Dark
EOL
fi

if [[ ! -f "$THEMES_DIR/light.theme" ]]; then
  cat > "$THEMES_DIR/light.theme" << EOL
# Light Theme
export BAT_THEME="GitHub"
export FZF_DEFAULT_OPTS="--color=fg:#383a42,bg:#fafafa,hl:#0184bc --color=fg+:#383a42,bg+:#e5e5e6,hl+:#0184bc --color=info:#4078f2,prompt:#50a14f,pointer:#e45649 --color=marker:#e45649,spinner:#4078f2,header:#986801"
export THEME_MODE="light"

# iTerm2 profile switching (if iTerm2 integration is installed)
if [[ -n "$ITERM_PROFILE" ]]; then
  echo -e "\033]50;SetProfile=Light\a"
fi

# Terminal app setting
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  osascript -e 'tell application "Terminal" to set current settings of first window to settings set "Basic"'
fi

# macOS color scheme (light mode) - requires restart
# defaults write -g AppleInterfaceStyle -delete
EOL
fi

if [[ ! -f "$THEMES_DIR/oceanic.theme" ]]; then
  cat > "$THEMES_DIR/oceanic.theme" << EOL
# Oceanic Theme
export BAT_THEME="base16"
export FZF_DEFAULT_OPTS="--color=fg:#D8DEE9,bg:#1B2B34,hl:#88C0D0 --color=fg+:#D8DEE9,bg+:#2E3440,hl+:#88C0D0 --color=info:#5E81AC,prompt:#A3BE8C,pointer:#EBCB8B --color=marker:#EBCB8B,spinner:#5E81AC,header:#B48EAD"
export THEME_MODE="dark"

# iTerm2 profile switching (if iTerm2 integration is installed)
if [[ -n "$ITERM_PROFILE" ]]; then
  echo -e "\033]50;SetProfile=Oceanic\a"
fi

# Terminal app setting
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  osascript -e 'tell application "Terminal" to set current settings of first window to settings set "Ocean"'
fi
EOL
fi

# Set the default theme if none set
if [[ ! -f "$CURRENT_THEME_FILE" ]]; then
  echo "dark" > "$CURRENT_THEME_FILE"
fi

# Load current theme
load_theme() {
  local theme_name="$1"

  if [[ -z "$theme_name" ]]; then
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
      theme_name=$(cat "$CURRENT_THEME_FILE")
    else
      theme_name="dark"  # Default theme
    fi
  fi

  local theme_file="$THEMES_DIR/${theme_name}.theme"

  # Create default theme if it doesn't exist
  if [[ ! -f "$THEMES_DIR/dark.theme" ]]; then
    # Create parent directory if needed
    mkdir -p "$THEMES_DIR"

    # Create a basic dark theme
    cat > "$THEMES_DIR/dark.theme" << 'EOL'
# Dark Theme
export BAT_THEME="ansi"
export FZF_DEFAULT_OPTS="--color=dark"
export THEME_MODE="dark"
EOL

    echo "Created default dark theme"
  fi

  # Now use the theme
  if [[ -f "$theme_file" ]]; then
    source "$theme_file"
    echo "$theme_name" > "$CURRENT_THEME_FILE"
    echo "Switched to ${theme_name} theme"
  else
    if [[ -f "$THEMES_DIR/dark.theme" ]]; then
      source "$THEMES_DIR/dark.theme"
      echo "dark" > "$CURRENT_THEME_FILE"
      echo "Theme '${theme_name}' not found, using dark theme instead"
    else
      echo "No themes available. Using system defaults."
    fi
  fi
}

# Theme switching functions
theme() {
  if [[ -z "$1" ]]; then
    echo "Available themes:"
    for theme_file in "$THEMES_DIR"/*.theme; do
      basename "$theme_file" .theme
    done
    echo
    echo "Current theme: $(cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "unknown")"
    return 0
  fi

  load_theme "$1"
}

# Dark mode
dark() {
  load_theme "dark"
}

# Light mode
light() {
  load_theme "light"
}

# Auto-switch based on macOS dark mode
auto_theme() {
  # Only runs on macOS
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "Auto theme switching only works on macOS"
    return 1
  fi

  # Check if dark mode is enabled
  local is_dark_mode
  is_dark_mode=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

  if [[ "$is_dark_mode" == "Dark" ]]; then
    load_theme "dark"
  else
    load_theme "light"
  fi
}

# Create a new theme
create_theme() {
  local theme_name="$1"

  if [[ -z "$theme_name" ]]; then
    echo "Usage: create_theme <theme_name>"
    return 1
  fi

  local theme_file="$THEMES_DIR/${theme_name}.theme"

  if [[ -f "$theme_file" ]]; then
    echo "Theme '${theme_name}' already exists. Overwrite? (y/n)"
    read -q response
    echo
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
      return 1
    fi
  fi

  cat > "$theme_file" << EOL
# ${theme_name} Theme
export BAT_THEME="default"
export FZF_DEFAULT_OPTS=""
export THEME_MODE="custom"

# iTerm2 profile switching (if iTerm2 integration is installed)
if [[ -n "\$ITERM_PROFILE" ]]; then
  echo -e "\033]50;SetProfile=${theme_name}\a"
fi
EOL

  echo "Created theme '${theme_name}'"
  echo "Edit the theme at: $theme_file"
}

# Edit a theme
edit_theme() {
  local theme_name="$1"

  if [[ -z "$theme_name" ]]; then
    echo "Usage: edit_theme <theme_name>"
    return 1
  fi

  local theme_file="$THEMES_DIR/${theme_name}.theme"

  if [[ ! -f "$theme_file" ]]; then
    echo "Theme '${theme_name}' not found"
    return 1
  fi

  ${EDITOR:-vim} "$theme_file"
}

# Delete a theme
delete_theme() {
  local theme_name="$1"

  if [[ -z "$theme_name" ]]; then
    echo "Usage: delete_theme <theme_name>"
    return 1
  fi

  if [[ "$theme_name" == "dark" || "$theme_name" == "light" || "$theme_name" == "oceanic" ]]; then
    echo "Cannot delete built-in theme '${theme_name}'"
    return 1
  fi

  local theme_file="$THEMES_DIR/${theme_name}.theme"

  if [[ ! -f "$theme_file" ]]; then
    echo "Theme '${theme_name}' not found"
    return 1
  fi

  echo -n "Are you sure you want to delete theme '${theme_name}'? (y/n) "
  read -q response
  echo

  if [[ "$response" =~ ^[Yy]$ ]]; then
    rm "$theme_file"
    echo "Deleted theme '${theme_name}'"

    # Reset to default theme if we just deleted the current theme
    if [[ "$(cat "$CURRENT_THEME_FILE" 2>/dev/null)" == "$theme_name" ]]; then
      echo "dark" > "$CURRENT_THEME_FILE"
      load_theme "dark"
    fi
  fi
}

# ===================================
# P10K Theme Customization
# ===================================

# Helper to update p10k configuration
update_p10k_config() {
  local mode="$1"
  local p10k_file="${ZDOTDIR:-$HOME}/.p10k.zsh"

  if [[ ! -f "$p10k_file" ]]; then
    echo "Powerlevel10k configuration file not found"
    return 1
  fi

  case "$mode" in
    dark)
      sed -i '' 's/POWERLEVEL9K_COLOR_SCHEME=.*/POWERLEVEL9K_COLOR_SCHEME="dark"/' "$p10k_file"
      ;;
    light)
      sed -i '' 's/POWERLEVEL9K_COLOR_SCHEME=.*/POWERLEVEL9K_COLOR_SCHEME="light"/' "$p10k_file"
      ;;
    *)
      echo "Unknown mode: $mode"
      return 1
      ;;
  esac

  echo "Updated Powerlevel10k theme to $mode mode"
  echo "Restart your shell or run 'source $p10k_file' to apply changes"
}

# ===================================
# Initialize theme on startup
# ===================================
# Load the current theme or default to dark
load_theme
