#!/bin/bash -e
##
## demonstrates the usage of shift
##

USAGE="usage: $0 <arg1> <arg2> <arg3> ... <argN>"

## check if $# (list of command line arguments) was empty
if (( "$#" == "0" )); then
    echo "$USAGE"
    exit 1
fi

idx="1"
while ((  "$#" )); do
    echo -n "$idx. "
    if [[ "$1" == "asdf" ]]; then
	echo "don't do asdf!!!"
    else
	echo "$1"
    fi
    ## the shift shifts $1 to the next element in $# - so that the content
    ## in the loops always only treats $1
    shift
    idx=$[$idx+1]
done

echo "READY."
