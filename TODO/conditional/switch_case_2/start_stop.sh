#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## Makefile to demonstrates switch / case clauses
## in form of an initscript
##
##

echo "initscript like exemple"

## check if there is a commandline argument
if [ ! $# -eq 1 ] ; then
    echo "argument missing error"
    echo "Usage: $0 <argument>"
    exit 1;
fi


## switch case example
case "$1" in
    ## some clauses
    start)
	echo "case start"
	;;

    stop)
	echo "case stop"
	;;

    status)
	echo "case status"
	;;

    restart)
	echo "case restart"
	echo "stop"
	echo "start"
	;;

    condrestart)
	echo "if x is pid of proggy ;then restart"
	echo "restart"
	;;

    ## default clause
    *)
	echo $"Usage: $0 {start|stop|restart|condrestart|status}"
	exit 1
esac

echo "READY."
