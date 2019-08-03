#!/bin/bash
## variableoperations
##
## demonstrates the usage of the substring feature
##

echo "variable operations:"
echo

STRING=thisisaverylongname
STARTIDX=0

while true; do
    # generate the output
    TMP=${STRING:$STARTIDX}

    ## if output already is empty - break
    ##
    ## this is the same like setting an 'if' in front 
    ## and putting the '&&' part into the clause
    [ -z "${TMP:-}" ] && break; 

    ## if not, print the new output
    echo "\${STRING: $STARTIDX } = $TMP"

    ## generate next index
    STARTIDX=$[$STARTIDX+1]
done

echo "READY."