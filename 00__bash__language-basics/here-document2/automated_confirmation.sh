#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## demonstrates automated passing input to a tool
## e.g. here confirmation using "here documents"
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

