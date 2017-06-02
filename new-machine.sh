# Get the dotfiles directory's absolute path
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# This is my parent dev directory. I have all my dev related stuff in this directory, such as git repositories, scripts etc.
mkdir -p ~/code


###############################################################################
# XCode Command Line Tools                                                    #
###############################################################################

if ! xcode-select --print-path &> /dev/null; then

  # Prompt user to install the XCode Command Line Tools
  xcode-select --install &> /dev/null

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Wait until the XCode Command Line Tools are installed
  until xcode-select --print-path &> /dev/null; do
    sleep 5
  done

  print_result $? 'Install XCode Command Line Tools'

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Point the `xcode-select` developer directory to
  # the appropriate directory from within `Xcode.app`
  # https://github.com/alrra/dotfiles/issues/13

  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
  print_result $? 'Make "xcode-select" developer directory point to Xcode'

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Prompt user to agree to the terms of the Xcode license
  # https://github.com/alrra/dotfiles/issues/10

  sudo xcodebuild -license
  print_result $? 'Agree with the XCode Command Line Tools licence'

fi

###############################################################################
# Seagate NTFS driver                                                                    #
###############################################################################

sh $DOTFILES_DIR/scripts/osx/install-ntfs-driver.sh

###############################################################################
# Node                                                                        #
###############################################################################

sh $DOTFILES_DIR/scripts/osx/npm.sh


###############################################################################
# Homebrew                                                                    #
###############################################################################

caffeinate -id $DOTFILES_DIR/scripts/osx/brew.sh
caffeinate -id $DOTFILES_DIR/scripts/osx/brew-cask.sh

###############################################################################
# OSX defaults                                                                #
# https://github.com/hjuutilainen/dotfiles/blob/master/bin/osx-user-defaults.sh
###############################################################################

caffeinate -id sh $DOTFILES_DIR/scripts/osx/set-defaults.sh

###############################################################################
# Symlinks to link dotfiles into ~/                                           #
###############################################################################

brew doctor
