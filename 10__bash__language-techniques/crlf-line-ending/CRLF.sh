#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## find CRLF (dos) lineendings
##
## simple approach, to show dos lineendings: vi -b <filename>
## in general use 'dos2unix <filename>', in case in combination with find to
## avoid converting binary files
##
## this code snippet shows how to grep for "invisible characters" in files, 
## e.g. the '\r' in files

## get \r
CR="$(printf "\r")"

## then grep for this character within '/', also binaries may appear!!!
grep -Ilrs "$CR$" /

## another way to find CRLF, not on embedded systems is using file, e.g.
# find . -not -type d -exec file "{}" ";" | grep CRLF


## use ctrl-V ctrl-M to enter a literal ctrl-M

