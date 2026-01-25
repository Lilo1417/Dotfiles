#!/bin/bash

while true; do
    hyprctl -j devices | jq -c '.keyboards[] | select(.name=="cherry-cherry-keyboard") | {name, active_keymap}' 
    sleep 1
done
