function update
	if [ (count $argv) -ne 1 ]
		echo "Wrong usage. Usage: update <image_directory>"
		return 1
  	end

  	set img_dir $argv[1]

	swww img $img_dir # --no-resize

	# Run wal with the provided image directory
	wal -i $img_dir
	echo $img_dir
	# Update polybar widgets and other things
	sleep 0.1
	# i3-msg restart  
	
	# Run spicetify update
	#spicetify apply

	wal_cava -c ~/.config/cava/config -G 8 -x
	eww reload
end

function fish_greeting
	sttt scanline -d 0.2 --scanline-vertical False --scanline-reverse true --scanline-width 2 --scanline-scale-width 1.1 --scanline-scale-ratio 0.2 -r -b 0.04 0.96 96 0.04
	sttt scanline -d 0.2 --scanline-vertical True --scanline-width 2 --scanline-scale-width 1.1 --scanline-scale-ratio 0.1 -r
end

function fish_prompt
    #set -l arrowcol green
    #set_color $textcol -b $bgcol
	#echo -n [(whoami)]

	set_color $arrowcol -b normal
	echo -n " "(prompt_pwd) 
	
	echo -n "  "
end


function pipes
	~/Downloads/pipes.sh/pipes.sh
end

function vscan
	sttt scanline --scanline-reverse true --scanline-scale-width 1.1 -d 0.3 --scanline-vertical true -l -r;
end

function rec
	python ~/Documents/vscrp/recent.py
	hyprctl dispatch closewindow kitty-rec
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# opam configuration
source /home/py/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
