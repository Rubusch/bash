#!/bin/bash

## if-else-example
## uses arguments:
## ./fatorfruit.sh <weight> <height>

## $# is the argument counter
if [ ! $# == 2 ] ; then
    echo "usage: ./fatorfruit.sh <weight> <height>"
    exit 1;
fi

weight="$1"
height="$2"

idealweight=$[height - 110]

if [ $weight -le $idealweight ] ; then
    echo "you should eat a bit more fat"
else
    echo "you should eat a bit more fruit"
fi

echo
echo "READY."
