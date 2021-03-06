#!/bin/bash

# Installs Homebrew and some of the common dependencies needed/desired for software development

# Ask for the administrator password upfront
sudo -v

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap Goles/battery

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install the Homebrew packages I use on a day-to-day basis.
apps=(
    httpie
    git
    nvm
    homebrew/completions/brew-cask-completion
    tree
    wget
    wifi-password
    fortune
    ponysay
)

brew install "${apps[@]}"

# set up nvm
mkdir ~/.nvm
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

brew link "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup

brew doctor
