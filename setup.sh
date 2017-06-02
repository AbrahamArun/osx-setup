#!/bin/bash

# import utilities
source scripts/shell/utils.sh

# Warn user this script will overwrite current dotfiles
while true; do
  read -p "Warning: this will overwrite your current dotfiles. Continue? [y/n] " yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

# Get the dotfiles directory's absolute path
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare -a FILES_TO_SYMLINK=(
  'scripts/shell/zshrc'
)

symlink-dotfiles () {
  local i=''
  local sourceFile=''
  local targetFile=''
  for i in ${FILES_TO_SYMLINK[@]}; do
    sourceFile="$(pwd)/$i"
    targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [ ! -e "$targetFile" ]; then
      execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
    elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
      print_success "$targetFile → $sourceFile"
    else
      ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
      if answer_is_yes; then
        rm -rf "$targetFile"
        execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
      else
        print_error "$targetFile → $sourceFile"
      fi
    fi

  done
  unset FILES_TO_SYMLINK
}

copy-binaries () {
  # Copy binaries
  ln -fs $HOME/dotfiles/bin $HOME
  declare -a BINARIES=(
    'batcharge.py'
    'crlf'
    'dups'
    'git-delete-merged-branches'
    'nyan'
    'passive'
    'proofread'
    'ssh-key'
    'weasel'
  )
  for i in ${BINARIES[@]}; do
    echo "Changing access permissions for binary script :: ${i##*/}"
    chmod +rwx $HOME/bin/${i##*/}
  done
  unset BINARIES
}

set-online-check-cron-job () {
  # Symlink online-check.sh
  ln -fs $DOTFILES_DIR/scripts/shell/online-check.sh $HOME/online-check.sh
  # Write out current crontab
  crontab -l > mycron
  # Echo new cron into cron file
  echo "* * * * * ~/online-check.sh" >> mycron
  # Install new cron file
  crontab mycron
  rm mycron
}

config-iterm() {
  # TODO Make sure that iTerm is installed
  # Install the Solarized Dark theme for iTerm
  open "${DOTFILES_DIR}/scripts/iterm/themes/Solarized Dark.itermcolors"
  # Don’t display the annoying prompt when quitting iTerm
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false
  cp -rf ${DOTFILES_DIR}/scripts/iterm/com.googlecode.iterm2.plist ~/Library/Preferences
}

main () {
  chsh -s $(which zsh)
  source ~/.zshrc

  symlink-dotfiles
  copy-binaries
  set-online-check-cron-job

  # Install Zsh settings
  echo "${DOTFILES_DIR}/scripts/zsh/themes/arun.zsh-theme"
  cp -rf $DOTFILES_DIR/scripts/zsh/themes/arun.zsh-theme $HOME/.oh-my-zsh/themes
  # Only use UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4
  config-iterm
  # Reload zsh settings
  source ~/.zshrc
}

main