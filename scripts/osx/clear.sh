#!/bin/bash

echo "Grant sudo permission to run this script"

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

echo "Clearing all ..."
rm -rf ~/.zsh*
rm -rf ~/.oh-my-zsh/
rm -rf ~/.bash_profile
rm -rf ~/.bash_prompt
rm -rf ~/.bashrc
rm -rf ~/.shell_aliases
rm -rf ~/.shell_exports
rm -rf ~/.zsh_history
rm -rf ~/online-check.sh
rm -rf ~/.curlrc
rm -rf ~/.gemrc
rm -rf ~/.gitattributes
rm -rf ~/.gitconfig
rm -rf ~/.gitignore
rm -rf ~/.inputrc
rm -rf ~/.screenrc
rm -rf ~/.shell_config
rm -rf ~/.shell_functions

rm -rf /usr/local/sbin

echo "Setting default shell back to bash"
chsh -s /bin/bash

echo "clear all crontabs"
crontab -r

echo 'remove iterm prefs'
rm -rf ~/Library/Preferences/com.googlecode.iterm2.plist

rm -rf ~/bin
