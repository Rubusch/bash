#!/bin/bash -e
##
## how to grep in a multiline variable
##

OUTPUT=`cat /proc/stat`
echo "OUTPUT '$OUTPUT'"
echo

CPU=$(printf "%s\n" "$OUTPUT" | grep "intr ")
echo "grepped LINE '$CPU'"

echo "READY."
