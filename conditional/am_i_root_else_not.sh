#!/bin/bash

## shows if I am root

echo "am I root?"

if [ "$(whoami)" != 'root' ]
    then 
    echo "you are not root"
    echo "READY (within if clause)."
    exit 1;

    else
    echo "you are root"
fi
echo

echo "READY."