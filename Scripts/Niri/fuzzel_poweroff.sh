#!/bin/bash

# Fuzzel uses the -d flag for dmenu mode (which Wofi uses implicitly here)
# Fuzzel does not have a direct equivalent to 'dynamic_lines=true',
# as it automatically handles input fed via stdin.

# Pass the options to fuzzel in dmenu mode (-d)
choice=$(echo -e "Shutdown\nReboot\nLog off\nSleep\nLock\nCancel" | fuzzel -d)

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
        # Ensure you have a Wayland locker installed and configured (e.g., swaylock or wlr-lock)
        # loginctl lock-session usually works if you have a configured screen locker service.
        loginctl lock-session
        ;;
    "Log off")
        # Uses the Niri command to quit the compositor
        niri msg action quit
        ;;
esac
