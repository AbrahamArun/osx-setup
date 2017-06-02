#!/bin/bash

#
# Reasonably sets OS X defaults. My sources:
#  - https://github.com/skwp/dotfiles/blob/master/bin/osx
#  - https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# ~/dotfiles/osx/set-defaults.sh — http://mths.be/osx
#

# Set computer name
COMPUTERNAME="Arun Abraham (Fybr)"
HOSTNAME='arun'
LOCALHOSTNAME='arun'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName $COMPUTERNAME
sudo scutil --set HostName $HOSTNAME
sudo scutil --set LocalHostName $LOCALHOSTNAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $LOCALHOSTNAME

###############################################################################
# Apple software: Safari, Updater, iTunes, etc.                               #
###############################################################################

echo "Configuring Safari settings"
# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write -g WebKitDeveloperExtras -bool true

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Use AirDrop over every interface.
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Check for software updates daily, not just once per week.
defaults write com.assple.SoftwareUpdate ScheduleFrequency -int 1


###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo "Configuring Activity Monitor settings"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Interfaces: trackpad, mouse, keyboard, bluetooth, etc.
###############################################################################


###############################################################################
# Screen
###############################################################################

echo "Configuring Screen settings"

# Require password immediately after sleep or screen saver.
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to desktop and disable the horrific drop-shadow.
screenshotLocation="${HOME}/Desktop/Screenshots"
mkdir -p $screenshotLocation
defaults write com.apple.screencapture location -string "${screenshotLocation}"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder
###############################################################################
echo "Configuring Finder settings"
# Show the ~/Library folder.
chflags nohidden ~/Library

# # Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
#
# # Always open everything in Finder's column view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
#
# # Show hidden files and file extensions by default
# defaults write com.apple.finder AppleShowAllFiles -bool true
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true
#
# # Disable the warning when changing file extensions
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
#
# # Allow text-selection in Quick Look
# defaults write com.apple.finder QLEnableTextSelection -bool true
#
# # Disable the crash reporter
# defaults write com.apple.CrashReporter DialogType -string "none"

###############################################################################
# SSD
###############################################################################


###############################################################################
# Dock
###############################################################################


###############################################################################
# Do some clean up work.
###############################################################################

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
           "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
           "Terminal" "Twitter" "iCal"; do
           kill all "${app}" > /dev/null 2>&1
done
#
# # Wait a bit before moving on...
sleep 1
#
# # ...and then.
# echo "Success! Defaults are set."
# echo "Some changes will not take effect until you reboot your machine."
#
# # See if the user wants to reboot.
function reboot() {
  read -p "Do you want to reboot your computer now? (y/N)" choice
  case "$choice" in
    y | Yes | yes ) echo "Yes"; exit;; # If y | yes, reboot
    n | N | No | no) echo "No"; exit;; # If n | no, exit
    * ) echo "Invalid answer. Enter \"y/yes\" or \"N/no\"" && return;;
  esac
}
#
# # Call on the function
if [[ "Yes" == $(reboot) ]]
then
  echo "Rebooting."
  sudo reboot
  exit 0
else
  exit 1
fi
