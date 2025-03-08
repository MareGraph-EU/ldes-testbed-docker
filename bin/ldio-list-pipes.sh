#! /usr/bin/env bash

# grab folder of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# grab input params / or fallback to defaults
ldiourl=${1:-"http://localhost:8080"}

# get list of active pipelines
echo "pipelines:"
curl -X GET \
    ${ldiourl}/admin/api/v1/pipeline \
    -H 'Accept: application/json' \
    -o - \
    -s 2>/dev/null \
    | jq -r '.[] | {name: .name, status: .status, ldesfeed: .input.config."urls.0"}'   # TODO narrow down the output to the relevant fields (name, status)
echo 

# get list of active ldes-clients
echo "ldes-clients:"
curl -X GET \
    ${ldiourl}/admin/api/v1/pipeline/ldes-client \
    -H 'Accept: application/json' \
    -o - \
    -s 2>/dev/null \
    | jq 
echo 
