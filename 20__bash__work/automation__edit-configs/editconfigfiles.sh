#!/bin/bash -e
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## check entry in config file
## in case append
## if present, reset value
##

function die()
{
    echo "ERROR: $@"
    exit 1
}

ICPATH="0.55.07"
## env
echo "check and setup environment variables"

## backup
CONFIGFILE="${HOME}/removeme/.testrc"

###
echo -n "backup '${CONFIGFILE}' [y|n]? "
read UINPUT
[[ "y" == "${UINPUT}" ]] && cp "${CONFIGFILE}" "${CONFIGFILE}.orig"


## check ICPATH
if [[ -z "$(grep "^[ ]*export ICPATH=" -r ${CONFIGFILE})" ]]; then
    echo "append ICPATH entry to '${CONFIGFILE}'"
    echo "" >> "${CONFIGFILE}"
    echo "## IC test environment settings" >> "${CONFIGFILE}"
    echo "export ICPATH=\"${ICPATH}\"" >> "${CONFIGFILE}"
else
    echo "edit ICPATH entry in '${CONFIGFILE}'"
    sed -i "/^[ ]*export ICPATH=/s/=.*\$/=\"${HOME////\/}\/ISNewGen_${ICPATH}\"/g" "${CONFIGFILE}" || die "failed to edit '${CONFIGFILE}'"
fi


## export DeploymentPath
if [[ -z "$(grep "^[ ]*export DeploymentPath=" -r ${CONFIGFILE})" ]]; then
    echo "append DeploymentPath '${DeploymentPath}' to '${CONFIGFILE}'"
    echo "export DeploymentPath=${HOME}/Work/Deployment/ubu_10.04" >> "${CONFIGFILE}"
else
    echo "edit DeploymentPath in '${CONFIGFILE}'"
    sed -i "/^[ ]*export DeploymentPath=/s/=.*\$/=\"${HOME////\/}\/Work\/Deployment\/ubu_10.04\"/g" "${CONFIGFILE}" || die "failed to edit '${CONFIGFILE}'"
fi


## export LD_LIBRARY_PATH
if [[ -z "$(grep "^[ ]*export LD_LIBRARY_PATH=" -r ${CONFIGFILE} | grep "DeploymentPath")" ]]; then
    echo "extend LD_LIBRARY_PATH in DeploymentPath in '${CONFIGFILE}'"
    echo 'export LD_LIBRARY_PATH=${DeploymentPath}/lib:${LD_LIBRARY_PATH}' >> "${CONFIGFILE}"
else
    echo "edit LD_LIBRARY_PATH in '${CONFIGFILE}'"
    sed -i '/^[ ]*export LD_LIBRARY_PATH=/s/=.*$/="${DeploymentPath}\/lib:${LD_LIBRARY_PATH}"/g' "${CONFIGFILE}" || die "failed to edit '${CONFIGFILE}'"
fi

## simenv call
echo "check 'simenv' command in '${CONFIGFILE}'"
if [[ ! -z "$(grep "^[ ]*simenv[ ]*" -r ${CONFIGFILE})" ]]; then
    ## remove 'simenv'
    sed -i 's/^[ ]*simenv[ ]*//' "${CONFIGFILE}" || die "failed to edit '${CONFIGFILE}'"
fi
## append 'simenv' at the end
echo "append 'simenv' to '${CONFIGFILE}'"
echo -n 'simenv' >> "${CONFIGFILE}"
###

echo "done"
echo


echo "READY."
echo
