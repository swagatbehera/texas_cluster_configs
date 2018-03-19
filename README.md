# Introduction
This repository is a collection of recipes and blueprint templates to bring up cluster using cloudbreak.

# How to bring up a cluster

## Configuring Cloudbreak cli (one time)
Execute the following to configure credentials for cloudbreak cli.
```bash
cb configure --username <<cloudbreak-username>> --server cloud.eng.hortonworks.com --password <<cluodbreak-password>>
```

## Login to Hortonworks internal docker registry (one time)
```bash
docker login registry.eng.hortonworks.com
```

Provide your sso/okta credentials to login

## Bringing up actual cluster
The following command will bring up a cluster using [texas_cluster_creator](https://github.com/hortonworks/texas_cluster_creator). This can be verified using [cloudbreak ui](https://cloud.eng.hortonworks.com/clusters).
```bash
docker run -v ${HOME}/.cb:/root/.cb:ro -v $(pwd)/hdf/3.1-secure/input:/input -v $(pwd)/hdf/3.1-secure/output:/output registry.eng.hortonworks.com/qaas/texas_cluster_creator:latest create <<unique-cluster-name>> /input /output
```
Explanation of parts of the command:
- `-v ${HOME}/.cb:/root/.cb:ro` will mount your's `${HOME}/.cb` to `/root/.cb` as readonly inside the container. Same goes for other -v arguments that are mounting as read/write dirs.
- `registry.eng.hortonworks.com/qaas/texas_cluster_creator:latest` is the image that will be used for launching container
- `create raghav-test-cluster /input /output` arguments are the arguments that are being passed

For debugging you can run bash inside the container
```bash
docker run -v ${HOME}/.cb:/root/.cb:ro -v $(pwd)/hdf/3.1-secure/input:/input -v $(pwd)/hdf/3.1-secure/output:/output --rm -it --entrypoint /bin/bash registry.eng.hortonworks.com/qaas/texas_cluster_creator:latest
```

## Know issues and solutions
- Unable to reach/ping cloud.eng.hortonworks.com from inside container: try resetting docker to factory defaults. It will setup networking from scratch which seems to resolve issue.
