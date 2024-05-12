if [ "$1" = "wifi" ]; then
    alacritty --class alacritty-nmtui -e nmtui
elif [ "$1" = "audio" ]; then
    pavucontrol
fi

exit