#!/bin/bash
##
## demonstrates a while true declaration
##
## "make your choices" uses a "document list" to loop over
##

echo "make your fortune demo"

FORTUNE=/usr/games/fortune
while true; do
    echo "select one of the topics"
    cat << topics
politics
startrek
kernelnewbies
sports
bofh-excuses
magic
love
literature
drugs
education
quit
topics
    echo 

    ## get input form the user
    echo -n "make your choice: "
    read topic
    echo

    ## do an answer
    if [ $topic == "quit" ]; then
	echo "ok, quit"
	exit 0
    else
	echo "you selected $topic: "
	echo
	$topic
	echo
    fi
done

echo "READY."
