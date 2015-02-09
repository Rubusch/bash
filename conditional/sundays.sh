#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## sundays
## calculates if the weeknumber is even
## then prints a message

## calculate
WEEKOFFSET=$[ $(date +"%V") % 2 ]

## week number
echo "week number:"
echo $(date +"%V")

echo "weekoffset:"
echo $WEEKOFFSET

if [ $WEEKOFFSET -eq "0" ]; then
    echo "sunday evening: put down the garbage cans, week's even"
## | mail -s "garbage cans out" you@yourdomain.org
fi

echo "READY."