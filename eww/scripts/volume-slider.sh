#!/usr/bin/env bash

vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oE '[0-9]+%' | head -n 1 | tr -d '%')
if [ -z "$vol" ]; then
    vol=0
fi

if [[ ${vol} -ge 80 ]]; then
    echo "󰕾"
elif [[ ${vol} -ge 40 ]]; then
    echo "󰖀"
elif [[ ${vol} -ge 10 ]]; then
    echo "󰕿"
else
    echo "󰝟"
fi