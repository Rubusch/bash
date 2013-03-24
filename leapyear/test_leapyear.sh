#!/bin/bash
## test leap year interactively
##
## uses "read" to read input
##

echo "type a year to check (max. 4 digits), followed by ENTER"

read year

if (( ("$year" % 400) == "0" )) || (( ("$year" % 4 == "0") && ("$year" % 100 != "0") )); then
    echo "$year is a leap year"
else
    echo "this is not a leap year"
fi

echo "READY."
