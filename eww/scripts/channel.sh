#!/bin/sh

sink=$(pactl info 2>/dev/null | grep "Default Sink" | cut -d ":" -f2 | xargs)
source=$(pactl info 2>/dev/null | grep "Default Source" | cut -d ":" -f2 | xargs)

# Fallback defaults if empty
if [ -z "$sink" ]; then sink="default"; fi
if [ -z "$source" ]; then source="default"; fi

# Detect output icon
case "$sink" in
    *headphone*|*headset*|*usb*|*mono-fallback*)
        output="󰋋" # Headphone icon
        ;;
    *)
        output="󰓃" # Speaker icon
        ;;
esac

# Detect input icon
case "$source" in
    *mic*|*usb*|*headset*)
        input="" # Microphone icon
        ;;
    *platform*|*analog-stereo*)
        input=" " # Internal mic icon
        ;;
    *)
        input="" # Default to mic
        ;;
esac

echo "{\"output\":\"${output}\", \"input\":\"${input}\"}"