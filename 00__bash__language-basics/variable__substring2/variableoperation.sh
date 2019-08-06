#!/bin/bash
## variableoperations
##
## demonstrates the usage of the substring feature
##

echo "variable operations:"

STRING=somestring
STARTIDX=0
OFFSET=${#STRING}

while true; do
    echo 

    # generate the output
    TMP=${STRING:$STARTIDX}

    ## if output already is empty - break
    ##
    ## this is the same like setting an 'if' in front
    ## and putting the '&&' part into the clause
    [ -z "${TMP:-}" ] && break;

    ## get offsets
    OFFSET=${#TMP}

    while true; do
	TMP=${STRING:$STARTIDX:$OFFSET}
	[ -z "${TMP:-}" ] && break;

	## formatting one or two tabs ;-)
	if [ ${#TMP} -lt 3 ]; then
	    echo -e "\${ $TMP :\t\t\t $STARTIDX : $OFFSET } = $TMP"
	else
	    echo -e "\${ $TMP :\t\t $STARTIDX : $OFFSET } = $TMP"
	fi
	OFFSET=$[$OFFSET-1]
    done
    OFFSET=$OFFSET_ORIG

    ## generate next index
    STARTIDX=$[$STARTIDX+1]
done

echo "READY."
