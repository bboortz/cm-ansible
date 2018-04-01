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

f_bootstrap() {
	if [ -d "${VENVDIR}" ]; then
		return 
	fi

	f_info "bootstrapping virtualbox in $VENVDIR ..."
	virtualenv "${VENVDIR}"
	source ${VENVDIR}/bin/activate
	pip install --upgrade -r "${CURDIR}/requirements.txt"
}

f_playbook() {
	ansible-playbook -i "${ANSIBLEDIR}/hosts" -c local "${ANSIBLEDIR}/playbook.yml" -K $VERBOSE
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

