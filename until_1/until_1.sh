#!/bin/bash
##
## demonstrates the usage of the until loop
##


echo "counts up to 3"
idx="0"

## the until command uses inverse logic: do something UNTIL something else is true
until [ $idx -gt 3 ]; do
    echo "idx = $idx"
    idx=$[$idx+1]
done

echo "READY."
