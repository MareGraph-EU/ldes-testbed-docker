#! /usr/bin/env bash

# grab folder of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# grab input params / or fallback to defaults
reponame=${1:-"test-repo"} 
gdburl=${2:-"http://localhost:7200"}
repocfg_template=${3:-"${DIR}/gdb-repo-config-template.ttl"}

# use cat and envsubst to fill the env vars into the template to a temp file
export reponame
repocfg=$(mktemp /tmp/tmp.${reponame}.ttl.XXXXXX)  # use pattern to create a temp file
cat $repocfg_template | envsubst > $repocfg

echo "Using repocfg in temp file ${repocfg}"

# create the repo
curl -X POST \
     ${gdburl}/rest/repositories \
     -H 'Content-Type: multipart/form-data' \
     -F "config=@${repocfg}" \
     -o - \
     -s 2>/dev/null
echo

# cleanup
rm ${repocfg}