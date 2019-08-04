#!/bin/bash
##
## generates a backup package to be stored on backup device
## this is NO version control system, such as e.g. git!!!

## function: usage
usage()
{
cat <<EOF
usage: $0 <path to basefolder>
EOF
}

clean()
{
    ## errors about missing folders might be normal here,
    ## they come from 'find' complaining about folders
    ## actually being removed right now.
    [[ ! -d "${1}" ]] && die "folder '${1}' does not exist"
    echo "cleaning..."

    echo "...\*~"
    find ${1} -name "*~" -exec rm -rf {} \;

    echo "cleaning done."
}


die()
{
    echo "ERROR: $@"
    exit 1
}

### START ###
(( $# != 1 )) && usage && exit 1

## check if valid path was passed, else display usage - ABORT
[ ! -d "${1}" ] && echo "directory does not exist" && exit 1

basefolder=${1%/}

## clean folder
clean "${basefolder}"

## pack basefolder
echo "packing..."
echo "tar cJf $(date +"20%y%m%d__")$(basename ${basefolder}).tar.xz $(basename ${basefolder})"
tar cJf "$(date +"20%y%m%d__")$(basename ${basefolder}).tar.xz" "$(basename ${basefolder})"

echo "READY."
