#!/bin/bash
##
## packer for doing backups
##

## function: usage
usage()
{
cat <<EOF
usage: $0 <path to basefolder>
EOF
}

## function: clean
clean()
{
    ## errors about missing folders might be normal here,
    ## they come from 'find' complaining about folders
    ## actually being removed right now.
    [[ ! -d "${1}" ]] && die "folder '${1}' does not exist"
    echo "cleaning..."

    echo "...db"
    find ${1} -name "db" -exec rm -rf {} \;

    echo "...incremental_db"
    find ${1} -name "incremental_db" -exec rm -rf {} \;

    echo "...output_files"
    find ${1} -name "output_files" -exec rm -rf {} \;

    echo "...\*.rpt"
    find ${1} -name "*.rpt" -exec rm {} \;

    echo "...synthesis"
    find ${1} -name "synthesis" -exec rm -rf {} \;

    echo "....qsys_edit"
    find ${1} -name ".qsys_edit" -exec rm -rf {} \;

    echo "...\*~"
    find ${1} -name "*~" -exec rm {} \;

    echo "...\*.bak"
    find ${1} -name "*.bak" -exec rm {} \;

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

