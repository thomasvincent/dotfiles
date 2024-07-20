#!/usr/bin/env bash

# Update Homebrew
brew update

# Upgrade existing packages
brew upgrade

# Store Homebrew's prefix
BREW_PREFIX=$(brew --prefix)

# GNU core utilities (with improved path handling)
brew install coreutils
PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"  # Add to PATH directly

# Other useful utilities
brew install moreutils findutils gnu-sed bash bash-completion2 wget gpg

# Switch default shell to Homebrew's Bash (with error handling)
if ! grep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
    echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
    if ! chsh -s "${BREW_PREFIX}/bin/bash"; then
        echo "Error: Failed to change default shell."
    fi
fi

# Tap additional repositories
brew tap bramstein/webfonttools

# Font tools
brew install sfnt2woff sfnt2woff-zopfli woff2

# CTF (Capture The Flag) tools
brew install aircrack-ng bfg binutils binwalk cifer dex2jar dns2tcp fcrackzip foremost hashpump hydra john knock netpbm nmap pngcheck socat sqlmap tcpflow tcpreplay tcptrace ucspi-tcp xpdf xz

# Other essential binaries
brew install ack git git-lfs gs imagemagick lua lynx p7zip pigz pv rename rlwrap ssh-copy-id tree vbindiff zopfli

# macOS-specific tools
brew install vim grep openssh screen php gmp

# Clean up old versions
brew cleanup
