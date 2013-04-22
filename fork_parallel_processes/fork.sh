#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## demonstrates a fork of a process running in parallel, but being terminated on
## termination of the running main script
##
## in case find the parent PID as follows
#PID_PRNT=$$
##

## prevent usage of uninitialized variables
set -u

## forward declaration
PID_CHLD=""

## traps on all catchable signals, in case an SIGABORT also will stop the child
trap 'terminate' TERM INT EXIT
function terminate()
{
    kill $PID_CHLD 2>/dev/null
    exit
}


## Script start ################################################################

## fork child and PID
FILENAME="`date +20%y%m%d_%H%M`_cpustats.log"
(./cpu_stat.sh 0.2 > ${FILENAME})&
PID_CHLD=$!

## parent
for item in `seq 10`; do
    echo "do something..."
    sleep 1
done

echo "`basename $0` - READY."
echo
exit 0
