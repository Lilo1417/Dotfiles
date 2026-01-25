#!/bin/bash

local choice=""
if [ $# -eq 0 ]; then
    DIR="$HOME/.config/hypr/styles"

    theme_list=()

    for path in "$DIR"/*; do
        [ -d "$path" ] && theme_list+=("$(basename "$path")")
    done

    CHOICESCRIPT=""

    for name in "${theme_list[@]}"; do
        CHOICESCRIPT+="$name\n"
    done
    CHOICESCRIPT+="Random Style"



    choice=$(printf "%b" "$CHOICESCRIPT" | \
      wofi --dmenu --insensitive --cache-file /dev/null --style ~/.config/wofi/style.css)

    [ -z "$choice" ] && exit 0

    if [ "$choice" = "Random Style" ]; then
        $HOME/.config/hypr/scripts/randomStyle.sh
        exit 0
    fi
    THEME=$1

    THEME_DIR="$DIR/$choice"


    if [ ! -d "$THEME_DIR" ]; then
        echo "Theme '$THEME' does not exist."
        exit 1
    fi
else
    choice=$1
fi


THEME_DIR="$HOME/.config/waybar/styles/$choice"
echo "$THEME_DIR"
ln -sf "$THEME_DIR/config" "$HOME/.config/waybar/config"
ln -sf "$THEME_DIR/style.css" "$HOME/.config/waybar/style.css"

pkill waybar && waybar &

THEME_DIR="$HOME/.config/wofi/styles"
echo "$THEME_DIR"
ln -sf "$THEME_DIR/$choice.css" "$HOME/.config/wofi/style.css"


THEME_DIR="$HOME/.config/hypr/styles/$choice"
echo "$THEME_DIR"
ln -sf "$THEME_DIR/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
pkill hyprpaper && hyprpaper &
ln -sf "$THEME_DIR/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"

THEME_DIR="$HOME/.config/eww/styles/$choice"
echo "$THEME_DIR"
ln -sf "$THEME_DIR/ewwvariables.yuck" "$HOME/.config/eww/ewwvariables.yuck" 
ln -sf "$THEME_DIR/eww.scss" "$HOME/.config/eww/eww.scss" 

THEME_DIR="$HOME/.config/eww/bar/styles/$choice"
echo "$THEME_DIR"
ln -sf "$THEME_DIR/barcolor.scss" "$HOME/.config/eww/bar/barcolor.scss" 
ln -sf "$THEME_DIR/message.yuck" "$HOME/.config/eww/bar/modules/message.yuck"
eww kill
eww open eww-bar0





