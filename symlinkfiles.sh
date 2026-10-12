#!/usr/bin/env bash

# Set your dotfiles repository path
DOTFILES_DIR="$HOME/Git/dotfiles"

# The paths to manage are read from this list file (one path per line)
LIST_DIR="$HOME/.config/git-symlink"
LIST_FILE="$LIST_DIR/list"

# Create the list file (with a short how-to header) if it doesn't exist yet
if [ ! -f "$LIST_FILE" ]; then
    if mkdir -p "$LIST_DIR" && cat > "$LIST_FILE" <<'EOF'
# One path per line. Lines starting with # and blank lines are ignored.
# Use absolute paths; ~ and $HOME are expanded. Examples:
#
# ~/.zshrc
# ~/.config/kitty
# $HOME/.config/nvim
EOF
    then
        echo "Created a new list file: $LIST_FILE"
    else
        echo "Error: could not create $LIST_FILE" >&2
        exit 1
    fi
fi

# Read the list into the CONFIGS array
declare -a CONFIGS=()
while IFS= read -r line || [ -n "$line" ]; do
    line="${line%$'\r'}"                          # tolerate Windows line endings
    line="${line#"${line%%[![:space:]]*}"}"       # trim leading whitespace
    line="${line%"${line##*[![:space:]]}"}"       # trim trailing whitespace
    [[ -z $line || $line == \#* ]] && continue    # skip blanks and comments

    # Expand ~ and $HOME (plain text replacement, nothing is evaluated)
    [[ $line == "~" ]] && line="$HOME"
    [[ $line == "~/"* ]] && line="$HOME/${line:2}"
    line="${line//\$HOME/$HOME}"

    if [[ $line != /* ]]; then
        echo "[INVALID] Ignoring '$line' (use an absolute path, ~/... or \$HOME/...)"
        continue
    fi
    CONFIGS+=("$line")
done < "$LIST_FILE"

if [ "${#CONFIGS[@]}" -eq 0 ]; then
    echo "Your list is empty: $LIST_FILE"
    echo "Add one path per line (e.g. ~/.zshrc) and run this script again."
    exit 0
fi

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

        # Replace any existing repo copy of a directory so stale files don't linger
        if [ -d "$src" ]; then
            rm -rf "$dest"
        fi

        # Copy to the repo (-a keeps permissions and timestamps). If the copy
        # fails, leave the original untouched and move on.
        if ! cp -a "$src" "$dest"; then
            echo "  !! Copy failed, leaving $src untouched."
            continue
        fi
        echo "  -> Copied $name to $dest"

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
