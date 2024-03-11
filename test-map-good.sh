#!/bin/bash
execPath="cub3D"
makePath="."
mapsPath='cub3D-tester/maps/good/'

termwidth="$(tput cols)"
green='\e[1;32m'
yellow='\e[93m'
blueBg='\e[46m'
blue='\e[34m'
red='\e[31m'
end='\e[0m'
passed=0
failed=0
leak=0
vg='valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=42'

head () {
  padding="$(printf '%0.1s' \#{1..500})"
  printf "${yellow}%*.*s %s %*.*s${end}\n" 0 "$(((termwidth-5-${#1})/2))" "$padding" "  $1  " 0 "$(((termwidth-6-${#1})/2))" "$padding"
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
		pass
	elif [ $ret_val -eq 42 ]
	then
		leak
	else
		fail
	fi
}

result () {
	if let "failed == 0 && leak == 0";
	then
		printf "${green}YEAH ! All tests successfully passed ! Good job !${end}\n"
	else
		printf "${green}${passed}${end} tests passed, ${red}${failed}${end} tests failed.\n"
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

log "Notes:"
printf "If a test is successful you should close the opened Cub3d to continue.\n"
printf "If it failed your Cub3d should handle this error and print a message accordingly.\n"

head "Testing working maps"

launch "cheese_maze.cub"
launch "creepy.cub"
launch "dungeon.cub"
launch "library.cub"
launch "matrix.cub"
launch "sad_face.cub"
launch "square_map.cub"
launch "subject_map.cub"
launch "test_map.cub"
launch "test_map_hole.cub"
launch "test_pos_bottom.cub"
launch "test_pos_left.cub"
launch "test_pos_right.cub"
launch "test_pos_top.cub"
launch "test_textures.cub"
launch "test_whitespace.cub"
launch "works.cub"

head "DONE"
result
