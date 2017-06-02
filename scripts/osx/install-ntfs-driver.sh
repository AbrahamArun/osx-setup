#!/bin/bash
echo $DOTFILES_DIR
hdiutil mount $DOTFILES_DIR/bin/NTFS_for_Mac.dmg

cp -R "/Volumes/ParagonFS.localized/FSInstaller.app" /Applications
echo "Seagate driver installer is moved to your applications. Run the installer."
