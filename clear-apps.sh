#!/bin/bash

echo "Grant sudo permission to run this script"

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

echo "Clearing all brew packages"
brew remove --force --ignore-dependencies $(brew list)
brew cask remove --force --ignore-dependencies $(brew cask list)

rm -rf /usr/local/.DS_Store
rm -rf /usr/local/bin/
rm -rf /usr/local/Caskroom/
rm -rf /usr/local/etc/
rm -rf /usr/local/git/
rm -rf /usr/local/lib/
rm -rf /usr/local/remotedesktop/
rm -rf /usr/local/sbin/
rm -rf /usr/local/share/
rm -rf /usr/local/var/

echo "Uninstall brew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

echo "Clearing all apps fom /Applications/…"
apps=(
    Android\ Studio
    AnyDesk
    Atom
    Flowdock
    Flux
    GPG\ Keychain
    Google\ Chrome\ Canary
    Google\ Chrome
    Google\ Drive
    Kindle
    Kodi
    Resilio\ Sync
    ScreenFlow
    Seagate\ Dashboard
    Skype
    Spectacle
    TermHere
    TogglDesktop
    VLC
    Vagrant\ Manager
    VirtualBox
    iTerm
)

apps2=(
    Chrome\ Apps.localized
)

appPrefs=(
    Google
    Dropbox
    GifRocket
    Flux
    Kindle
    Kodi
    Popcorn-Time
    Resilio\ Sync
    # Seagate
    # Seagate Dashboard 2.0
    SideSync
    # Sketch
    Skype
    Spectacle
    Spotify
    TogglDesktop
    TorBrowser-Data
    Transmission
    Tunnelblick
    VLC
    Vagrant\ Manager
    # com.bohemiancoding.sketch3
    com.github.atom.ShipIt
    com.deckhub.app.ShipIt
    org.videolan.vlc
    DeckHub
    TextMate
    TeamViewer
    AndroidStudio*
)

rm -rf ~/Library/Application\ Support

echo "Removing apps from /Applications/"
for files in "${apps[@]}"; do
    rm -rf /Applications/"$files".app
done

echo "Removing apps from ~/Applications/"
for files in "${apps2[@]}"; do
    rm -rf ~/Applications/"$files"
done

echo "Removing prefs from ~/Library/Application\ Support/"
for files in "${appPrefs[@]}"; do
    rm -rf ~/Library/Application\ Support/"$files"
done

echo "removing Prefs from ~/Library/Preferences"
args=("vlc" "atom" "org.videolan.vlc" "mate" "google" "zenmate" "skype" "mapbox" "TextMate" "github" "Flowdock" "DiskInventoryX" "deckhub" "cisco" "bittorrent" "resilio" "samsung" "spotify" "sublimetext" "adware" "toggl" "trolltech" "visualpharm" "sourceforge" "tunnelblick" "mozilla" "tor" "virtualbox" "iterm" "subl")
pat=$(echo ${args[@]}|tr " " "|")
arr=(`ls ~/Library/Preferences | grep -E "${pat}"`)
echo $arr

for files in "${arr[@]}"; do
    echo "Removing preferences for => "$files
    rm -rf ~/Library/Preferences/"$files"
done

echo "removing extras from ~/Library"
args2=("Google" "GoogleSoftwareUpdate" "Chrome" "vlc" "atom" "org.videolan.vlc" "mate" "google" "zenmate" "skype" "mapbox" "TextMate" "github" "Flowdock" "DiskInventoryX" "deckhub" "cisco" "bittorrent" "resilio" "samsung" "spotify" "sublimetext" "adware" "toggl" "trolltech" "visualpharm" "sourceforge" "tunnelblick" "mozilla" "tor" "virtualbox")
pat2=$(echo ${args2[@]}|tr " " "|")
arr2=(`ls ~/Library | grep -E "${pat2}"`)
echo $arr

for files in "${arr2[@]}"; do
    echo "Removing preferences for => "$files
    rm -rf ~/Library/"$files"
done
