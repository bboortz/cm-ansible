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

# test all roles
for role in ${ROOTDIR}/ansible/roles/*; do
	ANSIBLE_INVENTORY="/home/benni/projects/cm-ansible/ansible/hosts" ANSIBLE_ROLES_PATH="/home/benni/projects/cm-ansible/ansible/roles" ansible-playbook -vvvvvvv  -c local ${role}/tests/test.yml
done

# test local deploy
sudo CM_DRYRUN=1 ./cm.sh deploy
sudo ./cm.sh deploy

# run test in different docker container
CM_DOCKER_IMAGE=python:2 ${ROOTDIR}/cm.sh test
CM_DOCKER_IMAGE=ubuntu:16.04 ${ROOTDIR}/cm.sh test
CM_DOCKER_IMAGE=debian:latest ${ROOTDIR}/cm.sh test


