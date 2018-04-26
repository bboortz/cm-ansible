#!/bin/bash

set -e
set -u
export PS1='$ '



#
# global variables
#

# directories
CURDIR="$( readlink -f ${0%/*} )"
export ROOTDIR="${CURDIR}"
VENVDIR="${ROOTDIR}/.venv"
ANSIBLEDIR="${ROOTDIR}/ansible"

# ansible
#export ANSIBLE_INVENTORY="${ANSIBLEDIR}/hosts"
export ANSIBLE_ROLES_PATH="${ANSIBLEDIR}/roles"

# additional
source /etc/*release
VERBOSE="-vv"
CHECK=""
VAULT=""
OS=$( awk -F= '/^ID=/ {print $2}' /etc/*release )
PYTHON_VERSION="$( python --version 2>&1 )"
ANSIBLE_VERSION="$( ansible --version 2>&1 | head -n 1 )"
DOCKER_VERSION="$( docker version 2>&1 | awk '/^ Version:/ {print $2}' )"
DOCKER_API_VERSION="$( docker version 2>&1 | awk '/^ API version:/ {print $3}' )"


# 
# functions
#
f_start() {
	local params="$@"
	echo
	echo "###########################################"
	echo "# PROGRAM START"
        echo "# PPROGRAM: $0"
        echo "# PARAMETER: $params"
	echo "###########################################"
	if [ -n "${VERBOSE}" ]; then
		echo "# LINUX DISTRO: $OS"
		echo "# PYTHON VERSION: $PYTHON_VERSION"
		echo "# ANSIBLE VERSION: $ANSIBLE_VERSION"
		echo "# DOCKER VERSION: $DOCKER_VERSION"
		echo "# DOCKER API VERSION: $DOCKER_API_VERSION"
		echo "###########################################"
	fi
	[ -n "${CM_DEBUG:-}" ] && export | egrep "CM_" && echo "###########################################"
	[ -n "${CM_DEBUG:-}" ] && export | egrep "ANSIBLE_" && echo "###########################################"
	echo
}

f_exit() {
	local exitcode=$?
	echo
	echo "###########################################"
	echo "# PROGRAM END"
        echo "# EXIT CODE: $exitcode"
	echo "###########################################"
	echo
}

f_info() {
	echo
	echo "# INFO: $@"
}

f_debug() {
	if [ -n "${CM_DEBUG:-}" ]; then
		echo
		echo "# DEBUG: $@"
	fi
}

f_error() {
	echo
	echo "# ERROR: $@" >&2
}

f_usage() {
	echo
	echo "usage: $0 <playbook>"
	echo "example: $0 deploy"
	exit 1
}

f_activate_venv() {
	f_info "using virtualenv ${VENVDIR} ..."
	source ${VENVDIR}/bin/activate
}

f_install_requirements() {
	f_info "install packages into ${VENVDIR} ..."
	pip install --upgrade -r "${ROOTDIR}/requirements.txt"
}

f_bootstrap() {
	if [ -d "${VENVDIR}" ]; then
		f_activate_venv
		return

	elif [ -n "${VIRTUAL_ENV:-}" ]; then
		VENVDIR="${VIRTUAL_ENV}"
		f_activate_venv
		f_install_requirements
	
	else
		f_info "creating virtualenv in $VENVDIR ..."
		virtualenv "${VENVDIR}"
		f_activate_venv
		f_install_requirements

	fi
}

f_test_playbook() {
	local playbook="${1}"
	f_info "testing playbook ${playbook} ..."
	ansible-lint "${playbook}"
}

f_playbook() {
	local routine="${1}"
	local playbook="${ANSIBLEDIR}/${routine}.yml"

	if [ ! -f "${playbook}" ]; then
		f_error "playbook not found: $playbook"
		exit 1
	fi

	f_test_playbook "${playbook}"

	f_info "running playbook $playbook ..."
	case $routine in
		user.*)
			export ANSIBLE_INVENTORY="${ANSIBLEDIR}/hosts_user"
			;;
		*)
			;;
	esac
	cmd="ansible-playbook -i inventory.py ${VERBOSE} ${CHECK} ${VAULT} -c local ${playbook}"
	f_debug "using cmd: $cmd"
	$cmd
}


#
# program
#
{
	# setting verbose mode if needed
	if [ -n "${CM_DEBUG:-}" ]; then
		f_info "debug mode on"
		VERBOSE="-vvvvvv"
	fi

	# starting up
	trap f_exit EXIT
	f_start "$@"

	# setting dry-run mode if needed
	if [ -n "${CM_DRYRUN:-}" ]; then
		f_info "dry-run mode on"
		CHECK="--check"
	fi

	# setting ansible vault password file if needed
	if [ -n "${CM_MASTER_KEY:-}" ]; then
		f_info "using master key: ${CM_MASTER_KEY}"
		VAULT="--vault-password-file=${CM_MASTER_KEY}"
	fi

	# checking the parameter
	if [ -z "${1:-}" ]; then
		f_error "no parameter passed to program."
		f_usage
	fi

	# bootstrapping the local environment
	f_bootstrap

	# running the playbook
	f_playbook ${1}
}



