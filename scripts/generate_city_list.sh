#!/bin/sh -e
# generate resources for /city/list/:prefCode, /city/listAll and /prefecture/listAll

PATH=${0%/*}:$PATH
fmt=topojson

for d in src/prefecture src/city/list; 
do 
    [ -d $d ] && rm -rv $d
    mkdir -vp $d;
done

echo \{ \
    | tr -d \\\n \
    | tee src/prefecture/listAll src/city/listAll > /dev/null

for i in $(seq -w 47); do echo \{ | tr -d \\\n > src/city/list/$i; done

for i in src/$fmt/*.$fmt
do
	pref_code=$(cat $i | jq ".objects.city.geometries[].properties.N03_007" | tr -d \\\" | cut -c 1-2 )
	pref_name=$(cat $i | jq ".objects.city.geometries[].properties.N03_001")
	echo $pref_name:\"$pref_code\", | tr -d \\\n >> src/prefecture/listAll

        case $fmt in
		#(geojson) filter='.features[].properties| [.N03_004, .N03_007]';;
		(topojson) filter='.objects.city.geometries[].properties | if .N03_004 != null then [.N03_004, .N03_007] elif .N03_003 != null then [.N03_003, .N03_007] else ["東京23区", .N03_007] end';;
        esac
	filter="$filter | . as [\$a, \$b] | [{key: \$a, value: \$b}] | from_entries"

	cat $i \
		| jq "$filter" \
		| grep -vE \\\{\|\\\} \
		| tr \\\n ,\
		| sed -re s/\ \+//g \
		| tee -a src/city/list/$pref_code src/city/listAll > /dev/null

done
echo done

sed -ri -e s/,\$/\}/g src/city/list/* src/city/listAll src/prefecture/listAll
