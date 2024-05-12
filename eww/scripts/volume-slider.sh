#!/usr/bin/env bash

vol=`amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1`

if [[ ${vol} -ge 80 ]]; then
    echo "󰕾"
elif [[ ${vol} -ge 40 ]]; then
    echo "󰖀"
elif [[ ${vol} -ge 10 ]]; then
    echo "󰕿"
else
    echo "󰝟"
fi