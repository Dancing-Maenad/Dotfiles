#!/usr/bin/env bash

# Set your dotfiles repository path
DOTFILES_DIR="$HOME/Git/dotfiles"

# List your configuration paths here. Easily add more as needed!
declare -a CONFIGS=(
    "$HOME/.swayidle"
    "$HOME/.config/noctalia"
    "$HOME/.config/alacritty"
    "$HOME/.config/hypr"
    "$HOME/.config/foot"
    "$HOME/.config/ghostty"
    "$HOME/.config/niri"
    "$HOME/.config/mango"
)

echo "Starting safe dotfiles copy process..."

for src in "${CONFIGS[@]}"; do
    if [ -e "$src" ]; then
        name=$(basename "$src")
        dest="$DOTFILES_DIR/$name"

        echo "[COPY] Copying $name to repo..."
        
        # Ensure parent directory exists in destination if needed
        mkdir -p "$(dirname "$dest")"

        # Safely copy, overwriting if it's already there
        rm -rf "$dest"
        cp -r "$src" "$dest"
        echo "  -> Successfully copied to $dest"
        
    else
        echo "[NOT FOUND] Skipping $src (does not exist on system)."
    fi
done

echo "All done! Your files are safely copied into $DOTFILES_DIR. Your originals remain entirely untouched."
