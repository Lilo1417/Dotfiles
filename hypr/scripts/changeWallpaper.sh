#!/bin/bash

# If argument is given and it's a valid file, use it directly
if [[ -n "$1" && -f "$1" ]]; then
    SELECTED_IMAGE="$1"
else
    DIR="${1:-$HOME/.config/hypr/backgrounds}"

    mapfile -t IMAGES < <(
        find "$DIR" -maxdepth 1 -type f \
        \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" \) \
        | sort
    )

    MENU_FILE=$(mktemp)

    # First entry: Random wallpaper (no icon)
    printf "Random Wallpaper\n" >> "$MENU_FILE"

    # Image entries with icons
    for img in "${IMAGES[@]}"; do
        name="$(basename "$img")"
        printf "%s\0icon\x1f%s\n" "$name" "$img" >> "$MENU_FILE"
    done

    CHOSEN=$(rofi -dmenu \
        -i \
        -p "Select wallpaper" \
        -show-icons \
        -theme image-grid \
        -format i < "$MENU_FILE"
    )

    rm "$MENU_FILE"

    if [[ -z "$CHOSEN" ]]; then
        exit 0
    fi

    if [[ "$CHOSEN" -eq 0 ]]; then
        exec "$HOME/.config/hypr/scripts/randomWallpaper.sh"
    else
        SELECTED_IMAGE="${IMAGES[$CHOSEN-1]}"
    fi
fi

# Link the selected image as the background
ln -sf "$SELECTED_IMAGE" "$HOME/.config/hypr/background.jpg"

# Update colors with wal and refresh wallpaper
wal -i "$(readlink -f "$HOME/.config/hypr/background.jpg")"
pkill hyprpaper
hyprpaper &

# Reload eww
eww reload

