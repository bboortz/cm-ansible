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

f_install_packages_deb() {
	apt-get update
	DEBIAN_FRONTEND=noninteractive apt-get install -y python python-virtualenv docker
}

f_install_packages_arch() {
	pacman -Syu --noconfirm --needed python python-virtualenv docker
}



#
# program
#
{
	case $OS in
		debian)
			f_info "known operating system detected: $OS"
			which python > /dev/null 2>&1 && which virtualenv > /dev/null 2>&1 || f_install_packages_deb
			;;
		ubuntu)
			f_info "known operating system detected: $OS"
			which python > /dev/null 2>&1 && which virtualenv > /dev/null 2>&1 || f_install_packages_deb
			;;
		arch)
			f_info "known operating system detected: $OS"
			which python > /dev/null 2>&1 && which virtualenv > /dev/null 2>&1 || f_install_packages_arch
			;;
		*)
			f_error "unknown operating system detected: $OS"
			exit 1
			;;
	esac
}


