#!/bin/bash

while true; do
    name=$(nvidia-smi --query-gpu=name --format=csv,noheader)

    temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

    usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

	# Output JSON
    echo "{\"name\": \"${name}\", \"temperature\": \"${temp}\", \"usage\": \"${usage}\"}"

    sleep 1
done


