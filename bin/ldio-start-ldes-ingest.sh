#! /usr/bin/env bash

# grab folder of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# grab input params / or fallback to defaults
jobname=${1:-"mr-ldes-ingest-$$"}
ldesfeed=${2:-"https://www.marineregions.org/feed"}
repositoryid=${3:-"mr-sync"}
ldiourl=${4:-"http://localhost:8080"}
gdburl=${5:-"http://graphdb:7200"}   # INTERNAL URL sesnsible to ldio-workbench docker-service !

# use cat and envsubst to fill the env vars into the template to a temp file
export jobname ldesfeed
jobcfg=$(mktemp /tmp/tmp.${jobname}.yml.XXXXXX)  # use pattern to create a temp file
curlerr=$(mktemp /tmp/tmp.err.XXXXXX)  # use pattern to create a temp file
cat <<EOYML | envsubst > $jobcfg
name: ${jobname}
description: "ldes-ingest of ${ldesfeed} to ${repositoryid}"
input:
    name: Ldio:LdesClient
    config:
        materialisation:
            enabled: true
        urls:
            - ${ldesfeed}
        sourceformat: "text/turtle"
        state: "sqlite"
outputs:
    - name: "Ldio:RepositorySink"
      config:
          repositoryid: ${repositoryid}
          sparqlhost: ${gdburl}
          batchsize: 250
EOYML

# launch the job
echo "Using job config: ${jobcfg}"
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

# cleanup
rm ${jobcfg}
exit 0