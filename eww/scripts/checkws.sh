#!/bin/bash

#define icons for workspaces 1-9
ic=(0         󰻧)

workspaces() {
    # Get occupied workspaces and remove workspace -99 aka scratchpad if it exists
    ows=$(hyprctl workspaces -j | jq '.[] | del(select(.id == -99)) | .id' 2>/dev/null)

    # Get Focused workspace for current monitor ID
    arg="$1"
    focused_ws=$(hyprctl monitors -j | jq --argjson arg "$arg" '.[] | select(.id == $arg).activeWorkspace.id' 2>/dev/null)

    # Check state for workspaces 1-9
    get_class() {
        local num="$1"
        if [ "$focused_ws" = "$num" ]; then
            echo "w0-focused"
        elif echo "$ows" | grep -q -x "$num"; then
            echo "w0-occupied"
        else
            echo "w0"
        fi
    }

    c1=$(get_class 1)
    c2=$(get_class 2)
    c3=$(get_class 3)
    c4=$(get_class 4)
    c5=$(get_class 5)
    c6=$(get_class 6)
    c7=$(get_class 7)
    c8=$(get_class 8)
    c9=$(get_class 9)

    echo "(eventbox :onscroll \"echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace\" \
          (box :class \"workspace\" :orientation \"h\" :space-evenly \"false\" \
              (button :onclick \"scripts/dispatch.sh 1\" :class \"$c1\" \"\") \
              (button :onclick \"scripts/dispatch.sh 2\" :class \"$c2\" \"\") \
              (button :onclick \"scripts/dispatch.sh 3\" :class \"$c3\" \"\") \
              (button :onclick \"scripts/dispatch.sh 4\" :class \"$c4\" \"\") \
              (button :onclick \"scripts/dispatch.sh 5\" :class \"$c5\" \"\") \
              (button :onclick \"scripts/dispatch.sh 6\" :class \"$c6\" \"\") \
              (button :onclick \"scripts/dispatch.sh 7\" :class \"$c7\" \"\") \
              (button :onclick \"scripts/dispatch.sh 8\" :class \"$c8\" \"\") \
              (button :onclick \"scripts/dispatch.sh 9\" :class \"$c9\" \"\") \
          )\
        )"
}

workspaces "$1"
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r; do 
    workspaces "$1"
done