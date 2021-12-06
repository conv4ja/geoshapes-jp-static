#!/bin/sh -ex
# clean.sh: clean all source files but shape files
# License  CC BY 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

for d in src/city src/prefecture src/pbf
do
    [ -d $d ] && rm -rv $d
done
for d in src/topojson src/geojson 
do
find $d -type f \
    ! \( \
      -name \*.geojson \
      -or -name \*.topojson \
    \) -exec rm -v {} \; &
find $d -type l -exec rm -v {} \; &
done
wait && echo done
