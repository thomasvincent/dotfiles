#!/bin/bash
# =============================================================================
# macOS System Preferences Configuration
# =============================================================================
#
# This script configures macOS system preferences for a developer-friendly
# setup. Run once after a fresh macOS install or when you want to reset.
#
# Usage:
#   chmod +x scripts/macos-defaults.sh
#   ./scripts/macos-defaults.sh
#
# Note: Some changes require a logout/restart to take effect.
#
# =============================================================================

set -e

echo "🍎 Configuring macOS defaults..."
echo ""

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

# Ask for administrator password upfront
sudo -v

# Keep sudo alive during script execution
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# =============================================================================
# GENERAL UI/UX
# =============================================================================
echo "⚙️  Configuring General UI/UX..."

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# =============================================================================
# KEYBOARD
# =============================================================================
echo "⌨️  Configuring Keyboard..."

# Fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Short delay before key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Enable full keyboard access for all controls (Tab in dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# =============================================================================
# TRACKPAD
# =============================================================================
echo "🖱️  Configuring Trackpad..."

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# =============================================================================
# FINDER
# =============================================================================
echo "📁 Configuring Finder..."

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Expand File Info panes
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# =============================================================================
# DOCK
# =============================================================================
echo "🚀 Configuring Dock..."

# Set Dock icon size
defaults write com.apple.dock tilesize -int 48

# Enable magnification
defaults write com.apple.dock magnification -bool true

# Set magnification size
defaults write com.apple.dock largesize -int 64

# Minimize windows using scale effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Don't animate opening applications
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Speed up Dock auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# =============================================================================
# SAFARI
# =============================================================================
echo "🌐 Configuring Safari..."

# Enable Safari's debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing Web Inspector
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Show the full URL in the address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Prevent Safari from opening 'safe' files automatically
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Privacy: don't send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# =============================================================================
# TERMINAL & ITERM2
# =============================================================================
echo "💻 Configuring Terminal..."

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Enable Secure Keyboard Entry in Terminal.app
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable line marks in Terminal.app
defaults write com.apple.Terminal ShowLineMarks -int 0

# =============================================================================
# ACTIVITY MONITOR
# =============================================================================
echo "📊 Configuring Activity Monitor..."

# Show the main window when launching
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Show CPU usage in Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# =============================================================================
# SCREENSHOTS
# =============================================================================
echo "📸 Configuring Screenshots..."

# Create Screenshots folder
mkdir -p ~/Desktop/Screenshots

# Save screenshots to Desktop/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"

# Save screenshots as PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# =============================================================================
# ENERGY SAVING
# =============================================================================
echo "🔋 Configuring Energy Saving..."

# Enable lid wakeup
sudo pmset -a lidwake 1

# Sleep after 15 minutes on battery
sudo pmset -b sleep 15

# Sleep after 30 minutes on power
sudo pmset -c sleep 30

# Disable machine sleep while charging
sudo pmset -c displaysleep 15 sleep 0

# =============================================================================
# TIME MACHINE
# =============================================================================
echo "⏰ Configuring Time Machine..."

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# =============================================================================
# SSD-SPECIFIC TWEAKS (if applicable)
# =============================================================================
if diskutil info / | grep -q "Solid State"; then
    echo "💾 Applying SSD tweaks..."
    # Disable hibernation (speeds up entering sleep mode)
    sudo pmset -a hibernatemode 0
fi

# =============================================================================
# SECURITY & PRIVACY
# =============================================================================
echo "🔒 Configuring Security & Privacy..."

# Enable Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Enable Stealth Mode (don't respond to ICMP probes)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Enable firewall logging
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable Gatekeeper nag for downloaded apps
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Restart on freeze
sudo systemsetup -setrestartfreeze on 2>/dev/null || true

# Restart on power loss
sudo pmset -a autorestart 1

# Set standby delay to 24 hours
sudo pmset -a standbydelay 86400

# =============================================================================
# PHOTOS & MAIL
# =============================================================================
echo "📷 Configuring Photos & Mail..."

# Prevent Photos from opening when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Copy email addresses as plain text (not "Name <email>")
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable inline attachments in Mail
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# =============================================================================
# TEXT EDIT
# =============================================================================
echo "📝 Configuring TextEdit..."

# Use plain text mode by default
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# =============================================================================
# SOUND
# =============================================================================
echo "🔇 Configuring Sound..."

# Disable boot sound
sudo nvram SystemAudioVolume=" " 2>/dev/null || true

# =============================================================================
# RESTART AFFECTED APPLICATIONS
# =============================================================================
echo ""
echo "🔄 Restarting affected applications..."

for app in "Activity Monitor" \
    "cfprefsd" \
    "Dock" \
    "Finder" \
    "Safari" \
    "SystemUIServer" \
    "Terminal"; do
    killall "${app}" &> /dev/null || true
done

echo ""
echo "✅ macOS defaults configured!"
echo ""
echo "⚠️  Note: Some changes require a logout/restart to take effect."
echo "   Consider restarting your Mac for all changes to apply."
