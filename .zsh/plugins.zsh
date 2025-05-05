#!/usr/bin/env zsh
# Advanced ZSH plugin management with zinit

# Initialize plugin system
# =======================
# Set up Zinit if not already installed
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
ZINIT_BIN_DIR="${ZINIT_HOME}/zinit.zsh"

# Auto-install zinit if not present
if [[ ! -f "$ZINIT_BIN_DIR" ]]; then
  print -P "%F{blue}▓▒░ Installing Zinit...%f"
  mkdir -p "$(dirname "$ZINIT_HOME")" && chmod g-rwX "$(dirname "$ZINIT_HOME")"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" &> /dev/null
  if [[ $? -ne 0 ]]; then
    print -P "%F{red}▓▒░ Failed to install Zinit. Some features will be disabled.%f"
  else
    print -P "%F{green}▓▒░ Zinit installed successfully.%f"
  fi
fi

# Load zinit if installed
if [[ -f "$ZINIT_BIN_DIR" ]]; then
  source "$ZINIT_BIN_DIR"
  
  # ======================
  # Plugin Configurations
  # ======================
  
  # Completion enhancements
  # =======================
  # Fast tab completion
  zinit ice wait'0a' lucid atload'_zsh_autosuggest_start'
  zinit light zsh-users/zsh-autosuggestions
  
  # Syntax highlighting - load close to end to ensure proper priority
  zinit ice wait'0b' lucid atinit'zicompinit; zicdreplay'
  zinit light zdharma-continuum/fast-syntax-highlighting
  
  # History substring searching
  zinit ice wait'0c' lucid
  zinit light zsh-users/zsh-history-substring-search
  
  # Enhanced 'cd' with frecency
  zinit ice wait'1' lucid
  zinit light agkozak/zsh-z
  
  # ======================
  # Additional Plugins
  # ======================
  
  # Utility plugins
  # ==============
  
  # Git aliases and completions 
  zinit ice wait'1' lucid
  zinit light zdharma-continuum/git-com
  
  # Utility functions - use built-in functions instead
  # zinit ice wait'1' lucid
  # zinit snippet OMZP::utility
  
  # Extract functionality handled by our custom extract function
  # zinit ice wait'1' lucid
  # zinit snippet OMZP::extract
  
  # Enhanced directory navigation
  zinit ice wait'1' lucid
  zinit light agkozak/zsh-z
  
  # ======================
  # Completions
  # ======================
  # Load completion system if not already loaded
  zinit ice wait'0' lucid blockf atpull'zinit creinstall -q .'
  zinit light zsh-users/zsh-completions
  
  # Docker completions
  if (( $+commands[docker] )); then
    # Load docker completion from local zsh completion if available
    zinit ice wait'1' lucid as'completion'
    zinit snippet <(docker completion zsh 2>/dev/null)
  fi
  
  # Kubectl completions
  if (( $+commands[kubectl] )); then
    # Load from kubectl directly instead of GitHub URL
    zinit ice wait'1' lucid as'completion'
    zinit snippet <(kubectl completion zsh 2>/dev/null)
  fi
  
  # NPM completions
  if (( $+commands[npm] )); then
    zinit ice wait'1' lucid as'completion'
    zinit snippet OMZP::npm
  fi
  
  # ======================
  # Developer Tools
  # ======================
  
  # FZF integration
  zinit ice wait'1' lucid
  zinit snippet OMZP::fzf
  
  # Python utilities
  zinit ice wait'1' lucid
  zinit snippet OMZP::python
  
  # Node.js utilities
  zinit ice wait'1' lucid
  zinit snippet OMZP::node
  
  # ======================
  # Theme Configuration
  # ======================
  
  # Powerlevel10k - Fast, customizable prompt
  # Load configuration from ~/.p10k.zsh
  zinit ice depth=1
  zinit light romkatv/powerlevel10k
  
  # ======================
  # Key Bindings
  # ======================
  
  # Bind keys for history-substring-search if loaded
  if zinit lb zsh-users/zsh-history-substring-search &>/dev/null; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey '^K' history-substring-search-up
    bindkey '^J' history-substring-search-down
  fi
  
  # ======================
  # Plugin Configurations
  # ======================
  
  # Autosuggestions configuration
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
  ZSH_AUTOSUGGEST_USE_ASYNC=1
  
  # Fast-syntax-highlighting configuration
  # FAST_HIGHLIGHT[use_brackets]=1 # Disabled to prevent errors
  
  # Zinit turbo mode
  zinit wait'2' lucid for \
    OMZP::command-not-found
  
  # =======================
  # User Plugin Selection
  # =======================
  # Load user-specified plugins from local configuration
  [[ -f "$HOME/.zsh/plugins.local.zsh" ]] && source "$HOME/.zsh/plugins.local.zsh"
  
else
  # Fallback if zinit not available
  echo "Warning: Zinit not found. Using basic configuration."
  autoload -Uz compinit && compinit
  PS1="%F{blue}%n@%m%f:%F{green}%~%f$ "
fi

# Create a template for user-customizable plugins
if [[ ! -f "$HOME/.zsh/plugins.local.zsh" ]]; then
  cat > "$HOME/.zsh/plugins.local.zsh" <<EOL
#!/usr/bin/env zsh
# User-specific plugin configuration
# Uncomment plugins you wish to enable

# Additional plugins
# zinit ice wait'1' lucid
# zinit snippet OMZP::aws

# zinit ice wait'1' lucid
# zinit light supercrabtree/k

# zinit ice wait'1' lucid
# zinit light zsh-users/zsh-syntax-highlighting

# Docker/container tools
# zinit ice wait'1' lucid
# zinit snippet OMZP::docker-compose

# Cloud/Platform specific tools
# zinit ice wait'1' lucid
# zinit snippet OMZP::gcloud

# Language-specific plugins
# zinit ice wait'1' lucid
# zinit snippet OMZP::golang

# zinit ice wait'1' lucid
# zinit snippet OMZP::rust
EOL
fi