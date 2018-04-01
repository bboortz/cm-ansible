# cm-ansible

Config Management with ansible. Whitit you are able to manage your own linux distribution using ansible.
I wrote it to manage my own local infrastucture at home.


## Status

### Build
<a href='https://travis-ci.org/sebdah/git-pylint-commit-hook'><img src='https://travis-ci.org/bboortz/cm-ansible.svg?branch=master'></a>


### Tested for
* Ubuntu 16.06
* Arch Linux
* Alpine (manually)


## Usage

### Installation

To install the software please use the following steps:

```bash
git clone https://github.com/bboortz/cm-ansible.git
cd cm-ansible
./scripts/install_dependencies.sh
```


### Run

* Running the config managment for a generic:
```bash
./bin/cm.sh <playbook>
```
* Running deploy playbook
```bash
./cm.sh deploy
```


### Testing

* normal / containerized testing
```bash
./cm.sh test
```

* local testing different cases
```bash
./bin/test_local.sh
```
```

