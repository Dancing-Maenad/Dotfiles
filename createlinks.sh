#!/usr/bin/env bash
#
# restore-links.sh: create the dotfile symlinks on a new machine.
#
# Reads the same list file as the copy-and-link script, then for each entry
# creates a symlink from the system path to the matching item in the dotfiles
# repo. It only ever ADDS symlinks (and any missing parent directories for
# them). It never moves, copies, overwrites or deletes anything: if a path
# already exists, it is left exactly as it is.
#
# Usage: restore-links.sh [-n] [-l LIST_FILE] [-d DOTFILES_DIR]
#   -n, --dry-run     show what would be linked, change nothing
#   -l, --list FILE   list file to read (default: ~/.config/git-symlink/list)
#   -d, --dotfiles D  dotfiles repo (default: ~/Git/dotfiles)

set -u

DOTFILES_DIR="$HOME/Git/dotfiles"
LIST_FILE="$HOME/.config/git-symlink/list"
DRY_RUN=0

while [ $# -gt 0 ]; do
    case "$1" in
        -n|--dry-run)  DRY_RUN=1 ;;
        -l|--list)     [ $# -ge 2 ] || { echo "Error: $1 needs a value" >&2; exit 2; }
                       LIST_FILE="$2"; shift ;;
        -d|--dotfiles) [ $# -ge 2 ] || { echo "Error: $1 needs a value" >&2; exit 2; }
                       DOTFILES_DIR="$2"; shift ;;
        -h|--help)     sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *)             echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
    esac
    shift
done

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Error: dotfiles directory not found: $DOTFILES_DIR" >&2
    echo "Clone your repo there first, or pass -d /path/to/repo." >&2
    exit 1
fi

if [ ! -f "$LIST_FILE" ]; then
    echo "Error: list file not found: $LIST_FILE" >&2
    echo "Copy it over from your old machine (it isn't part of the repo), or pass -l /path/to/list." >&2
    exit 1
fi

# Read the list into the CONFIGS array (same rules as the copy-and-link script)
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

    # Drop trailing slashes: "dir/" makes ln fail and hides symlinks from -L
    while [[ $line == */ && $line != "/" ]]; do line="${line%/}"; done

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

if [ "$DRY_RUN" -eq 1 ]; then
    echo "Dry run: nothing will be changed."
fi
echo "Linking from $DOTFILES_DIR using $LIST_FILE ..."

declare -A seen=()
linked=0; already=0; skipped=0; missing=0; failed=0

for src in "${CONFIGS[@]}"; do
    name=$(basename -- "$src")
    repo="$DOTFILES_DIR/$name"

    # The repo stores each item under its base name, so two entries with the
    # same name would point at the same repo item. Keep the first only.
    if [ -n "${seen[$name]:-}" ]; then
        echo "[WARN] $src has the same name as ${seen[$name]}; skipping it."
        skipped=$((skipped + 1))
        continue
    fi
    seen[$name]="$src"

    # Nothing to link to?
    if [ ! -e "$repo" ] && [ ! -L "$repo" ]; then
        echo "[MISSING] '$name' is not in $DOTFILES_DIR, so there is nothing to link for $src."
        missing=$((missing + 1))
        continue
    fi

    # Already a symlink: fine if it points at the repo, otherwise leave it alone
    if [ -L "$src" ]; then
        if [ "$(readlink -f -- "$src")" = "$(readlink -f -- "$repo")" ]; then
            echo "[OK] $src already links to the repo."
            already=$((already + 1))
        else
            echo "[SKIP] $src is a symlink to $(readlink -- "$src"); leaving it alone."
            skipped=$((skipped + 1))
        fi
        continue
    fi

    # A real file or directory is already there: never touch it
    if [ -e "$src" ]; then
        echo "[SKIP] $src already exists (not a symlink); leaving it untouched."
        skipped=$((skipped + 1))
        continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[DRY RUN] would link $src -> $repo"
        linked=$((linked + 1))
        continue
    fi

    # Create missing parent directories (additive only), then the link.
    # No -f on ln, so an existing path can never be overwritten.
    if ! mkdir -p -- "$(dirname -- "$src")"; then
        echo "[FAILED] could not create the parent directory for $src"
        failed=$((failed + 1))
        continue
    fi
    if ln -s -- "$repo" "$src"; then
        echo "[LINKED] $src -> $repo"
        linked=$((linked + 1))
    else
        echo "[FAILED] could not create the link $src"
        failed=$((failed + 1))
    fi
done

echo
echo "Done: $linked linked, $already already correct, $skipped skipped, $missing missing from the repo, $failed failed."
[ "$failed" -eq 0 ]
