#!/usr/bin/env bash
set -euo pipefail

hyprctl clients -j | jq -r '
  .[] 
  | select(.class == "tidal-hifi") 
  | .title
' | head -n 1

