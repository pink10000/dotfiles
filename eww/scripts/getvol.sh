#!/bin/sh

output=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oE '[0-9]+%' | head -n 1 | tr -d '%')
if [ -z "$output" ]; then
    output="0"
fi

input=$(pactl get-source-volume @DEFAULT_SOURCE@ 2>/dev/null | grep -oE '[0-9]+%' | head -n 1 | tr -d '%')
if [ -z "$input" ]; then
    input="0"
fi

echo "{\"output\":\"${output}\", \"input\":\"${input}\"}"