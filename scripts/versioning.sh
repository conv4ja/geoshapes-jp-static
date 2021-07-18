#!/bin/sh
# versioning.sh: make version file
# Lisence  CC BY-SA 4.0
# Author   Suzume Nomura <suzume315[at]g00.g1e.org>

version=$(git tag -l | sort | tail -1)
: ${version:="nover"}
echo "{\"version\":\"$version\"}" > src/version
touch src/health
