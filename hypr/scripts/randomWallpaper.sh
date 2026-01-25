#!/bin/bash

DIR="$HOME/.config/hypr/backgrounds/"

# Enable nullglob so globs with no match expand to nothing
shopt -s nullglob

# Collect all images in the folder
images=("$DIR"*.png "$DIR"*.jpg "$DIR"*.jpeg "$DIR"*.gif)

# Make sure there is at least one image
if [ ${#images[@]} -eq 0 ]; then
    echo "No images found in $DIR"
    exit 1
fi

# Pick a random image
random_image="${images[RANDOM % ${#images[@]}]}"

# Call changeWallpaper.sh with the random image
~/.config/hypr/scripts/changeWallpaper.sh "$random_image"

