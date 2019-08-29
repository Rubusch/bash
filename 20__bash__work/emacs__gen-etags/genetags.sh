#!/bin/bash -e
##
## script to generate etags code tags file for emacs and c/c++ code files
## exuberant-ctags plugin needs to be installed to emacs, running the script
## without arguments shows help
##

## try
#set -e

## debug
#set -x

die()
{
    echo
    echo "!!! "
    echo "ERROR (${BASH_SOURCE[0]}, ${FUNCNAME[1]}, ${BASH_LINENO[1]}): $1"
    echo "!!! "
    echo
    exit 1
}

usage()
{
cat <<EOF
the script generates etags for c/c++ code to be used in emacs

usage: `basename $0` <path to the project folder>

- each folder contained in the project folder is one project,
- for each of this projects a TAGS file will be generated,
- in a separate folder
EOF
exit 1
}

## entry check
if (( $# == 0 )); then usage; die "### FAiLED ###"; fi
BASEPATH=$1

## get dir list
[[ ! -d $BASEPATH ]] && die "'$BASEPATH' no valid directory path"
DIRLIST=( $(find $BASEPATH -maxdepth 1 -type d -exec basename {} \; | egrep ^[^\.]) )

for item in ${DIRLIST[*]}; do
    echo "item '$item'"

    ## generate folder for each dirlist entry
    [[ ! -d $item ]] && mkdir ./$item
    cd ./$item

    [[ -f ./TAGS ]] && mv ./TAGS ./TAGS.orig

    ## run etags command and create TAGS file
    [[ -d $BASEPATH$item ]] && find $BASEPATH$item -regex ".*\.\(cc\|cpp\|c\|h\|hpp\)$" -exec etags -a {} \;
    cd -
done

echo "READY."
echo
