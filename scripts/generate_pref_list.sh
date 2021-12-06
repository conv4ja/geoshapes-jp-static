#!/bin/sh -e
# generate resources for /prefecture/list/{code,name}
# License  CC BY 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

dir=src/prefecture/list;
[ -d $dir ] && rm -rv $dir
mkdir -p $dir

#cb header
echo \{ | tr -d \\\n \
	| tee src/prefecture/list/name src/prefecture/list/code \
	> /dev/null



for i in $(seq -w 1 47)
do
	#get last topojson for each prefecture
	ls -1 src/topojson/${i}*.topojson \
		| tail -1 \
		| {
			read last_file
			pref_name=$(cat $last_file | jq ".objects.city.geometries[].properties.N03_001" || echo error)

			#validation
			: ${pref_name:? pref_name not specified!}
			[ "$pref_name" = error ] && {
				echo "invalid pref name found for $i" >&2
				exit 1
			} 
			pref_name=$(echo $pref_name | tr -d \")

			#name keyed codes
			echo "\"$pref_name\":\"$i\"," \
				| tr -d \\\n \
				>> src/prefecture/list/name

			#code keyed names
			echo "\"$i\":\"$pref_name\"," \
				| tr -d \\\n \
				>> src/prefecture/list/code

		}
done 

sed -re s/,\$/\\\}/ -i src/prefecture/list/name src/prefecture/list/code 

# file validation
for i in src/prefecture/list/name src/prefecture/list/code 
do
	cat $i | jq . > /dev/null \
		|| { echo [failure] result json is corrupted: $i; exit 1; }
done
echo [prefecture/list] done
