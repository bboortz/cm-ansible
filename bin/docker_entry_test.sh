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
CM_DRYRUN=1 ${ROOTDIR}/cm.sh deploy
${ROOTDIR}/cm.sh deploy
