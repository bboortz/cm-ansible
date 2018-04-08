#!/bin/bash

set -e
set -u

CM_DOCKER_IMAGE="${CM_DOCKER_IMAGE:-python:2}"

echo
echo "INFO: testing in docker image: ${CM_DOCKER_IMAGE}"

docker run -t -v $(pwd):/code "${CM_DOCKER_IMAGE}" /bin/bash -c '/code/bin/install_dependencies.sh && CM_DRYRUN=1 /code/cm.sh deploy && /code/cm.sh deploy'
