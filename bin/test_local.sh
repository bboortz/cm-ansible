#!/bin/bash

set -e
set -u

#
# global variables
#

# directories
export PS1='$ '
CURDIR="$( readlink -f ${0%/*} )"
ROOTDIR="${CURDIR%/*}"
source "${ROOTDIR}/.venv/bin/activate"


#
# program
#

# test local deploy
CM_DRYRUN=1 ./cm.sh deploy
./cm.sh deploy

# test all roles
for role in ${ROOTDIR}/ansible/roles/*; do
	echo "ROLE: $role"
	ANSIBLE_INVENTORY="/home/benni/projects/cm-ansible/ansible/hosts" ANSIBLE_ROLES_PATH="/home/benni/projects/cm-ansible/ansible/roles" ansible-playbook -vvvvvvv  -c local ${role}/tests/test.yml
done

# run test in different docker container
#CM_DOCKER_IMAGE=python:2 ${ROOTDIR}/cm.sh test
#CM_DOCKER_IMAGE=ubuntu:16.04 ${ROOTDIR}/cm.sh test
#CM_DOCKER_IMAGE=debian:latest ${ROOTDIR}/cm.sh test



