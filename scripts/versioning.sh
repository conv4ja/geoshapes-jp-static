#!/bin/sh
# versioning.sh: make version file
# License  CC BY 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

version=$(git tag -l | sort | tail -1)
: ${version:="nover"}
echo "{\"version\":\"$version\", \"language\":\"ja\"}" > src/version
touch src/health
