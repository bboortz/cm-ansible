#!/bin/bash

set -e
set -u

#
# global variables
#
OS=$( awk -F= '/^ID=/ {print $2}' /etc/*release )



#
# functions
#
f_info() {
	echo
	echo "INFO: $@"
}

f_error() {
	echo
	echo "ERROR: $@"
}



#
# program
#
{
	case $OS in
		debian)
			f_info "known operating system detected: $OS"
			which python > /dev/null 2>&1 && which virtualenv > /dev/null 2>&1 || (
				apt-get update
				DEBIAN_FRONTEND=noninteractive apt-get install -y python python-virtualenv 
			)
			;;
		arch)
			which python > /dev/null 2>&1 && which virtualenv > /dev/null 2>&1 || (
				f_info "known operating system detected: $OS"
				pacman -Sy --noconfirm --needed python python-virtualenv
			)
			;;
		*)
			f_error "unknown operating system detected: $OS"
			exit 1
			;;
	esac
}


