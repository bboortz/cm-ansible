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
DOCKER_IMAGE=python:2 ${ROOTDIR}/cm.sh test
DOCKER_IMAGE=ubuntu:16.04 ${ROOTDIR}/cm.sh test
DOCKER_IMAGE=debian:latest ${ROOTDIR}/cm.sh test


