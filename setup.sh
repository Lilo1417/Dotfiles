#!/bin/bash

# dependencies: socat
install_dep() {
    sudo pacman -S socat hyprlock hyprpaper hyprpolkitagent swaync hypridle
}

create_syms() {
    ln -sf ./wal/ ~/.config/wal
    ln -sf ./ghostty/ ~/.config/ghostty
    ln -sf ./ghostty/ ~/.config/rofi
    ln -sf ./ghostty/ ~/.config/eww
}

install_dep
echo "Dependencies successfully installed"
create_syms
echo "symlinks successfully created"
echo "Setup should be finished"

