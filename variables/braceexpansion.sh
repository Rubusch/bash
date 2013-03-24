#!/bin/bash

## demonstrates "brace expansion"
## brace expansion can be nested
##
## ATTENTION: "${" doesn't work!
## - brace expansion must contain unquoted opening and closing braces
## - incorrectly formed brace expansion is left unchanged

echo sp{el,il,al}l
echo
