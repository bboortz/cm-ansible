#!/bin/bash

set -e
set -u

#
# global variables
#

# directories
CURDIR="$( readlink -f ${0%/*} )"
ROOTDIR="${CURDIR%/*}"


#
# program
#
sudo CM_DRYRUN=1 ./cm.sh deploy
sudo ./cm.sh deploy
CM_DOCKER_IMAGE=python:2 ${ROOTDIR}/cm.sh test
CM_DOCKER_IMAGE=ubuntu:16.04 ${ROOTDIR}/cm.sh test
CM_DOCKER_IMAGE=debian:latest ${ROOTDIR}/cm.sh test


