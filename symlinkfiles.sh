#!/usr/bin/env bash

# Set your dotfiles repository path
DOTFILES_DIR="$HOME/Git/dotfiles"

# List your configuration paths here. Easily add more as needed!
declare -a CONFIGS=(
    "$HOME/.swayidle"
    "$HOME/.zshrc"
    "$HOME/.config/starship.toml"
    "$HOME/.config/fish"
    "$HOME/.config/noctalia"
    "$HOME/.config/alacritty"
    "$HOME/.config/hypr"
    "$HOME/.config/foot"
    "$HOME/.config/ghostty"
    "$HOME/.config/niri"
    "$HOME/.config/mango"
    "$HOME/.config/nvim"
    "$HOME/.config/input-remapper-2"
    "$HOME/.config/hyfetch.json"
)

echo "Starting dotfiles copy and link process..."

for src in "${CONFIGS[@]}"; do
    # Check if the source directory/file actually exists on your system
    if [ -e "$src" ]; then
        name=$(basename "$src")
        dest="$DOTFILES_DIR/$name"

        # Skip if the system path is already a symlink
        if [ -L "$src" ]; then
            echo "[SKIP] $src is already a symlink."
            continue
        fi

        echo "[PROCESS] Handling $name..."

        # Copy files to repo (overwrite if repo version already exists)
        if [ -d "$src" ]; then
            rm -rf "$dest"
            cp -r "$src" "$dest"
            echo "  -> Copied directory to $dest"
        else
            cp "$src" "$dest"
            echo "  -> Copied file to $dest"
        fi

        # Remove original local folder/file to prepare for symlinking
        rm -rf "$src"

        # Create the outward symlink from system path pointing into the repo
        ln -s "$dest" "$src"
        echo "  -> Linked $src -> $dest"
        
    else
        echo "[NOT FOUND] Skipping $src (does not exist on system)."
    fi
done

echo "All done! Your dotfiles have been copied to the repo and linked."
