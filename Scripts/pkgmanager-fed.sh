#!/bin/bash
# Fedora package list manager: save, restore, or selectively restore
# explicitly installed packages (RPMs and, optionally, Flatpaks).

set -u

LIST_DIR="$HOME/Documents/Packagelists"
PKG_LIST="$LIST_DIR/pkglist.txt"
FLATPAK_LIST="$LIST_DIR/flatpaklist.txt"

mkdir -p "$LIST_DIR"

# ---------- helpers ----------

have_flatpak() { command -v flatpak >/dev/null 2>&1; }

# Copy an existing list to a timestamped .bak file before it gets replaced.
backup_if_exists() {
    local file="$1" stamp
    if [[ -f "$file" ]]; then
        stamp=$(date +%Y%m%d-%H%M%S)
        cp -- "$file" "$file.$stamp.bak"
        echo "Backed up $(basename "$file") -> $(basename "$file").$stamp.bak"
    fi
}

# Ask a y/n/q question. Returns 0 = yes, 1 = no, 2 = quit.
ask() {
    local reply
    while true; do
        read -r -p "$1 [y/N/q] " reply
        case "${reply,,}" in
            y|yes)      return 0 ;;
            n|no|"")    return 1 ;;
            q|quit)     return 2 ;;
            *) echo "Please answer y, n or q." ;;
        esac
    done
}

# ---------- option 1: create list ----------

create_list() {
    local tmp
    tmp=$(mktemp)

    echo "Querying explicitly installed packages..."
    if dnf repoquery --userinstalled --queryformat '%{name}\n' | sort -u > "$tmp" && [[ -s "$tmp" ]]; then
        backup_if_exists "$PKG_LIST"
        mv -- "$tmp" "$PKG_LIST"
        echo "Saved $(wc -l < "$PKG_LIST") packages to $PKG_LIST"
    else
        rm -f -- "$tmp"
        echo "Failed to get the package list; existing list left untouched." >&2
        return 1
    fi

    if have_flatpak; then
        tmp=$(mktemp)
        if flatpak list --app --columns=application > "$tmp" && [[ -s "$tmp" ]]; then
            backup_if_exists "$FLATPAK_LIST"
            mv -- "$tmp" "$FLATPAK_LIST"
            echo "Saved $(wc -l < "$FLATPAK_LIST") Flatpaks to $FLATPAK_LIST"
        else
            rm -f -- "$tmp"
            echo "No Flatpaks found (or query failed); Flatpak list not updated."
        fi
    fi
}

# ---------- option 2: reinstall everything ----------

reinstall_all() {
    if [[ ! -f "$PKG_LIST" ]]; then
        echo "No package list found at $PKG_LIST. Run option 1 first." >&2
        return 1
    fi

    local pkgs
    mapfile -t pkgs < <(grep -Ev '^\s*(#|$)' "$PKG_LIST")

    if ((${#pkgs[@]} == 0)); then
        echo "The package list is empty."
    else
        echo "Installing ${#pkgs[@]} packages (unavailable ones will be skipped)..."
        sudo dnf install -y --skip-unavailable "${pkgs[@]}"
    fi

    if have_flatpak && [[ -f "$FLATPAK_LIST" ]]; then
        local apps
        mapfile -t apps < <(grep -Ev '^\s*(#|$)' "$FLATPAK_LIST")
        if ((${#apps[@]} > 0)); then
            echo "Installing ${#apps[@]} Flatpaks..."
            flatpak install -y "${apps[@]}"
        fi
    fi
}

# ---------- option 3: reinstall, asking per package ----------

reinstall_interactive() {
    if [[ ! -f "$PKG_LIST" ]]; then
        echo "No package list found at $PKG_LIST. Run option 1 first." >&2
        return 1
    fi

    local pkgs chosen=() pkg rc
    mapfile -t pkgs < <(grep -Ev '^\s*(#|$)' "$PKG_LIST")

    echo "Answer y (install), n (skip, default) or q (stop asking)."
    for pkg in "${pkgs[@]}"; do
        if rpm -q --quiet "$pkg"; then
            continue   # already installed
        fi
        ask "Install $pkg?"
        rc=$?
        if ((rc == 0)); then
            chosen+=("$pkg")
        elif ((rc == 2)); then
            break
        fi
    done

    if ((${#chosen[@]} > 0)); then
        echo "Installing ${#chosen[@]} selected packages..."
        sudo dnf install -y --skip-unavailable "${chosen[@]}"
    else
        echo "No RPM packages selected."
    fi

    if have_flatpak && [[ -f "$FLATPAK_LIST" ]]; then
        local apps chosen_apps=() app
        mapfile -t apps < <(grep -Ev '^\s*(#|$)' "$FLATPAK_LIST")
        for app in "${apps[@]}"; do
            if flatpak info "$app" >/dev/null 2>&1; then
                continue
            fi
            ask "Install Flatpak $app?"
            rc=$?
            if ((rc == 0)); then
                chosen_apps+=("$app")
            elif ((rc == 2)); then
                break
            fi
        done
        if ((${#chosen_apps[@]} > 0)); then
            flatpak install -y "${chosen_apps[@]}"
        fi
    fi
}

# ---------- menu ----------

while true; do
    echo
    echo "=== Package list manager ==="
    echo "1) Create package list (backs up the old one)"
    echo "2) Reinstall all packages from the list"
    echo "3) Reinstall from the list, asking for each package"
    echo "q) Quit"
    read -r -p "Choose an option: " choice

    case "$choice" in
        1) create_list ;;
        2) reinstall_all ;;
        3) reinstall_interactive ;;
        q|Q) exit 0 ;;
        *) echo "Invalid choice." ;;
    esac
done
