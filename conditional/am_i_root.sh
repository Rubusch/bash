#!/bin/bash

## shows if I am root

echo "am I root?"

if [ "$(whoami)" != 'root' ]
    then 
    echo "you are not root"
    echo "READY (within if clause)."
    exit 1;
fi
echo

echo "READY."