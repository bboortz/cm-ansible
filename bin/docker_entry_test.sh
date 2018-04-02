#!/bin/sh

set -e
set -u

#
# global variables
#

# directories
CURDIR="$( readlink -f ${0%/*} )"
ROOTDIR="${CURDIR%/*}"



#
# program
#
${ROOTDIR}/bin/install_dependencies.sh 
${ROOTDIR}/cm.sh deploy
