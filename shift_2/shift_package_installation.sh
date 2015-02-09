#!/bin/bash
##
## demonstrates the usage of shift in a package installation script
##

echo "package installation"

## check if argument list was empty
if [ $# -lt 1 ]; then
    echo "usage: $0 <package1> <packate2> ... <packageN>"
    exit 1
fi

while (( $# )); do
    echo "do a confirmed download - commented!"
#    aptitude install $1 << CONFIRM
#y
#CONFIRM
    shift
done

echo "READY."
