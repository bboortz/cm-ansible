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
# functions
#
f_test_routine() {
	local routine="$1"
	CM_DRYRUN=1 ./cm.sh "${routine}"
	sudo -E ./cm.sh "${routine}"
}

f_test_routines() {
	# test local deploy
	f_test_routine deploy
}


f_test_role() {
	local role="${1}"
	role_short="${role##*/}"
	echo
	echo
	echo "#############################################"
	echo "# TESTING ROLE"
	echo "# ROLE: $role_short"
	echo "# ROLE DIR: $role"
	echo "#############################################"
	export ANSIBLE_INVENTORY="/home/benni/projects/cm-ansible/ansible/hosts" 
	export ANSIBLE_ROLES_PATH="/home/benni/projects/cm-ansible/ansible/roles" 

	case ${role_short} in
		backup)
			CM_DRYRUN=1 ansible-playbook -vvvvvvv  -c local ${role}/tests/test.yml
			;;
		os_upgrade)
			sudo -E ansible-playbook -vvvvvvv  -c local ${role}/tests/test.yml
			;;
		*)
			ansible-playbook -vvvvvvv  -c local ${role}/tests/test.yml
			;;
	esac
}

f_test_roles() {
	# test all roles
	export ANSIBLE_INVENTORY="/home/benni/projects/cm-ansible/ansible/hosts" 
	export ANSIBLE_ROLES_PATH="/home/benni/projects/cm-ansible/ansible/roles" 

	for role in ${ROOTDIR}/ansible/roles/*; do
		f_test_role "${role}"
	done
}



#
# program
#
{
	f_test_roles
	# f_test_routines
}




