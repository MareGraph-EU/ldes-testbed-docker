#! /usr/bin/env bash

# grab folder of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# grab input params / or fallback to defaults
reponame=${1:-"test-repo"} 
gdburl=${2:-"http://localhost:7200"}

# perform delete
curl -X DELETE \
    ${gdburl}/rest/repositories/${reponame}
    -o - \
    -s 2>/dev/null
echo