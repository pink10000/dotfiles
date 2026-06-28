#!/bin/sh

STATE_FILE="/tmp/eww-netspeed-state"
INTERFACE="wlp2s0"

# Read bytes from /proc/net/dev
line=$(grep "$INTERFACE:" /proc/net/dev)
if [ -z "$line" ]; then
    echo '{"down":"0", "up":"0"}'
    exit 0
fi

# Extract down and up bytes
down_bytes=$(echo "$line" | awk '{print $2}')
up_bytes=$(echo "$line" | awk '{print $10}')
now=$(date +%s.%N)

if [ -f "$STATE_FILE" ]; then
    # Read previous values
    read -r prev_time prev_down prev_up < "$STATE_FILE"
    
    # Calculate difference
    diff_time=$(awk "BEGIN {print $now - $prev_time}")
    if [ $(awk "BEGIN {print ($diff_time > 0) ? 1 : 0}") -eq 1 ]; then
        down_bps=$(awk "BEGIN {print int(($down_bytes - $prev_down) / $diff_time)}")
        up_bps=$(awk "BEGIN {print int(($up_bytes - $prev_up) / $diff_time)}")
    else
        down_bps=0
        up_bps=0
    fi
else
    down_bps=0
    up_bps=0
fi

# Save current values for next run
echo "$now $down_bytes $up_bytes" > "$STATE_FILE"

# Convert bytes/sec to KB/sec
down_kbps=$(awk "BEGIN {print int($down_bps / 1024)}")
up_kbps=$(awk "BEGIN {print int($up_bps / 1024)}")

# Ensure non-negative
if [ "$down_kbps" -lt 0 ]; then down_kbps=0; fi
if [ "$up_kbps" -lt 0 ]; then up_kbps=0; fi

echo "{\"down\":\"$down_kbps\", \"up\":\"$up_kbps\"}"
