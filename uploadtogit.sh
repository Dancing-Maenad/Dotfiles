#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

# Where the dotfiles repo lives (same as the symlink script)
DOTFILES_DIR="$HOME/Git/dotfiles"

# Where the GitHub username is stored
CONFIG_DIR="$HOME/.config/gituploadscript"
USERNAME_FILE="$CONFIG_DIR/username"

echo "=== Dotfiles GitHub Sync ==="

# 0. Make sure the dotfiles repo exists, then work from it no matter where
#    this script was started
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "Error: $DOTFILES_DIR is not a git repository." >&2
    exit 1
fi
cd "$DOTFILES_DIR"

# 1. Read the GitHub username from the file, asking for it if it's missing
USERNAME=""
if [ -f "$USERNAME_FILE" ]; then
    IFS= read -r USERNAME < "$USERNAME_FILE" || true
    USERNAME="${USERNAME//[[:space:]]/}"       # strip any whitespace
fi

if [ -z "$USERNAME" ]; then
    echo "No GitHub username saved yet."
    while true; do
        read -r -p "Enter your GitHub username: " USERNAME \
            || { echo; echo "Error: no username entered." >&2; exit 1; }
        USERNAME="${USERNAME//[[:space:]]/}"
        # GitHub usernames are letters, digits and hyphens only
        if [[ $USERNAME =~ ^[A-Za-z0-9-]+$ ]]; then
            break
        fi
        echo "That doesn't look like a valid GitHub username, try again."
    done
    mkdir -p "$CONFIG_DIR"
    printf '%s\n' "$USERNAME" > "$USERNAME_FILE"
    echo "Saved username to $USERNAME_FILE"
fi

REPO_URL="github.com/${USERNAME}/Dotfiles.git"

# 2. Prompt for commit message
read -r -p "Enter commit message: " commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="Update dotfiles"
fi

# 3. Prompt securely for the GitHub Personal Access Token (hidden input)
read -r -s -p "Enter your GitHub Personal Access Token (PAT): " token
echo "" # Adds a newline after the hidden password input

if [ -z "$token" ]; then
    echo "Error: Token cannot be empty." >&2
    exit 1
fi

# 4. Stage all changes
echo "Staging files..."
git add .

# 5. Commit changes (only if there's something to commit)
if git diff-index --quiet HEAD --; then
    echo "No changes to commit."
else
    echo "Committing changes..."
    git commit -m "$commit_msg"
fi

# 6. Push to GitHub using the token dynamically (without saving it to config)
echo "Pushing to GitHub..."
git push "https://${USERNAME}:${token}@${REPO_URL}" main

echo "Successfully synced with GitHub!"
