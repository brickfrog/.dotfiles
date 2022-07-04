#!/bin/sh

# My workflow involves a lot of simple screenshots sent via telegram, etc.
# so this sends the screenshot to pngquant to compress, overwriting
# (this is destructive, inplace, so not reccomended generally) then to clipboard
# Thanks to:
# https://unix.stackexchange.com/questions/623516/copying-image-from-scrot-into-clipboard-after-capture

output="${HOME}/Pictures/Screenshots/%Y-%m-%d-%T-screenshot.png"

case "$1" in
	"select") scrot -s "$output" -e 'pngquant $f --ext .png -f && xclip -selection clipboard -t image/png -i $f' --line mode=edge || exit ;;
	*) scrot "$output" || exit ;;
esac

notify-send "Screenshot taken."
