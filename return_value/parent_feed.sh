#!/bin/bash
## Makefile for a parent/child script structure, 
## this is the parent script
##
## 

export menu="$1"
export animal="$2"

feed="./child_penguin.sh"

echo "feed the penguin"

$feed $menu $animal

## switch - case
## evaluates the $? variable, which holds the return value of the sub-script
## set by the "exit" function
case $? in
    1)
	echo "Guard: you'd better give'm a fish, less they get violent.."
	;;

    2)
	echo "Guard: it's because of people like you that they are leaving earth all the time.."
	;;
    
    3)
	echo "Guard: buy the foot that the zoo provides for the animals, how do you think we survive?"
	;;

    *)
	echo "Guard: don't forget the guide!"
	;;
esac

echo "READY."