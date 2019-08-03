#!/bin/bash

## variable expansion 
## is all which has to do with the $ token
## it can have {}, too
## 

echo "using braces:"
echo ${!N*}
echo
echo "not using the braces:"
echo $N*
echo 
echo "the following creates a named variable, in case it still doesn't exist its gonna be created"
echo ${ASDFVAR:=1234}
echo "output the variable:"
echo $ASDFVAR
echo
echo "command expansions consist in using the backticks to print out the \`date\`: `date`"
echo "this is the same thing like using brackets \$(date): $(date)"
echo
echo "READY."

