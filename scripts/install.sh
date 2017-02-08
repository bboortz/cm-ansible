#!/bin/bash

set -i
set -u
export PS1='$ '

OLD_DIR=$( pwd )
CM_DIR=$( readlink -f ${0%/*/*} )


sudo apt-get update && apt-get upgrade -y
sudo apt-get install -y aptitude git python python-dev python-apt openssh-server libyaml-cpp-dev libssl-dev gcc virtualenv gcc

cd ${CM_DIR}
virtualenv .venv
source .venv/bin/activate
pip install --upgrade pip ansible
cd "$OLD_DIR"
