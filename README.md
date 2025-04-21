# Dotfiles

A comprehensive collection of dotfiles and scripts for setting up a macOS development environment optimized for senior developers, DevOps, and cloud engineers.

## Features

- **Shell**: Zsh with Oh My Zsh and Starship prompt
- **Modern CLI Tools**: Replacements for traditional Unix tools (bat, exa, fd, ripgrep, fzf, zoxide, etc.)
- **Development Environment**: Configurations for various languages and tools
  - PHP (with WordPress)
  - Ruby
  - Python
  - Shell (zsh/bash)
- **Cloud & Infrastructure**: Support for various cloud platforms and infrastructure tools
  - Terraform & HCL
  - DigitalOcean
  - AWS
  - Docker & Kubernetes
- **Git**: Enhanced Git configuration with useful aliases and settings
- **Vim/Neovim**: Comprehensive Vim configuration
- **VS Code**: Integration with VS Code
- **macOS**: Sensible macOS defaults and tweaks
- **iTerm2**: Configuration for iTerm2

## Installation

### Quick Install

```bash
git clone https://github.com/thomasvincent/dotfiles.git ~/Documents/Projects/dotfiles
cd ~/Documents/Projects/dotfiles
./install.sh
```

### Manual Installation

1. Clone the repository:

```bash
git clone https://github.com/thomasvincent/dotfiles.git ~/Documents/Projects/dotfiles
```

2. Navigate to the dotfiles directory:

```bash
cd ~/Documents/Projects/dotfiles
```

3. Run the installation script:

```bash
./install.sh
```

## What's Included

### Shell Configuration

- `.zshrc`: Main Zsh configuration
- `.zprofile`: Login shell configuration
- `.aliases`: Useful shell aliases
- `.functions`: Useful shell functions
- `.exports`: Environment variables

### Git Configuration

- `.gitconfig`: Git configuration with useful aliases and settings
- `.gitignore_global`: Global Git ignore patterns

### Vim Configuration

- `.vimrc`: Vim configuration

### Starship Configuration

- `starship.toml`: Starship prompt configuration

### macOS Configuration

- `macos/defaults.sh`: Sensible macOS defaults

### Homebrew

- `Brewfile`: List of packages to install with Homebrew

### Installation Script

- `install.sh`: Script to install and configure everything

## Customization

### Adding Your Own Customizations

You can add your own customizations by creating a `.zshrc.local` file in your home directory. This file will be sourced by the main `.zshrc` file.

```bash
touch ~/.zshrc.local
```

### Customizing Git Configuration

You can customize your Git configuration by editing the `.gitconfig` file. Make sure to update the user section with your own information:

```
[user]
    name = Your Name
    email = your.email@example.com
```

### Customizing Starship Prompt

You can customize the Starship prompt by editing the `starship.toml` file. See the [Starship documentation](https://starship.rs/config/) for more information.

## Included Tools

### Shell Tools

- [Zsh](https://www.zsh.org/): Modern shell
- [Oh My Zsh](https://ohmyz.sh/): Framework for managing Zsh configuration
- [Starship](https://starship.rs/): Cross-shell prompt
- [bat](https://github.com/sharkdp/bat): Cat clone with syntax highlighting
- [exa](https://the.exa.website/): Modern replacement for ls
- [fd](https://github.com/sharkdp/fd): Simple, fast alternative to find
- [ripgrep](https://github.com/BurntSushi/ripgrep): Fast grep replacement
- [fzf](https://github.com/junegunn/fzf): Fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide): Smarter cd command
- [jq](https://stedolan.github.io/jq/): JSON processor
- [yq](https://github.com/mikefarah/yq): YAML processor
- [htop](https://htop.dev/): Interactive process viewer
- [tmux](https://github.com/tmux/tmux): Terminal multiplexer
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy): Git diff output enhancer
- [tldr](https://tldr.sh/): Simplified man pages
- [thefuck](https://github.com/nvbn/thefuck): Corrects previous console command
- [direnv](https://direnv.net/): Environment switcher

### Development Tools

- [Git](https://git-scm.com/): Version control
- [Vim](https://www.vim.org/): Text editor
- [Neovim](https://neovim.io/): Hyperextensible Vim-based text editor
- [Visual Studio Code](https://code.visualstudio.com/): Code editor
- [asdf](https://asdf-vm.com/): Extendable version manager

### Cloud & Infrastructure Tools

- [Terraform](https://www.terraform.io/): Infrastructure as code
- [Docker](https://www.docker.com/): Containerization platform
- [Kubernetes](https://kubernetes.io/): Container orchestration
- [AWS CLI](https://aws.amazon.com/cli/): AWS command-line interface
- [doctl](https://github.com/digitalocean/doctl): DigitalOcean CLI

### Language-Specific Tools

- [Python](https://www.python.org/): Python programming language
- [Ruby](https://www.ruby-lang.org/): Ruby programming language
- [PHP](https://www.php.net/): PHP programming language
- [Node.js](https://nodejs.org/): JavaScript runtime

## Directory Structure

```
.
├── Brewfile                # Homebrew packages
├── README.md               # This file
├── git                     # Git configuration
│   ├── .gitconfig          # Git configuration
│   └── .gitignore_global   # Global Git ignore patterns
├── install.sh              # Installation script
├── macos                   # macOS configuration
│   └── defaults.sh         # macOS defaults
├── starship                # Starship prompt configuration
│   └── starship.toml       # Starship configuration
├── tools                   # Tool-specific configurations
│   ├── aws.zsh             # AWS configuration
│   ├── docker.zsh          # Docker configuration
│   ├── kubernetes.zsh      # Kubernetes configuration
│   └── terraform.zsh       # Terraform configuration
├── vim                     # Vim configuration
│   └── .vimrc              # Vim configuration
├── vscode                  # VS Code configuration
│   ├── extensions.txt      # VS Code extensions
│   ├── keybindings.json    # VS Code keybindings
│   └── settings.json       # VS Code settings
└── zsh                     # Zsh configuration
    ├── .aliases            # Shell aliases
    ├── .exports            # Environment variables
    ├── .functions          # Shell functions
    ├── .zprofile           # Login shell configuration
    └── .zshrc              # Main Zsh configuration
```

## Credits

These dotfiles are inspired by and borrow from many other dotfiles repositories, including:

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [holman/dotfiles](https://github.com/holman/dotfiles)
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)
- [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
- [alrra/dotfiles](https://github.com/alrra/dotfiles)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
