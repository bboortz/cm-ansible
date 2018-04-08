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

echo ------------------------
pwd
ls -la
ls -la /code
export CM_DEBUG=1
echo ------------------------
CM_DRYRUN=1 ${ROOTDIR}/cm.sh deploy
${ROOTDIR}/bin/install_dependencies.sh 
${ROOTDIR}/cm.sh deploy
