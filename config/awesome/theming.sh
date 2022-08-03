#!/bin/bash

## wal colors & program theming
wal -i ~/Pictures/Wallpapers/cyberpunk-highlife.jpg 
source "${HOME}/.cache/wal/colors.sh" 
xrdb ~/.cache/wal/colors.Xresources 
cp ~/.cache/wal/colors.Xresources ~/.Xresources
/usr/bin/wpg -s "$wallpaper" -n

# Individual app theming
# /usr/bin/pywalfox start &
/usr/bin/pywalfox update &
/usr/bin/wal-telegram --wal &
/usr/bin/spicetify apply -q -n &

feh --bg-fill "$wallpaper"
