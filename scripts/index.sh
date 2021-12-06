#!/bin/sh -e
# index.sh: create index files for prefectural shape data
# License  CC BY-SA 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

[ ! -d src/prefecture ] && mkdir -vp src/prefecture
pref_list="["
echo \[ | tr -d \\\n | tee src/city/listAll src/list/listAll.json > /dev/null 

fmt=topojson
	for i in src/$fmt/??
        do
	    pref_code=${i##*/}
	    pref_name=$(cat $(ls -1 $i | head -1) | jq ".objects.city.geometries[].properties.N03_001")
	    pref_list="${pref_list}{\"$pref_name\":$pref_code},"
	    pref_metadata=$(cat $(ls -1 $i | head -1) | jq "{.objects.city.geometries[].properties.N03_001: $code}")

	    #resources def
	    res_cityList=src/city/list
	    res_cityInfo=src/city/info
	    res_prefList=src/prefecture/info
	    for d in $res_cityList $res_cityInfo $res_prefList
	    do
	        [ ! -d $d ] && mkdir -vp $d
	    done

	    #generate /city/list/:prefCode
	    ls -1 $i \
		| egrep -v "list(.json)?$" \
		| egrep "\.$fmt$" \
		| tr \\\n , \
		| sed -r \
			-e s/\^/\[/ \
			-e s/,\$/\]\\\n/ \
			-e "s/([[:digit:]]+)\.$fmt/\"\1\"/g" \
		| tee $res_cityList/$pref_code > $res_cityList/$pref_code.json \
		&& echo "generated $res_cityList/$pref_code" &

	    #generate /city/list/:prefCode
            case $fmt in
	    	#(geojson) filter='.features[].properties| [.N03_004, .N03_007]';;
	    	(topojson) filter='.objects.city.geometries[].properties | if .N03_004 != null then [.N03_004, .N03_007] else [.N03_003, .N03_007] end';;
            esac
	    filter="$filter | . as [\$a, \$b] | [{key: \$a, value: \$b}] | from_entries"

	    parseJSON(){ cat $@ | jq "$filter" 2> /dev/null; }
	    writeList(){
		parseJSON $i/*.$fmt \
		| grep -vE \\\{\|\\\} \
		| tr \\\n ,\
		| sed -r \
		    -e s/\ \+//g \
		    -e s/\^/\"$pref_name\":\[/ \
		    -e s/,\?\$/\],/ 
	    }
	    writeList \
		| tee -a src/city/listAll src/list/listAll.json > /dev/null \
		&& echo generated /list/$pref_code &

	    #generate /city/info/:cityCode
	    for j in $i/*.$fmt
	    do
	        filter=".objects.city.geometries[].properties 
		    | if .N03_004 == null 
		        then {"prefName":.N03_001, "cityName":.N03_003, "cityCode":.N03_007, "id": .id} 
		        else {"prefName":.N03_001, "cityName":.N03_004, "cityCode":.N03_007, "id":.id} 
		    end"
		city_name=$(parseJSON $j | jq .cityName | tr -d \" )
		city_code=$(parseJSON $j | jq .cityCode | tr -d \" )
		city_id=$(parseJSON $j | jq .id | sed -re s/.+:// | tr -d \" )
		parseJSON $j | tee src/city/info/$city_code > /dev/null
		ln -svf src/city/info/$city_code src/city/info/$city_id
		ln -svf src/city/info/$city_code src/city/info/$city_name
	    done
        done 
wait && {
    pref_list="${pref_list%,}]"
    echo "$pref_list" | tee src/prefecture/listAll > src/prefecture/listAll.json
    echo \] | tr -d \\\n | tee -a src/city/listAll src/city/listAll.json > /dev/null 
    echo done
} 
