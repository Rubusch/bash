#!/bin/bash
##
## demonstrates the usage of select, using a "case" to provide a method to exit
##
## select - case
##

echo "select demo"

PS3="your choice: "
QUIT="quit this program"

# select offers to select files
#
# for this example to show two possible choices
# we make a touch on "quit this program"
touch ${QUIT}

select FILENAME in *; do
  case $FILENAME in
    "$QUIT") # if we choose the file "quit this program", this case statement will break and exit
      echo "exiting"
	  break
	  ;;
    *)
	  echo "you picked $FILENAME ($REPLY)"
	  ;;
  esac
done

# don't forget to remove the "quit this program" file
echo "READY."
