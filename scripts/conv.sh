#!/bin/sh -e
# conv.sh: convert geojson files into binary vector tiles of mapbox
# Lisence  CC BY-SA 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

: ${target:="src/geojson/??"}
dir=${target%%/*}/pbf
[ ! -d $dir ] && mkdir -vp $dir

for i in $target
do 
    pref_code=${i##*/}
    #generate pbf for each
    {
        for j in $i/?????
        do 
	    file=${j##*/}
	    dst=$dir/${file%%.geojson}.pbf
	    [ ! -f $dst ] && \
	        tippecanoe \
	        -o ${dst} \
	        -pC  \
	        --drop-densest-as-needed \
	        -zg $j
        done 
        tippecanoe -o $dir/${pref_code}.mbtiles --drop-densest-as-needed -zg $i/*
    } &
    [ $(jobs | wc -l) -gt 3 ] && wait
done

wait
