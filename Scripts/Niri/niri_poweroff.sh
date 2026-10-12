#!/bin/bash

choice=$(wofi -d dynamic_lines=true <<EOF | sed 's/^ *//'
Shutdown
Reboot
Log off
Sleep
Lock
Cancel
EOF
)

case "$choice" in
    "Shutdown")
        systemctl poweroff
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Sleep")
        systemctl suspend
        ;;
    "Lock")
        loginctl lock-session
        ;;
    "Log off")
        niri msg action quit
        ;;
esac

