#!/bin/bash
##
## how to grep in a multiline variable


OUTPUT=`cat /proc/stat`
echo "OUTPUT '$OUTPUT'"
echo

CPU=$(printf "%s\n" "$OUTPUT" | grep "cpu ")
echo "LINE '$CPU'"

echo "READY."