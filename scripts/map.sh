#!/bin/sh -ex
# map.sh: map city name to city id
# License  CC BY-SA 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

case ${1:-nopbf} in
    (--pbf) dst=pbf;;
esac


for i in src/geojson/?? src/topojson/?? ${dst:+src/pbf/??}
do
    fmt=${i%/*}
    fmt=${fmt#*/}
    case $fmt in
	(geojson) filter='.features[].properties| [.N03_004, .N03_007]';;
	(topojson) filter='.objects.city.geometries[].properties| [.N03_004, .N03_007]';;
    esac
    {
    	cat $i/*.$fmt \
		| jq "$filter | . as [\$a, \$b] | [{key: \$a, value: \$b}] | from_entries" \
		| grep -vE \\\{\|\\\} \
		| tr \\\n ,\
		| sed -r -e s/\ \+//g -e s/\^/\{/ -e s/,\?\$/\}/ \
		| tee $i/map $i/map.json > /dev/null
		  echo generated ${dst:-geojson}/$i/map
    } &
    wait
done
