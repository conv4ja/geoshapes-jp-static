#!/bin/sh -e
# conv.sh: convert geojson files into binary vector tiles of mapbox
# License  CC BY 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

: ${target:="src/geojson/??"}
dir=${target%%/*}/pbf
[ ! -d $dir ] && mkdir -vp $dir

max_pararellism=15

for i in $target
do
	pref_code=${i##*/}
	tippecanoe -o $dir/$pref_code.mbtiles -pC --drop-densest-as-needed -zg $i/????? &
	while jobs | wc -l | {
		read job_num
		[ ${job_num:?no job} -ge ${max_pararellism:-7} ] 
	}; do sleep 10; done
done

tippecanoe -o $dir/all.mbtiles -pC --drop-densest-as-needed -zg src/geojson/*.geojson &
wait
