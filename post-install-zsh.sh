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
  'scripts/shell/shell_exports'
  'scripts/shell/shell_aliases'
  'scripts/shell/shell_config'
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
  ln -fs $DOTFILES_DIR/bin $HOME
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

git-config() {
  git config --global user.name "Arun Abraham"
  git config --global user.email "arun4xp@gmail.com"
}

install-patched-powerline-font {
  git clone https://github.com/powerline/fonts.git
  sh fonts/install.sh
  rm -rf fonts
  echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
}

main () {
  chsh -s $(which zsh)
  source ~/.zshrc
  install-patched-powerline-font
  symlink-dotfiles
  copy-binaries
  set-online-check-cron-job

  # Install Zsh settings
  echo "${DOTFILES_DIR}/scripts/zsh/themes/arun.zsh-theme"
  cp -rf $DOTFILES_DIR/scripts/zsh/themes/arun.zsh-theme $HOME/.oh-my-zsh/themes
  # Only use UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4
  config-iterm

  git-config
  # Reload zsh settings
  source ~/.zshrc
}

main
