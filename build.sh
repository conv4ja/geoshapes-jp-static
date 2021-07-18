#!/bin/sh -ex

PATH=$PWD/scripts:$PATH

# generate symbolic links for each json files
sln.sh

[ "$1" = "--pbf" || "$WITH_PBF" = "1" ] && conv.sh

{
	generate_city_list.sh &
	generate_city_info.sh &
	versioning.sh &
} 
wait && echo repository is successfully built. \
	|| { echo abort; exit 1; }
