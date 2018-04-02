#!/bin/bash

set -e
set -u
export PS1='$ '



#
# global variables
#

# directories
CURDIR="$( readlink -f ${0%/*} )"
ROOTDIR="${CURDIR}"
VENVDIR="${ROOTDIR}/.venv"
ANSIBLEDIR="${ROOTDIR}/ansible"

# ansible
export ANSIBLE_INVENTORY="${ANSIBLEDIR}/hosts"
export LOCAL_ANSIBLE_PYTHON_INTERPRETER=$( which python 2>&1 )

# additional
source /etc/*release
OS=$( awk -F= '/^ID=/ {print $2}' /etc/*release )
VERBOSE=""
PYTHON_VERSION="$( python --version 2>&1 )"
ANSIBLE_VERSION="$( ansible --version 2>&1 | head -n 1 )"



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
	echo "# LINUX DISTRO: $OS"
	echo "# PYTHON VERSION: $PYTHON_VERSION"
	echo "# ANSIBLE VERSION: $ANSIBLE_VERSION"
	echo "###########################################"
	export | egrep "CM_" && echo "###########################################"
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
	export LOCAL_ANSIBLE_PYTHON_INTERPRETER="${VENVDIR}/bin/python"
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

f_playbook() {
	local playbook="${ANSIBLEDIR}/${1}.yml"

	if [ ! -f "${playbook}" ]; then
		f_error "playbook not found: $playbook"
		exit 1
	fi
	f_info "running playbook $playbook ..."
	ansible-playbook ${VERBOSE} -c local "${playbook}" $VERBOSE
}


#
# program
#
{
	# starting up
	trap f_exit EXIT
	f_start "$@"

	# checking the parameter
	if [ -z "${1:-}" ]; then
		f_error "no parameter passed to program."
		f_usage
	fi

	# bootstrapping the local environment
	f_bootstrap

	# setting verbose mode if needed
	if [ -n "${CM_DEBUG:-}" ]; then
		f_info "debug mode on"
		VERBOSE="-vvvv"
	fi

	# running the playbook
	f_playbook ${1}
}

