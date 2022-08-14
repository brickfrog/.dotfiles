#!/bin/bash

## wal colors & program theming
wal -n -i ~/Pictures/Wallpapers/cyberpunk-high*
feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"  
xrdb -load ~/.cache/wal/colors.Xresources 
cp ~/.cache/wal/colors.Xresources ~/.Xresources
wpg -n -s "$(< "${HOME}/.cache/wal/wal")"

# wal program theming
/usr/bin/pywalfox update &
/usr/bin/wal-telegram --wal &
/usr/bin/spicetify apply -q -n &
