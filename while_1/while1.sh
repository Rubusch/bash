#!/bin/bash
##
## demonstrates a simple example for a while loop
##

echo "counting from 0 to 3"

idx="0"
while [ $idx -lt 4 ];
  do
  echo "idx == $idx"
  idx=$[$idx+1]
done

echo "READY."
