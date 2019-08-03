#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## leapyear_clumsy.sh
##
##

echo "tests in a clumsy way for a leap year"

year=`date +%Y`

if [ $[$year % 400] -eq "0" ]; then
    echo "this is a leap year, february has 29 days (outer control)"

elif [ $[$year % 4] -eq 0 ]; then
   if [ $[$year % 100] -ne 0 ]; then
       echo "this is a leap year, february has 29 days (inner control)"
   else
       echo "this is not a leap year, february has 28 days (inner control)"
   fi

else
    echo "this is not a leap year, feburary has 28 days (outer control)"
fi

echo "READY."
