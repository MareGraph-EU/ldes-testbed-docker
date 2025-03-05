#! /usr/bin/env bash

# grab folder of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# grab input params / or fallback to defaults
jobname=${1:-"mr-ldes-get-$$"}
ldesfeed=${2:-"https://www.marineregions.org/feed"}
ldiourl=${3:-"http://localhost:8080"}

# use cat and envsubst to fill the env vars into the template to a temp file
export jobname ldesfeed
jobcfg=$(mktemp /tmp/tmp.${jobname}.yml.XXXXXX)  # use pattern to create a temp file
cat <<EOYML | envsubst > $jobcfg
name: ${jobname}
description: "test pipeline for ldes-get of ${ldesfeed}"
input:
  name: Ldio:LdesClient
  config:
    urls:
      - ${ldesfeed}
outputs:
  - name: "Ldio:ConsoleOut"
EOYML


echo "Using job config: ${jobcfg}"
cat ${jobcfg}
yamllint ${jobcfg}

curl -X 'POST' \
  ${ldiourl}/admin/api/v1/pipeline \
  -H 'accept: application/json' \
  -H 'Content-Type: application/yaml' \
  --data-binary "@${jobcfg}" \
  -o - \
  -s 2>/dev/null \
  | jq -r "{name: .name, status: .status, description: .description}"
echo

echo "Started job with name '${jobname}'"