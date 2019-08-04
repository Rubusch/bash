#!/bin/bash
##
## calculate the average of a series of numbers
##
## contains no possibility to check for digits or characters
##

SCORE="0"
AVERAGE="0"
SUM="0"
NUM="0"

while true; do
    echo -n "enter your score [0 - 100%] ('q' for quit): "; read SCORE;
    if(("$SCORE" < "0")) || (("$SCORE" > "100")); then
	echo "be serious - come on, try again: "
    elif [ "$SCORE" == "q" ]; then
	echo "average rating: $AVERAGE%."
	echo "$NUM values entered"
	break
    else
	SUM=$[$SUM + $SCORE]
	NUM=$[$NUM + 1]
	AVERAGE=$[$SUM / $NUM]
    fi

done
echo "READY."
