# cm-ansible

Config Management with ansible. Whitit you are able to manage your own linux distribution using ansible.
I wrote it to manage my own local infrastucture at home.


## Status

### Build
<a href='https://travis-ci.org/bboortz/cm-ansible'><img src='https://travis-ci.org/bboortz/cm-ansible.svg?branch=master'></a>


### Tested for
* Ubuntu 16.06
* Arch Linux
* Alpine (only via local testing)


## Usage

### Installation

To install the software please use the following steps:

```bash
git clone https://github.com/bboortz/cm-ansible.git
cd cm-ansible
sudo ./bin/install_dependencies.sh
```


### Run

* Running the config managment for a generic:
```bash
./bin/cm.sh <playbook>
```
* Running deploy playbook
```bash
sudo ./cm.sh deploy
```

* Running user backup playbook
```bash
./cm.sh user.backup
```

* Running user playbook
```bash
./cm.sh user.deploy
```


### Testing

* normal / containerized testing
```bash
./cm.sh test
```

* unit testing
```bash
./cm.sh test.unittest
```

* local testing different cases
```bash
./bin/test_local.sh
```

* testing with travis
using file .travis and script
```bash
./bin/test_travis.sh
```


### Special Environment Variables

* CM_MASTER_KEY
* CM_DEBUG
* CM_DRYRUN
* CM_DOCKER_IMAGE


#### CM_MASTER_KEY
* Running cm.sh using a master key for ansible vault
```bash
CM_MASTER_KEY=PATH_TO_KEYFILE ./cm.sh backup
```

#### CM_DEBUG
* Running cm.sh with debug output
```bash
CM_DEBUG=1 ./cm.sh deploy
```

#### CM_DRYRUN
* Running cm.sh with ansible dryrun using --check parameter
```bash
CM_DRYRUN=1 ./cm.sh deploy
```

#### CM_DOCKER_IMAGE
* Running cm.sh using a specified docker image
```bash
CM_DOCKER_IMAGE=debian:latest ./cm.sh test
```
