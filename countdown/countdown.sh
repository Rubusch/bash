#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##

countdown()
{
    n=$1
    echo "waiting ${n}s (press CTRL-C to abort)..."
    echo "$2 in: "
    while [ $n -gt 0 ] ; do echo -n "$n " ; sleep 1 ; (( n=n-1 )) ; done
    echo
}


countdown 10 "continuing"

echo "READY."
echo
