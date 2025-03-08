#! /usr/bin/env bash

# grab folder of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# grab input params / or fallback to defaults
gdburl=${1:-"http://localhost:7200"}

# get list of repos
curl -X GET \
    ${gdburl}/rest/repositories \
    -H 'Accept: application/json' \
    -o - \
    -s 2>/dev/null | jq -r ".[] | {id,state}"
echo 