#!/bin/bash

while true; do
    freq=$(awk '/cpu MHz/ {printf "%.2f", $4 / 1000; exit}' /proc/cpuinfo)


    echo "{\"cpufreq\": \"${freq} GHz\", \"meminfo\": \"${mem}\"}"

    sleep 1
done
