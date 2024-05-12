#!/bin/sh

output=`amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1`
input=`amixer -D pulse sget Capture | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1`

echo {\"output\":\"${output}\", \"input\":\"${input}\"}