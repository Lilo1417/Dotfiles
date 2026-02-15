#!/bin/bash



choice=$(printf "  Poweroff\n  Restart\n󰍃 Change User\n⏾ Suspend" | \
  rofi -show dmenu --insensitive --cache-file /dev/null --style ~/.config/wofi/style.css)

case "$choice" in
  "  Poweroff") ddcutil --display 2 setvcp D6 5 && ddcutil --display 1 setvcp D6 5 && systemctl poweroff ;;
  "  Restart") systemctl reboot ;;
  "󰍃 Change User") hyprctl dispatch exit ;;
  "⏾ Suspend") systemctl suspend && hyprlock;;
esac
