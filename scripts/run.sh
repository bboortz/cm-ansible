#!/bin/bash

set -i
set -u
export PS1='$ '

.venv/bin/ansible-playbook -v -i ansible/hosts -c local ansible/playbook.yml
