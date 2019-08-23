#!/bin/bash -e
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## checks if a certain file exists
##

echo "checking..."

## checking existence of regular file: -f
if [[ -f /data/programmieren/bash/notes.txt ]]; then
    echo "file exists"
fi
echo

echo "checking if globbing is set:"

## checking variable set: -o
if [[ -o noglobber ]]; then
    echo "files are protected against accidental overwriting using redirection"
fi
echo

echo "compare variables:"

## comparing variables: -eq
if [[ $? -eq 0 ]]; then
    echo "that was easy"
fi
echo

echo "READY."
