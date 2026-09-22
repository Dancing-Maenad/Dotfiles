#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

USERNAME="Dancing-Maenad"
REPO_URL="github.com/${USERNAME}/Dotfiles.git"

echo "=== Dotfiles GitHub Sync ==="

# 1. Prompt for commit message
read -p "Enter commit message: " commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="Update dotfiles"
fi

# 2. Prompt securely for the GitHub Personal Access Token (hidden input)
read -s -p "Enter your GitHub Personal Access Token (PAT): " token
echo "" # Adds a newline after the hidden password input

if [ -z "$token" ]; then
    echo "Error: Token cannot be empty."
    exit 1
fi

# 3. Stage all changes
echo "Staging files..."
git add .

# 4. Commit changes (only if there's something to commit)
if git diff-index --quiet HEAD --; then
    echo "No changes to commit."
else
    echo "Committing changes..."
    git commit -m "$commit_msg"
fi

# 5. Push to GitHub using the token dynamically (without saving it to config)
echo "Pushing to GitHub..."
git push "https://${USERNAME}:${token}@${REPO_URL}" main

echo "Successfully synced with GitHub!"
