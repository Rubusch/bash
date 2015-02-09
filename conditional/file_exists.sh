#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

## check if a given file (as argument $1) exists

if [ ! $# -eq 1 ] ; then
    echo "filename missing error"
    echo "Usage ./fileexits.sh <filename>"
    exit 1;
fi

FILENAME="$1"

if [ -f $FILENAME ] ; then
    echo "size is $(ls -lh $FILENAME | awk '{ print $5 }' )"
    echo "type is $(file $FILENAME | cut -d":" -f2 -)"
    echo "inode number is $(ls -i $FILENAME | cut -d" " -f1 -)"
    echo "$(df -h $FILENAME | grep -v Mounted | awk '{ print "On",$1", which is mounted as the",$6,"partition."}')"
else
    echo "file does not exist"
fi
echo

echo "READY."

