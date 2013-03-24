#!/bin/bash
## leapyear_boolean.sh
##
##

echo "checks for a leap year by a boolean check"

year=`date +%Y`

if (( ("$year" % 400) == "0" )) || (( ("$year" % 4 == "0") && ("$year" % 100 != "0") )); then
    echo "this is a leap year, february has 29 days"
else
    echo "this is not a leap year, february has 28 days"
fi

echo "READY."
