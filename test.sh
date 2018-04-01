#!/bin/bash

set -e
set -u

DOCKER_IMAGE="${DOCKER_IMAGE:-python:2}"

echo
echo "INFO: testing in docker image: ${DOCKER_IMAGE}"

docker run -t -v $(pwd):/code "${DOCKER_IMAGE}" /bin/bash -c '/code/cm.sh'
