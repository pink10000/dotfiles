#!/bin/bash

# Function to get current brightness
get_brightness() {
    cat /sys/class/backlight/intel_backlight/brightness
}

# Function to set brightness
set_brightness() {
    echo $1 | sudo tee /sys/class/backlight/intel_backlight/brightness
}

# Function to increase brightness
increase_brightness() {
    current=$(get_brightness)
    max=350
    new=$current + 20

    if [ $new -gt $max ]; then
        new=$max
    fi

    set_brightness $new
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 get|set [brightness]"
    exit 1
fi

# Perform action based on the argument
case $1 in
    get)
        get_brightness
        ;;
    set)
        # Check if brightness value is provided
        if [ $# -ne 2 ]; then
            echo "Usage: $0 set [brightness]"
            exit 1
        fi
        set_brightness $2
        ;;
    up)
        increase_brightness
        ;;
    *)
        echo "Invalid argument: $1"
        echo "Usage: $0 get|set [brightness]"
        exit 1
        ;;
esac