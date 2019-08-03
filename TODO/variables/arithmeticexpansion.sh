#!/bin/bash

## arithmetic expansion
## prints out an arithmetic expression using $((...))
##

echo "arithmetic expressions use \$((3+4)): 3 + 4 = $((3+4))"
echo "this doesn't do overflow checks!"
echo 
echo "it is always better to use the following syntax $[365*24]"
echo "READY."
