#!/bin/bash

DIR="$HOME/.config/hypr/styles"

theme_list=()

for path in "$DIR"/*; do
    [ -d "$path" ] && theme_list+=("$(basename "$path")")
done

choice="${theme_list[RANDOM % ${#theme_list[@]}]}"

~/.config/hypr/scripts/changeStyle.sh $choice


