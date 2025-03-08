# basic variant docs

# steps for basic cases

## before you start / when you're done

The scripts in `./bin/` assume you have a running docker stack described in the provided `docker/docker-compose.yaml` file.

See section below on hwo to use those.

## case 1 test ldes get only

```bash
# start it
$ bin/ldio-start-ldes-get.sh  my-job-name-here https://host.name/ldes-feed-link

# check it
$ bin/ldio-list-pipes.sh

# stop it (you need the exact jobname as argument)
$ bin/ldio-stop-pipe.sh  my-job-name-here
```

## case 2 test ldes ingest and validation

```bash
# prepare the store to hold the harvested content
$ bin/gdb-make-repo.sh repo-name-here  # you can check it at http://localhost:7200/

# start the ingest job
$ bin/ldio-start-ldes-ingest.sh  my-job-name-here https://host.name/ldes-feed-link repo-name-here

# use the ldio-listing to wait for ldes sybc to be complete --> state == "SYNCHRONISING"
$ bin/ldio-list-pipes.sh

# you can optionally stop it (or keep it syncing up) with the command described in case 1

# validate the stored content and save shacl-validation-report
$ bin/gdb-validate-repo.sh repon-name-here path/to/some-shacl.ttl > /tmp/report.ttl
```

# general stuff

## how to use the embedded docker stack

```bash
# start the stack before you use the scripts
$ docker compose -f docker/docker-compose.yaml up -d

# check the logs of the ldio-workbench component as needed
$ docker compose -f docker/docker-compose.yaml logs -f ldio-workbench

# stop the stack when all is done
$ docker compose -f docker/docker-compose.yaml down
```

## how to grab and poll for errors in the ldes-client pipeline?

There is no decent automated way to do this, so you simply has to manually keep an eye on the console log for now.

## how to manage gdb repos

Note: The embedded graphdb service component in the docker-stack provides its own browser based UI at http://localhost:7200/

Next to this the `./bin/gdb-*.sh` scripts alllow to do some reop-management actions from the command-line

The usage of these is pretty straightforward:

### to make a new repo

```bash
$ ./bin/gdb-make-repo.sh «repo-name» «gdb-url»
```

Here:

- `«repo-name»` is a unique own chosen name for the repo to be created
- `«gdb-url»` (typically http://localhost:9200) is the base-url for the graphdb service

### to list the available repos

```bash
$ ./bin/gdb-list-repo.sh «gdb-url»
```

Here:

- `«gdb-url»` (typically http://localhost:9200) is the base-url for the graphdb service

### to drop an existing repo

```bash
$ ./bin/gdb-drop-repo.sh «repo-name» «gdb-url»
```

Here:

- `«repo-name»` is one of the names listed in the previous command
- `«gdb-url»` (typically http://localhost:9200) is the base-url for the graphdb service

### to validate the content of one gdb repo using SHACL

```bash
$ ./bin/gdb-validate-repo.sh «repo-name» «shacl-file» «gdb-url»
```

Here:

- `«repo-name»` is one of the names listed in the earlier gdb-list command
- `«shacl-file»` path to a local file holding the shacl rules to validate the repo contents
- `«gdb-url»` (typically http://localhost:9200) is the base-url for the graphdb service

We recomend to

- either redirect the output a ttl formatted shacl validation report to a local file, by adding `> /path/to/output.ttl`
- either grep for the meaningfull result, by adding `| grep sh:conforms`
