#!/bin/sh -e
# fetch.sh: fetch shape file from geoshape project official repository
# Lisence  CC BY-SA 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

echo fetching shape file from geoshape project...

# parse option
case ${1:---geojson} in 
    (-g|--geojson) fmt=geojson; shift;; 
    (-t|--topojson) fmt=topojson; shift;;
    (-*) echo unknown option; exit 1;;
    (*) echo default type: geojson;;
esac

basedir=src/${fmt:?file format not set}
html_src=$PWD/full.html

# create directory
[ ! -d $basedir ] && mkdir -vp $basedir
cd $basedir/

# get html body for url links
curl -sL https://geoshape.ex.nii.ac.jp/city/code/ -o $html_src

# set target prefecture id
[ $# -eq 0 ] && target=$(seq -w 47) || target="$@"

# fetch files recursivly
for i in $target ; do 
    egrep "$i[[:digit:]]{3,4}\.${fmt:-geojson}" $html_src \
	| sed -r \
		-e s/\.\+=\"//g \
		-e s/\"\.\+//g \
	| while read uri; do 
	    wait_sec=$(seq 3 | shuf | head -1)
	    wait_msec=$(seq 999 | shuf | head -1)
	    wait4="${wait_sec}.${wait_msec}"
	    curl -sL $uri --retry=3 --retry-delay=$wait4 -o ${uri##*/}
	    sleep $wait4
	done 
done

cd ..
