#!/bin/sh
# licensing.sh: make license resource
# License  CC BY 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

upstream_name="Asanobu KITAMOTO, ROIS-DS Center for Open Data in the Humanities"
upstream_credit="『歴史的行政区域データセットβ版』（CODH作成）"
upstream_license="CC BY 4.0"
upstream_url="https://geoshape.ex.nii.ac.jp/city/"

original_name="国土交通省"
original_url="http://nlftp.mlit.go.jp/ksj/"
original_credit="http://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-N03.html"

license="CC BY 4.0"
url="https://github.com/conv4ja/geoshapes-jp-static"

list_authors(){
	cat < AUTHORS \
		| while read line 
			do
				echo "\"$line\"," | tr -d \\\n 
			done \
		| sed -re s/,\$// 
}

dump_resource(){
	cat <<EOF
{
	"license":"$license",
	"name":"geoshapes-jp-static",
	"url":"$url",
	"upstream": [
		{
			"name:":"$upstream_name",
			"license":"$upstream_license",
			"url":"$upstream_url",
			"credit":"$upstream_credit"
		},{
			"name":"$original_name",
			"license":"$upstream_license compatible",
			"url":"$original_url",
			"credit":"$original_credit"
		}
	],
	"authors":[
		$(list_authors)
	]
}
EOF
}

dump_resource \
	| jq . \
	| sed -re s/\^\ \+//g \
	| tr -d \\\n \
	> src/license
