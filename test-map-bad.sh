#!/bin/bash
execPath="cub3D"
makePath="."
mapsPath='cub3D-tester/maps/bad/'

termwidth="$(tput cols)"
green='\e[1;32m'
yellow='\e[93m'
blueBg='\e[46m'
blue='\e[34m'
red='\e[31m'
end='\e[0m'
end='\e[0m'
passed=0
failed=0
leak=0
vg='valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=42'

head () {
  padding="$(printf '%0.1s' \#{1..500})"
  printf "\n${yellow}%*.*s %s %*.*s${end}\n" 0 "$(((termwidth-5-${#1})/2))" "$padding" "  $1  " 0 "$(((termwidth-6-${#1})/2))" "$padding"
}

log () {
  padding="$(printf '%0.1s' ={1..500})"
  printf "${blue}%*.*s %s %*.*s${end}\n" 0 "$(((termwidth-5-${#1})/2))" "$padding" "  $1  " 0 "$(((termwidth-6-${#1})/2))" "$padding"
}

pass () {
  let "passed+=1"
  padding="$(printf '%0.1s' -{1..500})"
  printf "${green}%*.*s %s %*.*s${end}\n\n" 0 "$(((termwidth-5-8)/2))" "$padding" " Passed " 0 "$(((termwidth-6-${#1})/2))" "$padding"
}

fail () {
  let "failed+=1"
  padding="$(printf '%0.1s' -{1..500})"
  printf "${red}%*.*s %s %*.*s${end}\n\n" 0 "$(((termwidth-5-8)/2))" "$padding" " Failed " 0 "$(((termwidth-6-${#1})/2))" "$padding"
}

leak () {
	let "leak+=1"
  	padding="$(printf '%0.1s' -{1..500})"
	printf "${yellow}%*.*s %s %*.*s${end}\n\n" 0 "$(((termwidth-5-8)/2))" "$padding" " Memleak(s) detected" 0 "$(((termwidth-6-${#1})/2))" "$padding"
}

launch () {
	log $1
	${vg} ./${execPath} ${mapsPath}$1;
	ret_val=$?
	if [ $ret_val -eq 0 ]
	then
		fail
	elif [ $ret_val -eq 42 ]
	then
		leak
	else
		pass
	fi
}

result () {
	if let "failed == 0 && leak == 0";
	then
		printf "${green}YEAH ! All tests successfully passed ! Good job !${end}\n"
	else
		printf "${green}${passed}${end} tests passed, ${red}${failed}${end} tests failed. ${yellow}${leak}${end} leaks\n"
		printf "Don't worry, im sure you can fix it ! Keep it up !\n"
	fi
}

cd ..
head "Infos"
log "Make logs"
make -C ${makePath}
log "Date:"
date
log "Last commit:"
git --no-pager log --decorate=short --pretty=oneline -n1

head "Testing Color"
launch "color_invalid_rgb.cub"
launch "color_missing.cub"
launch "color_missing_ceiling_rgb.cub"
launch "color_missing_floor.cub"
launch "color_none.cub"

head "Testing file"
launch "empty.cub"
launch "file_letter_end.cub"
launch "filetype_missing.cub"
launch "filetype_wrong.cub"
launch "forbidden.cub"

head "Testing Map"
launch "map_first.cub"
launch "map_middle.cub"
launch "map_missing.cub"
launch "map_only.cub"
launch "map_too_small.cub"

head "Testing Player"
launch "player_multiple.cub"
launch "player_none.cub"
launch "player_on_edge.cub"

head "Testing Textures"
launch "textures_dir.cub"
launch "textures_duplicate.cub"
launch "textures_forbidden.cub"
launch "textures_invalid.cub"
launch "textures_missing.cub"
launch "textures_none.cub"
launch "textures_not_xpm.cub"

head "Testing Walls"
launch "wall_hole_east.cub"
launch "wall_hole_north.cub"
launch "wall_hole_south.cub"
launch "wall_hole_west.cub"
launch "wall_none.cub"

head "DONE"
result
