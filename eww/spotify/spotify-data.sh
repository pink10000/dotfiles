#!/bin/bash
#This file is called during spotifyd's on-change hook

ARTWORK_DIRECTORY="/tmp/spotify-artwork"
WATCH_FILE_PATH="/tmp/spotifyd_watch"

#Capture both stdout and stderr
metadata=$(playerctl metadata 2>&1)
#Captures the exit status of the previously run command
status=$?


#If the command failed,
if [ $status -ne 0 ]; then
  echo "No player found!"
  exit 1
fi

#Get album title
albumtitle=$(echo "$metadata" | grep -w "xesam:album" | awk '{
for (i = 3; i <= NF; i++){
  if (i !=NF) {printf "%s ", $i}
  else {printf $i}
  }
}')

#Get Song Title
songtitle=$(echo "$metadata" | grep -w "xesam:title" | awk '{
for (i = 3; i <= NF; i++){
  if (i !=NF) {printf "%s ", $i}
  else {printf $i}
  }
}')

#Get Artist Name
artistname=$(echo "$metadata" | grep -w "xesam:artist" | awk '{
for (i = 3; i <= NF; i++){
  if (i !=NF) {printf "%s ", $i}
  else {printf $i}
  }
}')


#Get artwork
#This one shouldnt contain spaces, so I'm just printing $3
artworkUrl=$(echo "$metadata" | grep -w "mpris:artUrl" | awk '{print $3}')

#Pass the url through sed and get the filename of the artwork
artworkFilename=$(echo "$artworkUrl" | sed 's#.*/##')

#Curl our artworkUrl if we havent downloaded it yet
if [ ! -f "$ARTWORK_DIRECTORY/$artworkFilename" ]; then
  #If the directory exists, we probably have an old file on there.
  if [ -d "$ARTWORK_DIRECTORY" ]; then
    #Remove all files in the directory
    cd "$ARTWORK_DIRECTORY"
    rm *
  fi
  #Finally, download the file
  curl -s --create-dirs -O --output-dir "$ARTWORK_DIRECTORY" "$artworkUrl"
fi

#Format Nicely into a JSON
final_json=$(printf '{"albumtitle": "%s", "songtitle": "%s", "artistname": "%s", "filepath": "%s"}' "$albumtitle" "$songtitle" "$artistname" "$ARTWORK_DIRECTORY/$artworkFilename")

#Finally, append to the watch file
echo $final_json >> $WATCH_FILE_PATH
echo " "