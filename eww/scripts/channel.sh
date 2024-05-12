#!/bin/sh

sink=`pactl info | grep "Default Sink" | cut -d ":" -f2`
sink=${sink:1}
speaker=alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink
headphone=alsa_output.usb-GeneralPlus_USB_Audio_Device-00.mono-fallback
headphone2=alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink


if [ "$sink" = "$speaker" ]; then
    output="󰓃"
elif [ "$sink" = "$headphone" ] || [ "$sink" = "$headphone2" ]; then
    output="󰋋"
else
    output="Other"
fi

# microphone
source=`pactl info | grep "Default Source" | cut -d ":" -f2`
source=${source:1}

pc_mic=alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source
hp_mic=alsa_input.usb-GeneralPlus_USB_Audio_Device-00.mono-fallback

if [ "$source" = "$pc_mic" ]; then
    input=""
elif [ "$source" = "$hp_mic" ]; then
    input="" 
else
    input="o"
fi
echo {\"output\":\"${output}\", \"input\":\"${input}\"}