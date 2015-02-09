#!/bin/bash

## removes a trailing slash of a provided path name
##
## $ ./remove_trailing_slash.sh /opt/
## /opt
##
## in case there is no trailing slash, it does not
## change anything
##
## $ ./remove_trailing_slash.sh /opt
## /opt
##

usage()
{
cat <<EOF
usage: $0 <a valid path>
EOF
}

## check command line arguments
(( $# != 1 )) && usage && exit 1

## check if valid path was passed, else display usage - ABORT
[ ! -d "${1}" ] && echo "directory does not exist" && exit 1

## remove trailing slash
basefolder=${1%/}

## print result
echo "$basefolder"

echo "READY"
