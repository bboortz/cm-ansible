#!/bin/bash

set -e
set -u

DOCKER_IMAGE="${DOCKER_IMAGE:-python:2}"
DOCKER_MOUNTS="-v $(pwd)/ansible:/code/ansible -v $(pwd)/bin:/code/bin -v $(pwd)/requirements.txt:/code/requirements.txt -v $(pwd)/scripts:/code/scripts"

echo
echo "INFO: testing in docker image: ${DOCKER_IMAGE}"

docker run -t $DOCKER_MOUNTS "${DOCKER_IMAGE}" /bin/bash -c '/code/scripts/install_dependencies.sh && /code/bin/cm.sh deploy'
