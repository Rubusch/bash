#!/bin/bash -e
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## if-else-example, comparison of number of arguments with $#
##
## uses arguments:
## ./fatorfruit.sh <weight> <height>


## number comparison 
##
## $# is the argument counter
## in bash (!) comparison with $# should use '((' and '))'
if (( $# < 2 )) ; then
    echo "usage: ./fatorfruit.sh <weight> <height>"
    exit 1;
fi


## demo code...
weight="$1"
height="$2"
idealweight=$[height - 110]
if [[ $weight -le $idealweight ]] ; then
    echo "you should eat a bit more fat"
else
    echo "you should eat a bit more fruit"
fi
echo
echo "READY."
