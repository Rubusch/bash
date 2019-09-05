#!/bin/bash -e
##
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

(( $# != 1 )) && usage && exit 1
[[ ! -d "${1}" ]] && echo "directory does not exist" && exit 1


## remove trailing slash
basefolder=${1%/}


echo "$basefolder"
echo "READY"
