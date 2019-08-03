#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## how to extract the last two characters of a string

FOO="ASDF77"
echo "string: '$FOO'"
echo ""

## sed
echo "using sed"
echo $FOO | sed 's/^.*\(..\)$/\1/'
echo ""

## awk
echo "using awk"
echo $FOO | awk '{ print substr( $0, length($0)-1, length($0)) }'
echo ""

## in context
result=$(echo $FOO | sed 's/^.*\(..\)$/\1/' )
echo "result: '$result'"

echo "READY."
echo ""