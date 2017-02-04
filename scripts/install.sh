#!/bin/bash

set -i
set -u
export PS1='$ '

sudo apt-get update && apt-get upgrade -y
sudo apt-get install -y git python python-dev openssh-server libyaml-cpp-dev libssl-dev gcc virtualenv gcc 

virtualenv .venv
source .venv/bin/activate
pip install --upgrade pip ansible
