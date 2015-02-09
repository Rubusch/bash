#!/bin/bash

## three positional parameters

POSPAR1="$1"
POSPAR2="$2"
POSPAR3="$3"

echo "$1 is the first positional parameter: \$1."
echo "$2 is the second positional parameter: \$2."
echo "$3 is the third positional parameter: \$3."
echo

echo "a special variable: \"\$#\""
echo "total number of positional parameters is $#."
