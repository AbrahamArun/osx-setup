#!/bin/bash
#
# args=("vlc" "atom" "org.videolan.vlc" "mate" "google" "zenmate" "skype" "mapbox" "TextMate" "github" "Flowdock" "DiskInventoryX" "deckhub" "cisco" "bittorrent" "resilio" "samsung" "spotify" "sublimetext" "adware" "toggl" "trolltech" "visualpharm" "sourceforge" "tunnelblick" "mozilla" "tor" "virtualbox")
# pat=$(echo ${args[@]}|tr " " "|")
# arr=(`ls ~/Library/Preferences | grep -E "${pat}"`)
# echo $arr
#
# for files in "${arr[@]}"; do
#     echo "Removing preferences for => "$files
#     rm -rf ~/Library/Preferences/"$files"
# done


echo "removing extras from ~/Library"
args2=("Google" "GoogleSoftwareUpdate" "Chrome" "vlc" "atom" "org.videolan.vlc" "mate" "google" "zenmate" "skype" "mapbox" "TextMate" "github" "Flowdock" "DiskInventoryX" "deckhub" "cisco" "bittorrent" "resilio" "samsung" "spotify" "sublimetext" "adware" "toggl" "trolltech" "visualpharm" "sourceforge" "tunnelblick" "mozilla" "tor" "virtualbox")
pat2=$(echo ${args2[@]}|tr " " "|")
arr2=(`ls ~/Library | grep -E "${pat2}"`)
echo $arr

for files in "${arr2[@]}"; do
    echo "Removing preferences for => "$files
    rm -rf ~/Library/"$files"
done
