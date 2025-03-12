#! /usr/bin/env bash

# grab folder of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# grab input params / or fallback to defaults
reponame=${1:-"mr-sync"}
shaclfile=${2:-"${DIR}/shapes.ttl"}
gdburl=${3:-"http://localhost:7200"}

# validate the repo
curl -X POST \
    -H "Content-Type: text/turtle" \
    --data-binary "@${shaclfile}" \
    --url ${gdburl}/rest/repositories/${reponame}/validate/text

echo
exit 0