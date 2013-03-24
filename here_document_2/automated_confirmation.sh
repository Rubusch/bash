#!/bin/bash
##
## demonstrates automated confirmation using "here documents"
##

if [ $# -lt 1 ]; then
    echo "usage: $0 <packagename>"
    exit 1
fi

echo "installing automatically.."
#yum install $1 <<CONFIRM
#y
#CONFIRM
echo "confirmed by 'y'"
echo "READY."

