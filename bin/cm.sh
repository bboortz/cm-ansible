#!/bin/bash

set -e
set -u
export PS1='$ '



#
# global variables
#

# directories
CURDIR="$( readlink -f ${0%/*} )"
ROOTDIR="${CURDIR%/*}"
VENVDIR="${ROOTDIR}/.venv"
ANSIBLEDIR="${ROOTDIR}/ansible"

# ansible
ANSIBLE_INVENTORY="${ANSIBLEDIR}/hosts"

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
	echo "# ERROR: $@" >&2
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
		f_info "using virtualenv ${VENVDIR} ..."
		source ${VENVDIR}/bin/activate
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
	local playbook="${ANSIBLEDIR}/playbook.yml"
	f_info "running playbook $playbook ..."
	ansible-playbook -i "${ANSIBLEDIR}/hosts" -c local "${playbook}" $VERBOSE
}


#
# program
#
{
	trap f_exit EXIT
	f_start "$@"
	f_bootstrap

	if [ -n "${CM_DEBUG:-}" ]; then
		f_info "debug mode on"
		VERBOSE="-vvvv"
	fi

	f_playbook
}

