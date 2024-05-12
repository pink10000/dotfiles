function fish_prompt
    set -l arrowcol green
    set_color $textcol -b $bgcol
	echo -n [(whoami)]

	set_color $arrowcol -b normal
	# interactive user name @ host name, date/time in YYYY-mm-dd format and path
	echo -n " "(prompt_pwd) 
	

	echo -n "  "
end
