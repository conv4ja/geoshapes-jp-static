#!/bin/sh -e
# sln.sh: generate symbolic links for resources
# Lisence  CC BY-SA 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>


for fmt in geojson topojson pbf
do
    if 
	[ -d src/$fmt ]
    then 
	for f in src/$fmt/*.$fmt
        do
	    basename=${f##*/}
	    pref_code=$(echo $basename | cut -c 1-2)
	    case $fmt in
		(topojson)
		    base_filter=.objects.city.geometries\[\].properties ;;
		(geojson)
		    base_filter=.features\[\].properties ;;
		(pbf)
		    city_name=; base_filter= ;;
	    esac
	    filter="
	    $base_filter
	    | if .N03_004 != null 
	    then .N03_003, .N03_004 
	    elif .N03_003 != null 
	    then .N03_003, .N03_004
	    else \"東京23区\" 
	    end
	    "
	    [ -n "$base_filter" ] && {
		city_fullname=$(cat $f |jq "$filter" | sed -r \
		    -e "s/[, ^]?null[ $]?//g" \
		    | tr -d \\\n\",\\\ \\\[\\\])

		city_name=$(cat $f |jq "$filter" | sed -r \
		    -e "s/^[^郡]+郡//g" \
		    -e "s/[, ^]?null[ $]?//g" \
		    | tr -d \\\n\",\\\ \\\[\\\])
	    }


	    [ ! -d src/$fmt/$pref_code ] && mkdir -vp src/$fmt/$pref_code
	    {
		: ${basename:?basename not set}
		sln=${f%%.$fmt}
		[ -h ${sln:?sln not set} ] && force=1
		ln -sv ${force:+-f} ${basename} ${sln}
		sln=src/$fmt/$pref_code/${basename%.$fmt}
		ln -sv ${force:+-f} ../${basename} ${sln}
		[ -n "$city_name" ] && {
			sln=src/$fmt/$pref_code/${city_name}
			ln -sv ${force:+-f} ../${basename} ${sln} \
				|| ln -sv ${force:+-f} ../${basename} ${sln}2
			sln=src/$fmt/$pref_code/${city_fullname}
			ln -sv ${force:+-f} ../${basename} ${sln} 2> /dev/null || :
		}
	    } 
        done &
    else 
	echo skipping $fmt
    fi
done
wait
