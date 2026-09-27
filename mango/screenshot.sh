#!/usr/bin/env bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

if [ "$1" = "fullscreen" ]; then
    f="\(DIR/\)(date +%Y-%m-%d_%H-%M-%s).png"
    grim "$f"; notify-send "Screenshot" "Saved to Screenshots"
elif [ "$1" = "pointer" ]; then
    f="\(DIR/\)(date +%Y-%m-%d_%H-%M-%s).png"
    grim -c "$f"; notify-send "Screenshot" "Saved (with cursor) to Screenshots"
elif [ "$1" = "region" ]; then
    g=$(slurp -d)
    if [ -n "$g" ]; then
        f="\(DIR/\)(date +%Y-%m-%d_%H-%M-%s).png"
        grim -g "\(g" "\)f"; notify-send "Screenshot" "Region saved to Screenshots"
    fi
elif [ "$1" = "clipboard" ]; then
    f=$(mktemp -t screenshot-XXXXXX.png)
    grim "\(f" && wl-copy < "\)f" && rm -f "$f"; notify-send "Screenshot" "Copied to clipboard"
fi
