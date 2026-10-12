#!/bin/sh

# 1. Get JSON list of all windows from Niri
WINDOW_DATA=$(niri msg --json windows)

# 2. Use jq to create a searchable list:
#    - Format: "[INDEX] Window Title <TAB> Window ID"
#    - Fuzzel will display the title, but we need the ID to switch
#    - We need to pass the list to fuzzel using dmenu mode
CHOICE=$(echo "$WINDOW_DATA" | jq -r '.[] | .title + "\t" + (.id | tostring)' | fuzzel --dmenu)

# 3. Extract the ID from the selected line
WINDOW_ID=$(echo "$CHOICE" | awk -F'\t' '{print $2}')

# 4. Use the Niri command to focus the selected window
if [ -n "$WINDOW_ID" ]; then
    niri msg action focus-window --id "$WINDOW_ID"
fi
