#!/usr/bin/env bash

choice=$(printf "  Poweroff\n  Restart\n󰍃 Change User\n⏾ Suspend" | \
  rofi -dmenu -i)

case "$choice" in
  "  Poweroff")
    ddcutil --display 2 setvcp D6 5
    ddcutil --display 1 setvcp D6 5
    systemctl poweroff
    ;;
  "  Restart")
    systemctl reboot
    ;;
  "󰍃 Change User")
    hyprctl dispatch exit
    ;;
  "⏾ Suspend")
    systemctl suspend && hyprlock
    ;;
esac

