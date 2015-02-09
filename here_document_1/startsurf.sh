#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## provides a list of browsers and permits to start one of those
##
## demonstrates the "here documents" pipe <<
##
echo "these are the web browsers on this system:"

## start "here document"
cat << BROWSERS
mozilla
links
lynx
konqueror
opera
netscape
BROWSERS
## end "here document"

## ask for favorite
echo -n "which is your favorite [ENTER]? "
read browser
echo "starting $browser, please wait.."

## start and unlink to the console..
# $browser &
