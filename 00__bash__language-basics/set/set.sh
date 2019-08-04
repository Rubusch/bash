#!/bin/bash
##
## set

## exit if any command or function results in non-zero value
set -e

## turn off exit on error / non-zero values for commands or functions
set +e

## turn on debugging
set -x

echo "turn off debugging"
set +x

echo

set -x
echo "turn off debugging, but hide the set command"
{ set +x ; } 2> /dev/null

## stop on uninitialized variables
set -u

echo
printf "READY\n"
