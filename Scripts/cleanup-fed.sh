#!/bin/bash

# Auto-cleanup script for Fedora systems

echo "🚿 Starting system cleanup..."

# 1. Remove orphaned packages (leaves configuration files intact, use autoremove)
echo -e "\n🔍 Checking for system orphaned packages..."
orphans=$(dnf repoquery --unneeded --qf "%{name}")

if [[ -z "$orphans" ]]; then
  echo "✅ No system orphans found."
else
  echo "⚠️ Found system orphans:"
  echo "$orphans"
  read -rp "➤ Remove these packages? [y/N]: " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo dnf autoremove
  else
    echo "❎ Skipping system orphan removal."
  fi
fi

# 2. Clean package cache
echo -e "\n🧹 Cleaning DNF package cache..."
read -rp "➤ Clean old cached packages (dnf clean packages)? [y/N]: " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  sudo dnf clean packages
else
  echo "❎ Skipping DNF cache cleaning."
fi

echo -e "\n🏁 Cleanup complete!"
