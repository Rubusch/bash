#!/bin/bash
##
## example for a trap usage
##
## the programm catches SIGINT and SIGTERM, e.g. CTRL + C
## commands from the console (try!)
##
##

echo "trap example"

trap "echo Booh!" SIGINT SIGTERM

echo "own pid is $$, stop script with:"
echo "$> kill -9 $$"

while :
do
  sleep 60
done

echo "READY."
