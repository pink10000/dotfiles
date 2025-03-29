function update
	if [ (count $argv) -ne 1 ]
		echo "Wrong usage. Usage: update <image_directory>"
		return 1
  	end

  	set img_dir $argv[1]

	swww img $img_dir # --no-resize

	# Run wallust with the provided image directory
	wallust run $img_dir
	echo $img_dir
	# Update polybar widgets and other things
	sleep 0.1
	
	eww reload
  echo "Ugly? use this to generate a better palette: https://colordesigner.io/color-palette-from-image"
end

#function fish_greeting
# 	sttt scanline -d 0.2 --scanline-vertical False --scanline-reverse true --scanline-width 2 --scanline-scale-width 1.1 --scanline-scale-ratio 0.2 -r
# 	sttt scanline -d 0.2 --scanline-vertical True --scanline-width 2 --scanline-scale-width 1.1 --scanline-scale-ratio 0.1 -r
#end

#function fish_prompt
#    #set -l arrowcol green
#    #set_color $textcol -b $bgcol
# #echo -n [(whoami)]
#
#	set_color $arrowcol -b normal
#	echo -n " "(prompt_pwd) 
#	
#	echo -n "  "
#end


function pipes
	~/Downloads/pipes.sh/pipes.sh
end

function vscan
	sttt scanline --scanline-reverse true --scanline-scale-width 1.1 -d 0.3 --scanline-vertical true -l -r;
end

function rec
	~/.config/hypr/vscrp.sh
end

function p1
  ping 1.1.1.1
end

function hotel
  route -n 
  open 10.0.1.0
end


if status is-interactive
    # Commands to run in interactive sessions can go here
end

# opam configuration
source /home/py/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
pyenv init - fish | source

# support for direnv
direnv hook fish | source


# mts oba api key
set -x OBA_KEY "3c7afe29-8e40-422d-8f13-65c8605c1125"
