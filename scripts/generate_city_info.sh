#!/bin/sh -e
# index.sh: create index files for prefectural shape data
# Lisence  CC BY-SA 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

fmt=topojson
resource=src/city/info
[ ! -d $resource ] && mkdir -vp $resource

parseJSON(){
	filter=".objects.city.geometries[].properties 
	| if .N03_004 == null 
		then {"prefName":.N03_001, "cityName":.N03_003, "cityCode":.N03_007, "id": .id} 
		else {"prefName":.N03_001, "cityName":.N03_004, "cityCode":.N03_007, "id":.id} 
	end"
	cat $@ | jq "$filter"
}

for i in src/$fmt/*.$fmt
do
	pref_code=$(cat $i | jq ".objects.city.geometries[].properties.N03_007" | tr -d \\\" | cut -c 1-2 )
	pref_name=$(cat $i | jq ".objects.city.geometries[].properties.N03_001" | tr -d \\\")
	pref_list="${pref_list}{\"$pref_name\":$pref_code},"
	for d in $resource/$pref_code $resource/$pref_name
	do
	    [ ! -d $d ] && mkdir -vp $d
	done

	#generate resources
	for j in $i
	do
	    {
		city_name=$(parseJSON $j | jq .cityName | tr -d \" )
		city_code=$(parseJSON $j | jq .cityCode | tr -d \" )
		city_id=$(parseJSON $j | jq .id | sed -re s/.+:// | tr -d \" )
		parseJSON $j | tr -d \\\n\\\  | tee $resource/$city_code > /dev/null
		ln -sv ../$city_code $resource/$pref_code/$city_code
		ln -sv ../$city_code $resource/$pref_name/$city_code
		ln -sv ../$city_code $resource/$pref_code/$city_name \
			|| ln -sv ../$city_code $resource/$pref_code/${city_name}2
		ln -sv ../$city_code $resource/$pref_name/$city_name \
			|| ln -sv ../$city_code $resource/$pref_name/${city_name}2
		ln -sv $city_code $resource/$city_id
	    } &
	done
	wait
done
