#!/bin/bash

set -e
set -u
export PS1='$ '

#
# global variables
#
CURDIR="${0%/*}"
VENVDIR="${CURDIR}/.venv"
ANSIBLEDIR="${CURDIR}/ansible"
VERBOSE=""



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
	pip install --upgrade -r "${CURDIR}/requirements.txt"
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

