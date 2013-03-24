#!/bin/bash
##
## lexicographical comparison with external tools
##

cavemonster="green"
furrymonster="blue"

printf "cavemonster: '%s', furrymonster: '%s'\n" $cavemonster $furrymonster


echo "res, before: '$?'"
awk -v v1="$cavemonster" -v v2="$furrymonster" 'BEGIN { exit !(v1 "" < "" v2) }'
echo "res, after: '$?'"
echo


echo "expr cavemonster and furrymonster"
echo "res, before: '$?'"
expr "x$cavemonster" "<" "x$furrymonster" >/dev/null
echo "res, after: '$?'"
echo


echo "compare cavemonster and furrymonster"
echo "res, before: '$?'"
printf "%s\n" "x$cavemonster" "x$furrymonster" | sort -c >/dev/null 2>&1
echo "res, after: '$?'"
echo

## let
idx=0; echo "dash let '$idx'"
: $((idx=idx+1))
echo "after, '$idx'"
echo

echo READY.