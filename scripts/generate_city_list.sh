#!/bin/sh -e
# generate resources for /city/list/:prefCode and /city/listAll
# License  CC BY 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

PATH=${0%/*}:$PATH
#by default, topojson has several additional dataset of geometries. So use it.
fmt=topojson

for d in src/city/list/name src/city/list/code;
do 
    [ -d $d ] && rm -rv $d
    mkdir -vp $d;
done

echo \{ \
    | tr -d \\\n \
    | tee src/city/list/name/all src/city/list/code/all > /dev/null

for i in $(seq -w 47);
do
	echo \{ | tr -d \\\n \
    | tee src/city/list/name/$i src/city/list/code/$i;
done

for i in src/$fmt/*.$fmt
do
	pref_code=$(cat $i | jq ".objects.city.geometries[].properties.N03_007" | tr -d \\\" | cut -c 1-2 )
	pref_name=$(cat $i | jq ".objects.city.geometries[].properties.N03_001")

	case $fmt in
		#(geojson) filter='.features[].properties| [.N03_004, .N03_007]';;
		(topojson) filter='.objects.city.geometries[].properties | if .N03_004 != null then [.N03_004, .N03_007] elif .N03_003 != null then [.N03_003, .N03_007] else ["東京23区", .N03_007] end';;
	esac
	## generate resources for /city/list/name/*
	filter="$filter | . as [\$a, \$b] | [{key: \$a, value: \$b}] | from_entries"
	cat $i \
		| jq "$filter" \
		| grep -vE \\\{\|\\\} \
		| tr \\\n ,\
		| sed -re s/\ \+//g \
		| tee -a src/city/list/name/$pref_code src/city/list/name/all > /dev/null

	## generate resources for /city/list/code/*
	alias_code=
	[ $pref_code -lt 10 ] && alias_code=${pref_code#0}
	cat $i \
		| jq "$filter" \
		| grep -vE \\\{\|\\\} \
		| tr \\\n ,\
		| sed -re s/\ \+//g -e "s/(.+):\"?([[:digit:]]+)\"?/\"\2\":\1/g" \
		| tee -a \
		  src/city/list/code/$pref_code \
		  ${alias_code:+src/city/list/code/$alias_code} \
		  src/city/list/code/all \
		  > /dev/null
done
echo done

sed -ri -e s/,\$/\}/g src/city/list/name/* src/city/list/code/* src/city/list/name/all src/city/list/code/all
