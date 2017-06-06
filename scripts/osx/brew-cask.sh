#!/bin/bash

# Install Caskroom
brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# Install packages
apps=(
    atom
    flux
    flowdock
    google-drive
    iterm2
    kindle
    google-chrome
    google-chrome-canary
    screenflow
    resilio-sync
    skype
    spectacle
    vagrant
    vagrant-manager
    virtualbox
    virtualbox-extension-pack
    android-platform-tools
)

# TODO: See if this can be automated
#Warning: Accessibility access cannot be enabled automatically on this version of macOS.
#See System Preferences to enable it manually.
brew cask install "${apps[@]}"
