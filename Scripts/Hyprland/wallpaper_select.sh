#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
IMG=$(find "$WALLPAPER_DIR" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o \
  -iname "*.png" -o -iname "*.webp" -o \
  -iname "*.gif" \
\) | shuf -n 1)
swww init &> /dev/null
sleep 0.5  # Give it a moment to start, because it's moody
swww img "$IMG" --transition-type any --transition-step 50 --transition-fps 60
