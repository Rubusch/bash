#!/bin/bash
CHROOTSYS="$@"
if [[ -z $CHROOTSYS ]]; then
    echo "usage: $0 <folder>"
    echo "aborted."
    echo
	exit 1
fi

## umounts
sudo umount ${CHROOTSYS}/sys &> /dev/null
sudo umount ${CHROOTSYS}/proc &> /dev/null
sudo umount ${CHROOTSYS}/dev/pts &> /dev/null
sudo umount ${CHROOTSYS}/dev &> /dev/null

echo "READY."
echo




