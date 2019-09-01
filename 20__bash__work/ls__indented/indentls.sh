#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## simple example of use case that appears from time to time,
## - have a directory content listed in one column
## - avoid further adornments to the files/folders
## - have element in a separate eline (prepared for bash arrays)
## => ls -1
##
## - present the content indented,
## => sed...
ls -1 | sed 's/^/  /'

echo "READY."
echo
