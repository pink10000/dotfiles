#!/bin/bash

pieces=("profile" "datetime" "quickapps" "status" "weather" "volume" "brightness" "song" "battery_board" "fetch" "bluetooth" "powerbuttons" "calendar")


run_eww() {
    eww open dashboard
    sleep 0.05

    for n in ${pieces[@]}; do
        eww open $n --debug # | tr -d '\n'
        sleep 0.05
    done
}


close_eww() {
    eww close dashboard
    sleep 0.1
    
    for n in ${pieces[@]}; do
        eww close $n | tr -d '\n'
        sleep 0.1
    done

    # eww kill
}

if [ "$1" = "open" ]; then
    run_eww
elif [ "$1" = "close" ]; then
    close_eww
    sleep 0.1
    close_eww 
else
    echo "Expected 'close' or 'open' as first argument."
fi