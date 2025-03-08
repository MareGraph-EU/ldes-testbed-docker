#! /usr/bin/env bash

# grab folder of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# grab input params / or fallback to defaults
jobname=${1:-"mr-ldes-store"}
ldiourl=${2:-"http://localhost:8080"}

curl -X 'DELETE' \
    ${ldiourl}/admin/api/v1/pipeline/${jobname} \
    -H 'accept: application/json' \
    -o - \
    -s 2>/dev/null \
    | jq -r '.'
echo