#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## Makefile to do the disktest.sh using switch case clauses
##
##

space=`df -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -`

case $space in
    [1-6]*)
        Message="all is quiet"
	;;

    [7-8]*)
        Message="start thinking about cleaning out some stuff. there's a partition that is $space % full"
	;;

    9[1-8])
        Message="better hurry with htat new disk... one parition is $space % full"
	;;

    99)
        Message="I'm drowing here! There's a partition at $space %!"
	;;

    *)
        Message="I seem to be running with an nonexistent amount of disk space..."
	;;
esac

echo $Message
echo "READY."
