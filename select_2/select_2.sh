#!/bin/bash
##
## demonstrates the usage of select, using a "case" to provide a method to exit
##
## select - case
##

echo "select demo"

PS3="your choice: "
QUIT="quit this program"
touch "$QUIT"

select FILENAME in *;
do
  case $FILENAME in
      "$QUIT")
	  echo "exiting"
	  break
	  ;;
      *)
	  echo "you picked $FILENAME ($REPLY)"
	  ;;
  esac
done

echo "READY."
