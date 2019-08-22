#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## demonstrates execution of commands and calculation
##
## then prints a message


## 1. execute calculation: '$[' and ']'
WEEKOFFSET=$[ $(date +"%V") % 2 ]

## 2. execute command: '$(' and ')'
WEEKNUMBER=$(date +"%V")


## demo code....
echo "week number:"
echo ${WEEKNUMBER}
echo "weekoffset:"
echo $WEEKOFFSET
if [ $WEEKOFFSET -eq "0" ]; then
    echo "sunday evening: put down the garbage cans, week's even"
fi
echo "READY."
