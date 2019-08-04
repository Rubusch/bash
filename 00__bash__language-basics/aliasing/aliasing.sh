#!/bin/bash

## aliasing - TODO


echo "1. we set up an alias: dh = 'df -h'"
alias dh='df -h' 

## in shell script you need to expand aliases as shell script option: shopt
shopt -s expand_aliases

echo
echo "2. we'll test the alias:"
dh

echo
echo "3. no we'll unalias again"
unalias dh

echo
echo "4. we'll test the alias:"
dh

echo
echo "READY."
