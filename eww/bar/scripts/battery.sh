# !/bin/bash
if ls /sys/class/power_supply/ | grep -q '^BAT'; then
    battery=true
    while true; do
        percent=$(cat /sys/class/power_supply/BAT0/capacity)
        icon=""

        if [ $percent -lt 20 ]; then
            icon="󰁺"
        elif [ $percent -lt 30 ]; then
            icon="󰁻"
        elif [ $percent -lt 40 ]; then
            icon="󰁼"
        elif [ $percent -lt 50 ]; then
            icon="󰁽"
        elif [ $percent -lt 60 ]; then
            icon="󰁾"
        elif [ $percent -lt 70 ]; then
            icon="󰁿"
        elif [ $percent -lt 80 ]; then
            icon="󰂀"
        elif [ $percent -lt 90 ]; then
            icon="󰂁"
        elif [ $percent -lt 100 ]; then
            icon="󰂂"
        else
            icon="󰁹"
        fi    

        if [ $(cat /sys/class/power_supply/BAT0/status) = "Charging" ]; then
            icon+="󱐋"
        fi



        echo "{\"icon\": \"${icon}\", \"percent\": \"${percent}\", \"battery\": \"${battery}\"}"



        sleep 5
    done 
else
    battery=false
    
fi




