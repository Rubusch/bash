#!/bin/bash
##
## find CRLF (dos) lineendings

## get \r 
CR="$(printf "\r")"

## then grep for this character within '/', also binaries may appear!!!
grep -Ilrs "$CR$" /

## another way to find CRLF, not on embedded systems is using file, e.g.
# find . -not -type d -exec file "{}" ";" | grep CRLF


## use ctrl-V ctrl-M to enter a literal ctrl-M

