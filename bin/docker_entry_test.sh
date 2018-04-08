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

export CM_DEBUG=1
${ROOTDIR}/bin/install_dependencies.sh 
CM_DRYRUN=1 ${ROOTDIR}/cm.sh deploy
${ROOTDIR}/cm.sh deploy
