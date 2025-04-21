#!/usr/bin/env zsh

# .zshrc
# Author: Thomas Vincent
# GitHub: https://github.com/thomasvincent/dotfiles
#
# Main zsh configuration file

# Path to your dotfiles installation
export DOTFILES="$HOME/Documents/Projects/dotfiles"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Oh My Zsh if installed
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  # Path to your oh-my-zsh installation.
  export ZSH="$HOME/.oh-my-zsh"

  # Set name of the theme to load
  # We'll use Starship prompt instead, but this is a fallback
  ZSH_THEME="robbyrussell"

  # Uncomment the following line to use case-sensitive completion.
  # CASE_SENSITIVE="true"

  # Uncomment the following line to use hyphen-insensitive completion.
  # Case-sensitive completion must be off. _ and - will be interchangeable.
  HYPHEN_INSENSITIVE="true"

  # Uncomment the following line to disable bi-weekly auto-update checks.
  # DISABLE_AUTO_UPDATE="true"

  # Uncomment the following line to automatically update without prompting.
  DISABLE_UPDATE_PROMPT="true"

  # Uncomment the following line to change how often to auto-update (in days).
  export UPDATE_ZSH_DAYS=7

  # Uncomment the following line if pasting URLs and other text is messed up.
  # DISABLE_MAGIC_FUNCTIONS="true"

  # Uncomment the following line to disable colors in ls.
  # DISABLE_LS_COLORS="true"

  # Uncomment the following line to disable auto-setting terminal title.
  # DISABLE_AUTO_TITLE="true"

  # Uncomment the following line to enable command auto-correction.
  # ENABLE_CORRECTION="true"

  # Uncomment the following line to display red dots whilst waiting for completion.
  COMPLETION_WAITING_DOTS="true"

  # Uncomment the following line if you want to disable marking untracked files
  # under VCS as dirty. This makes repository status check for large repositories
  # much, much faster.
  # DISABLE_UNTRACKED_FILES_DIRTY="true"

  # Uncomment the following line if you want to change the command execution time
  # stamp shown in the history command output.
  # You can set one of the optional three formats:
  # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
  # or set a custom format using the strftime function format specifications,
  # see 'man strftime' for details.
  HIST_STAMPS="yyyy-mm-dd"

  # Which plugins would you like to load?
  # Standard plugins can be found in ~/.oh-my-zsh/plugins/*
  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=(
    git
    docker
    docker-compose
    kubectl
    terraform
    aws
    vscode
    macos
    brew
    npm
    yarn
    python
    pip
    ruby
    bundler
    composer
    zsh-autosuggestions
    zsh-syntax-highlighting
    history-substring-search
    fzf
    z
  )

  source $ZSH/oh-my-zsh.sh
fi

# User configuration

# Set default editor
if command -v nvim &> /dev/null; then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

# Set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# Load custom configurations
for file in "$DOTFILES"/zsh/{exports,aliases,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Load tool-specific configurations
for file in "$DOTFILES"/tools/*.zsh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Load private configurations (not tracked in git)
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# Initialize zoxide (smarter cd command)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# Initialize direnv (environment switcher)
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Initialize thefuck (command corrector)
if command -v thefuck &> /dev/null; then
  eval "$(thefuck --alias)"
fi

# Initialize fzf (fuzzy finder)
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
elif [[ -f /usr/local/opt/fzf/shell/completion.zsh ]]; then
  source /usr/local/opt/fzf/shell/completion.zsh
  source /usr/local/opt/fzf/shell/key-bindings.zsh
elif [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# Initialize asdf (version manager)
if [[ -f /usr/local/opt/asdf/libexec/asdf.sh ]]; then
  source /usr/local/opt/asdf/libexec/asdf.sh
elif [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]]; then
  source /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [[ -f $HOME/.asdf/asdf.sh ]]; then
  source $HOME/.asdf/asdf.sh
fi

# Initialize rbenv (Ruby version manager)
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

# Initialize pyenv (Python version manager)
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
  if command -v pyenv-virtualenv-init &> /dev/null; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# Initialize nvm (Node version manager)
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Initialize Starship prompt
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Use modern completion system
autoload -Uz compinit
compinit

# Set options
setopt AUTO_CD              # If a command is not found, and is a directory, cd to that directory
setopt EXTENDED_HISTORY     # Record timestamp of command in HISTFILE
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS     # Ignore duplicated commands history list
setopt HIST_IGNORE_SPACE    # Ignore commands that start with space
setopt HIST_VERIFY          # Show command with history expansion to user before running it
setopt SHARE_HISTORY        # Share command history data
setopt APPEND_HISTORY       # Append to history file
setopt INC_APPEND_HISTORY   # Add commands to history immediately
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from history items

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000

# Homebrew path
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Add custom bin directories to PATH
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Add Homebrew's sbin to PATH
export PATH="/usr/local/sbin:$PATH"

# Add Visual Studio Code to PATH
if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
  export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# Add Composer's bin to PATH
if [[ -d "$HOME/.composer/vendor/bin" ]]; then
  export PATH="$PATH:$HOME/.composer/vendor/bin"
fi

# Add Go binaries to PATH
if [[ -d "$HOME/go/bin" ]]; then
  export PATH="$PATH:$HOME/go/bin"
fi

# Add Rust's cargo binaries to PATH
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

# Add Python user-site binaries to PATH
if command -v python3 &> /dev/null; then
  export PATH="$PATH:$(python3 -m site --user-base)/bin"
fi

# Add Ruby gems to PATH
if command -v ruby &> /dev/null && command -v gem &> /dev/null; then
  export PATH="$PATH:$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

# Add Yarn global binaries to PATH
if command -v yarn &> /dev/null; then
  export PATH="$PATH:$(yarn global bin)"
fi

# Add custom scripts to PATH
if [[ -d "$DOTFILES/bin" ]]; then
  export PATH="$PATH:$DOTFILES/bin"
fi

# Use bat as manpager if available
if command -v bat &> /dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# Use exa instead of ls if available
if command -v exa &> /dev/null; then
  alias ls='exa'
  alias ll='exa -la'
  alias la='exa -a'
  alias lt='exa -T'
  alias lg='exa -la --git'
fi

# Use bat instead of cat if available
if command -v bat &> /dev/null; then
  alias cat='bat'
fi

# Use fd instead of find if available
if command -v fd &> /dev/null; then
  alias find='fd'
fi

# Use ripgrep instead of grep if available
if command -v rg &> /dev/null; then
  alias grep='rg'
fi

# Use htop instead of top if available
if command -v htop &> /dev/null; then
  alias top='htop'
fi

# Use diff-so-fancy for git diff if available
if command -v diff-so-fancy &> /dev/null; then
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
  git config --global interactive.diffFilter "diff-so-fancy --patch"
fi

# Use git-delta for git diff if available (overrides diff-so-fancy)
if command -v delta &> /dev/null; then
  git config --global core.pager "delta"
  git config --global interactive.diffFilter "delta --color-only"
fi

# Final PATH adjustments
typeset -U path
