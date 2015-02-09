#!/bin/bash
##
## demonstrates the usage of select
##
## sets up a menu to select a filename by a number interactively
##

echo "select demo (type \"quit\" to exit)"

select FILENAME in *;
do 
  echo "you picked $FILENAME ($REPLY)"
  if [ $REPLY == "quit" ]; then break; fi
done

echo "READY."
