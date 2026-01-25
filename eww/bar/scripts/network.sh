#!/bin/bash

output_status_json() {
    wifi_info=$(nmcli -t -f TYPE,STATE,DEVICE device)

    disabled_count=$(nmcli -t -f STATE device | grep -c '^unavailable$')
    total_count=$(nmcli -t -f STATE device | wc -l)


    if [[ "$disabled_count" -eq "$total_count" ]]; then
        icon="󰖪"
        status="disabled"
        name="Disabled"
        jq -nc --arg icon "$icon" --arg status "$status" --arg name "$name" \
            '{icon: $icon, status: $status, name: $name}'
        return
    fi

    icon="󰖪"
    status="disconnected"
    name="Disconnected"


    while IFS=: read -r def_type dev_state dev_name; do
        if [[ "$dev_type" == "wifi" && "$dev_state" = "connected" ]]; then
            icon=""
            status="wifi"
            ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1 == "yes" {print $2; exit}')
            name="$ssid"
            jq -nc --arg icon "$icon" --arg status "$status" --arg name "$name" \
                '{icon: $icon, status: $status, name: $name}'
            return
        fi
    done <<< "$wifi_info"

    while IFS=: read -r dev_type dev_state dev_name; do
        if [[ "$dev_type" == "ethernet" && "$dev_state" == "connected" ]]; then
            icon="󰈀"
            status="ethernet"
            name="Ethernet"
            jq -nc --arg icon "$icon" --arg status "$status" --arg name "$name" \
                '{icon: $icon, status: $status, name: $name}'
            return
        fi
    done <<< "$wifi_info"

    while IFS=: read -r dev_type dev_state dev_name; do
        if [[ "$dev_state" == "connected" ]]; then
        icon=""
        status="linked"
        name="Linked"
            jq -nc --arg icon "$icon" --arg status "$status" --arg name "$name" \
                '{icon: $icon, status: $status, name: $name}'
            return
        fi
    done <<< "$wifi_info"
    
    jq -nc --arg icon "$icon" --arg status "$status" --arg name "$name" \
        '{icon: $icon, status: $status, name: $name}'

}


output_status_json

nmcli monitor | while read -r _; do
    output_status_json
done
