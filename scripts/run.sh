#!/bin/bash

set -i
set -u

OLD_DIR=$( pwd )
CM_DIR=$( readlink -f ${0%/*/*} )

cd ${CM_DIR}/ansible
${CM_DIR}/.venv/bin/ansible-playbook -v -i hosts -c local playbook.yml

cd "$OLD_DIR"
